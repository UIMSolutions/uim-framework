/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Driving ports for entity-set oriented adapters.
///
/// A service exposes each of its aggregates once as an IEntitySetProvider
/// (usually a thin wrapper around its use cases). The generic OData v4,
/// CLI and GtkD adapters of this library all drive the same providers, so a
/// service gets all three front ends from a single implementation.
///
/// Rows are exchanged as flat JSON objects whose property names match the
/// EDM model (see uim.service.presentation.odata.model).
module uim.service.ports.services.entitysets;

import uim.service;
import uim.service.ports.services.context;

mixin(ShowModule!());

@safe:

/// Failure of an entity-set operation that maps to a protocol status code.
/// Adapters translate it (HTTP status / CLI exit code / GUI dialog).
class EntitySetException : Exception {
  int status; /// HTTP-like status: 400, 403, 404, 405, 409, 422, 500
  string code; /// machine readable code, e.g. "NotFound"

  this(int status, string code, string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow {
    super(msg, file, line);
    this.status = status;
    this.code = code;
  }

  static EntitySetException notFound(string what) pure nothrow {
    return new EntitySetException(404, "NotFound", what ~ " not found");
  }

  static EntitySetException notSupported(string what) pure nothrow {
    return new EntitySetException(405, "MethodNotAllowed", what ~ " is not supported");
  }

  static EntitySetException invalid(string msg) pure nothrow {
    return new EntitySetException(400, "BadRequest", msg);
  }

  static EntitySetException conflict(string msg) pure nothrow {
    return new EntitySetException(409, "Conflict", msg);
  }

  static EntitySetException forbidden(string msg) pure nothrow {
    return new EntitySetException(403, "Forbidden", msg);
  }
}

/// CRUD access to one entity set (or singleton) of a service.
interface IEntitySetProvider {
  /// All rows visible to the caller. Filtering, sorting and paging are applied
  /// by the adapter (OData query options), so return the full tenant scope.
  Json[] list(const RequestContext ctx);

  /// One row by key, or Json(null) if it does not exist.
  /// For singletons the key is "".
  Json get(const RequestContext ctx, string key);

  /// Create a row from the payload and return the stored row (with its key).
  Json create(const RequestContext ctx, Json payload);

  /// Merge the payload into an existing row (PATCH semantics) and return it.
  Json update(const RequestContext ctx, string key, Json payload);

  /// Delete a row.
  void remove(const RequestContext ctx, string key);
}

/// An unbound action (OData ActionImport, CLI "invoke", GUI action button).
interface IActionHandler {
  /// Execute with the given parameters; returns the result (may be Json(null)).
  Json invoke(const RequestContext ctx, Json parameters);
}

/// Read-only base: list/get must be provided, writes answer 405.
abstract class ReadOnlyEntitySetProvider : IEntitySetProvider {
  abstract Json[] list(const RequestContext ctx);

  Json get(const RequestContext ctx, string key) {
    foreach (row; list(ctx))
      if (row.isObject && "id" in row && row["id"].type == Json.Type.string && row["id"].get!string == key)
        return row;
    return Json(null);
  }

  Json create(const RequestContext ctx, Json payload) {
    throw EntitySetException.notSupported("Create");
  }

  Json update(const RequestContext ctx, string key, Json payload) {
    throw EntitySetException.notSupported("Update");
  }

  void remove(const RequestContext ctx, string key) {
    throw EntitySetException.notSupported("Delete");
  }
}

/// Adapts delegates to IEntitySetProvider — handy for wiring use cases
/// without writing a class per entity set. Unset delegates answer 405.
class DelegateEntitySetProvider : IEntitySetProvider {
  Json[] delegate(const RequestContext) @safe onList;
  Json delegate(const RequestContext, string) @safe onGet;
  Json delegate(const RequestContext, Json) @safe onCreate;
  Json delegate(const RequestContext, string, Json) @safe onUpdate;
  void delegate(const RequestContext, string) @safe onRemove;
  string keyProperty = "id";

  Json[] list(const RequestContext ctx) {
    if (onList is null)
      throw EntitySetException.notSupported("List");
    return onList(ctx);
  }

  Json get(const RequestContext ctx, string key) {
    if (onGet !is null)
      return onGet(ctx, key);
    foreach (row; list(ctx))
      if (row.isObject && keyProperty in row && keyString(row[keyProperty]) == key)
        return row;
    return Json(null);
  }

  Json create(const RequestContext ctx, Json payload) {
    if (onCreate is null)
      throw EntitySetException.notSupported("Create");
    return onCreate(ctx, payload);
  }

  Json update(const RequestContext ctx, string key, Json payload) {
    if (onUpdate is null)
      throw EntitySetException.notSupported("Update");
    return onUpdate(ctx, key, payload);
  }

  void remove(const RequestContext ctx, string key) {
    if (onRemove is null)
      throw EntitySetException.notSupported("Delete");
    onRemove(ctx, key);
  }
}

/// Adapts a delegate to IActionHandler.
class DelegateActionHandler : IActionHandler {
  protected Json delegate(const RequestContext, Json) @safe handler;

  this(Json delegate(const RequestContext, Json) @safe handler) {
    this.handler = handler;
  }

  Json invoke(const RequestContext ctx, Json parameters) {
    return handler(ctx, parameters);
  }
}

/// String form of a key value (strings as-is, numbers via toString).
string keyString(Json value) {
  switch (value.type) {
  case Json.Type.string:
    return value.get!string;
  case Json.Type.null_, Json.Type.undefined:
    return "";
  default:
    return value.toString;
  }
}

///
unittest {
  mixin(ShowTest!("DelegateEntitySetProvider"));

  auto p = new DelegateEntitySetProvider;
  p.onList = (const RequestContext ctx) @safe {
    auto a = Json.emptyObject;
    a["id"] = "a";
    auto b = Json.emptyObject;
    b["id"] = 2;
    return [a, b];
  };
  RequestContext ctx;
  assert(p.get(ctx, "a")["id"].get!string == "a");
  assert(p.get(ctx, "2")["id"].get!long == 2);
  assert(p.get(ctx, "x").type == Json.Type.null_);

  bool failed;
  try
    p.create(ctx, Json.emptyObject);
  catch (EntitySetException e)
    failed = e.status == 405;
  assert(failed);
}
