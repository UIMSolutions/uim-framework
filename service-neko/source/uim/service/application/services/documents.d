/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Application service implementing the IEntitySetProvider driving port on
/// top of the IDocumentStore driven port. Gives a service a fully working,
/// tenant isolated entity set without any custom code — ideal for master
/// data, prototypes and tests. Business rules can be added via hooks.
module uim.service.application.services.documents;

import std.uuid : randomUUID;
import uim.service;
import uim.service.ports.services.context;
import uim.service.ports.services.entitysets;
import uim.service.ports.storages.documents;

mixin(ShowModule!());

@safe:

class DocumentEntitySetProvider : IEntitySetProvider {
  protected IDocumentStore store;
  protected string collection;
  protected string keyProperty;

  /// Stamp tenantId / createdAt / createdBy / updatedAt / updatedBy.
  bool stampAudit = true;

  /// Called before a document is stored (create and update); throw
  /// EntitySetException to reject. `existing` is Json(null) on create.
  void delegate(const RequestContext ctx, Json existing, ref Json document) @safe beforeSave;

  /// Called before a document is removed; throw to veto.
  void delegate(const RequestContext ctx, Json document) @safe beforeRemove;

  this(IDocumentStore store, string collection, string keyProperty = "id") {
    this.store = store;
    this.collection = collection;
    this.keyProperty = keyProperty;
  }

  Json[] list(const RequestContext ctx) {
    auto rows = store.all(collection, ctx.tenantId);
    // stable default order: creation time, then key
    rows.sort!((a, b) {
      auto ca = textOf(a, "createdAt"), cb = textOf(b, "createdAt");
      return ca != cb ? ca < cb : textOf(a, keyProperty) < textOf(b, keyProperty);
    });
    return rows;
  }

  Json get(const RequestContext ctx, string key) {
    return store.get(collection, ctx.tenantId, key);
  }

  Json create(const RequestContext ctx, Json payload) @trusted {
    auto doc = payload.clone;
    auto key = keyProperty in doc ? keyString(doc[keyProperty]) : "";
    if (key.length == 0) {
      key = randomUUID.toString;
      doc[keyProperty] = key;
    } else if (store.get(collection, ctx.tenantId, key).type != Json.Type.null_) {
      throw EntitySetException.conflict("Entity '" ~ key ~ "' already exists");
    }
    if (stampAudit) {
      auto now = nowIso();
      doc["tenantId"] = ctx.tenantId;
      doc["createdAt"] = now;
      doc["createdBy"] = ctx.actor;
      doc["updatedAt"] = now;
      doc["updatedBy"] = ctx.actor;
    }
    if (beforeSave !is null)
      beforeSave(ctx, Json(null), doc);
    store.put(collection, ctx.tenantId, key, doc);
    return doc;
  }

  Json update(const RequestContext ctx, string key, Json payload) {
    auto existing = store.get(collection, ctx.tenantId, key);
    if (existing.type == Json.Type.null_)
      throw EntitySetException.notFound("Entity '" ~ key ~ "'");
    auto doc = existing.clone;
    foreach (name, value; payload.get!(Json[string]))
      if (name != keyProperty)
        doc[name] = value;
    if (stampAudit) {
      doc["updatedAt"] = nowIso();
      doc["updatedBy"] = ctx.actor;
    }
    if (beforeSave !is null)
      beforeSave(ctx, existing, doc);
    store.put(collection, ctx.tenantId, key, doc);
    return doc;
  }

  void remove(const RequestContext ctx, string key) {
    auto existing = store.get(collection, ctx.tenantId, key);
    if (existing.type == Json.Type.null_)
      throw EntitySetException.notFound("Entity '" ~ key ~ "'");
    if (beforeRemove !is null)
      beforeRemove(ctx, existing);
    store.remove(collection, ctx.tenantId, key);
  }

  private static string textOf(Json row, string name) {
    return row.isObject && name in row ? keyString(row[name]) : "";
  }
}

/// Current UTC time as ISO 8601 with milliseconds (Edm.DateTimeOffset).
string nowIso() @trusted {
  auto t = Clock.currTime(UTC());
  t.fracSecs = msecs(t.fracSecs.total!"msecs");
  return t.toISOExtString;
}

///
unittest {
  mixin(ShowTest!("DocumentEntitySetProvider"));

  import uim.service.persistence.storages.documents.memory : MemoryDocumentStore;

  auto p = new DocumentEntitySetProvider(new MemoryDocumentStore, "Things");
  p.beforeSave = (const RequestContext ctx, Json existing, ref Json doc) @safe {
    if ("name" in doc && doc["name"].get!string == "forbidden")
      throw EntitySetException.invalid("name not allowed");
  };

  auto a = RequestContext.local("a", "test", "alice");
  auto b = RequestContext.local("b", "test");

  auto payload = Json.emptyObject;
  payload["name"] = "one";
  auto created = p.create(a, payload);
  auto id = created["id"].get!string;
  assert(created["createdBy"].get!string == "alice" && created["tenantId"].get!string == "a");
  assert(p.list(a).length == 1 && p.list(b).length == 0);
  assert(p.get(b, id).type == Json.Type.null_);

  auto patch = Json.emptyObject;
  patch["name"] = "uno";
  patch["id"] = "hijack";
  assert(p.update(a, id, patch)["name"].get!string == "uno");
  assert(p.get(a, id)["id"].get!string == id);

  bool rejected;
  patch["name"] = "forbidden";
  try
    p.update(a, id, patch);
  catch (EntitySetException e)
    rejected = e.status == 400;
  assert(rejected);

  auto fixed = Json.emptyObject;
  fixed["id"] = "k1";
  p.create(a, fixed);
  bool conflict;
  try
    p.create(a, fixed);
  catch (EntitySetException e)
    conflict = e.status == 409;
  assert(conflict);

  p.remove(a, id);
  assert(p.list(a).length == 1);
}
