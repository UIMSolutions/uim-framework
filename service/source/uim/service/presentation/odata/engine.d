/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Protocol neutral OData engine: binds an EDM model to entity-set providers
/// and action handlers, validates payloads against the model, enforces scopes
/// and evaluates query options. The HTTP controller, the CLI and the GtkD GUI
/// all go through this engine, so they behave identically.
module uim.service.presentation.odata.engine;

import uim.service;
import uim.service.ports.services.context;
import uim.service.ports.services.entitysets;
import uim.service.presentation.odata.model;
import uim.service.presentation.odata.query;

mixin(ShowModule!());

@safe:

class ODataEngine {
  protected ODataServiceModel _model;
  protected IEntitySetProvider[string] providers;
  protected IActionHandler[string] actionHandlers;

  /// Check readScope/writeScope/action scopes against RequestContext.scopes.
  bool enforceScopes;

  /// Server-driven paging: maximum rows per response (0 = unlimited).
  size_t maxPageSize;

  this(ODataServiceModel model) {
    _model = model;
  }

  ODataServiceModel model() {
    return _model;
  }

  // ── wiring ──────────────────────────────────────────────────────────────

  /// Bind the provider of an entity set or singleton.
  ODataEngine provide(string setName, IEntitySetProvider provider) {
    enforce(_model.has(setName), "Entity set '" ~ setName ~ "' is not part of the model");
    enforce(provider !is null, "Provider for '" ~ setName ~ "' is null");
    providers[setName] = provider;
    return this;
  }

  /// Bind the handler of an unbound action.
  ODataEngine handle(string actionName, IActionHandler handler) {
    enforce(_model.findAction(actionName) !is null, "Action '" ~ actionName ~ "' is not part of the model");
    enforce(handler !is null, "Handler for '" ~ actionName ~ "' is null");
    actionHandlers[actionName] = handler;
    return this;
  }

  /// ditto
  ODataEngine handle(string actionName, Json delegate(const RequestContext, Json) @safe handler) {
    return handle(actionName, new DelegateActionHandler(handler));
  }

  /// Validate the model and check that every set/action is bound. Throws on error.
  void verify() {
    _model.validate();
    foreach (set; _model.entitySets)
      enforce((set.name in providers) !is null, "No provider bound for entity set '" ~ set.name ~ "'");
    foreach (action; _model.actions)
      enforce((action.name in actionHandlers) !is null, "No handler bound for action '" ~ action.name ~ "'");
  }

  // ── resolution ──────────────────────────────────────────────────────────

  /// The entity set definition, or a 404.
  ODataEntitySetDef setOf(string name) {
    auto set = _model.find(name);
    if (set is null)
      throw new EntitySetException(404, "NotFound", "Unknown entity set '" ~ name ~ "'");
    return set;
  }

  protected IEntitySetProvider providerOf(ODataEntitySetDef set) {
    if (auto p = set.name in providers)
      return *p;
    throw new EntitySetException(501, "NotImplemented", "Entity set '" ~ set.name ~ "' has no provider");
  }

  protected void checkScope(const RequestContext ctx, string scope_) {
    if (enforceScopes && scope_.length > 0 && !ctx.hasScope(scope_))
      throw EntitySetException.forbidden("Missing scope '" ~ scope_ ~ "'");
  }

  // ── reading ─────────────────────────────────────────────────────────────

  /// Query a collection.
  ODataPage query(const RequestContext ctx, string setName, const ODataQuery q) {
    auto set = setOf(setName);
    if (set.singleton)
      throw new EntitySetException(400, "BadRequest", "'" ~ setName ~ "' is a singleton");
    checkScope(ctx, set.readScope);
    return q.apply(providerOf(set).list(ctx), maxPageSize);
  }

  /// Query a collection with raw query options ("$filter" → "...").
  ODataPage query(const RequestContext ctx, string setName, string[string] options) {
    auto set = setOf(setName);
    return query(ctx, setName, parseODataQuery((name) => options.get(name, ""), set.propertyNames, set.key));
  }

  /// Read one entity (404 if missing). For singletons pass key "".
  Json read(const RequestContext ctx, string setName, string key) {
    auto set = setOf(setName);
    checkScope(ctx, set.readScope);
    auto row = providerOf(set).get(ctx, set.singleton ? "" : key);
    if (row.type == Json.Type.null_ || row.type == Json.Type.undefined)
      throw EntitySetException.notFound(set.entityType ~ (set.singleton ? "" : " '" ~ key ~ "'"));
    return row;
  }

  // ── writing ─────────────────────────────────────────────────────────────

  Json create(const RequestContext ctx, string setName, Json payload) {
    auto set = setOf(setName);
    if (!set.insertable || set.singleton)
      throw EntitySetException.notSupported("Creating " ~ set.name);
    checkScope(ctx, set.writeScope);
    return providerOf(set).create(ctx, validatePayload(set, payload, true));
  }

  Json update(const RequestContext ctx, string setName, string key, Json payload) {
    auto set = setOf(setName);
    if (!set.updatable)
      throw EntitySetException.notSupported("Updating " ~ set.name);
    checkScope(ctx, set.writeScope);
    read(ctx, setName, key); // 404 before validation side effects
    return providerOf(set).update(ctx, set.singleton ? "" : key, validatePayload(set, payload, false));
  }

  void remove(const RequestContext ctx, string setName, string key) {
    auto set = setOf(setName);
    if (!set.deletable || set.singleton)
      throw EntitySetException.notSupported("Deleting " ~ set.name);
    checkScope(ctx, set.writeScope);
    read(ctx, setName, key);
    providerOf(set).remove(ctx, key);
  }

  /// Invoke an unbound action with a JSON object of parameters.
  Json invoke(const RequestContext ctx, string actionName, Json parameters) {
    auto action = _model.findAction(actionName);
    if (action is null)
      throw new EntitySetException(404, "NotFound", "Unknown action '" ~ actionName ~ "'");
    checkScope(ctx, action.scope_);
    auto handler = actionName in actionHandlers;
    if (handler is null)
      throw new EntitySetException(501, "NotImplemented", "Action '" ~ actionName ~ "' has no handler");

    if (parameters.type == Json.Type.undefined || parameters.type == Json.Type.null_)
      parameters = Json.emptyObject;
    if (!parameters.isObject)
      throw EntitySetException.invalid("Action parameters must be a JSON object");
    Json checked = Json.emptyObject;
    foreach (name, value; parameters.get!(Json[string])) {
      if (name.startsWith("@"))
        continue;
      auto def = action.parameters.find!(p => p.name == name);
      if (def.empty)
        throw EntitySetException.invalid("Unknown parameter '" ~ name ~ "' for action " ~ actionName);
      checkValue(def.front, value);
      checked[name] = canonicalValue(def.front, value);
    }
    foreach (p; action.parameters)
      if (!p.nullable && p.name !in checked)
        throw EntitySetException.invalid("Missing parameter '" ~ p.name ~ "' for action " ~ actionName);
    return (*handler).invoke(ctx, checked);
  }

  // ── validation ──────────────────────────────────────────────────────────

  /// Validate a write payload against the model and drop server managed
  /// properties (instance annotations, computed and — on update — key and
  /// immutable properties).
  Json validatePayload(const ODataEntitySetDef set, Json payload, bool creating) {
    if (!payload.isObject)
      throw EntitySetException.invalid("Request body must be a JSON object");

    Json result = Json.emptyObject;
    foreach (name, value; payload.get!(Json[string])) {
      if (name.startsWith("@") || name.canFind("@odata."))
        continue;
      auto def = set.propertyOf(name);
      if (def.name.length == 0)
        throw EntitySetException.invalid("Unknown property '" ~ name ~ "' of " ~ set.entityType);
      if (def.computed)
        continue;
      if (!creating && (name == set.key || def.immutable_))
        continue;
      checkValue(def, value);
      result[name] = canonicalValue(def, value);
    }

    if (creating)
      foreach (p; set.properties)
        if (!p.nullable && !p.computed && p.name != set.key && p.name !in result)
          throw EntitySetException.invalid("Missing mandatory property '" ~ p.name ~ "' of " ~ set.entityType);
    return result;
  }

  /// Canonical storage form of a checked value: numbers sent as strings
  /// (IEEE754Compatible clients such as UI5) become JSON numbers.
  static Json canonicalValue(const ODataPropertyDef def, Json value) @trusted {
    if (value.type == Json.Type.array && def.collection) {
      auto item = ODataPropertyDef(def.name, def.type, true);
      auto result = Json.emptyArray;
      foreach (v; value.get!(Json[]))
        result ~= canonicalValue(item, v);
      return result;
    }
    if (value.type != Json.Type.string || def.collection)
      return value;
    auto text = value.get!string.strip;
    switch (def.type) {
    case Edm.int32, Edm.int64:
      return Json(text.to!long);
    case Edm.decimal, Edm.double_:
      auto d = text.to!double;
      return !text.canFind('.') && !text.canFind('e') && !text.canFind('E') ? Json(text.to!long) : Json(d);
    default:
      return value;
    }
  }

  /// Check that a JSON value matches the EDM type of a property.
  static void checkValue(const ODataPropertyDef def, Json value) {
    if (value.type == Json.Type.null_) {
      if (!def.nullable)
        throw EntitySetException.invalid("Property '" ~ def.name ~ "' must not be null");
      return;
    }
    if (def.collection) {
      if (value.type != Json.Type.array)
        throw EntitySetException.invalid("Property '" ~ def.name ~ "' must be an array");
      auto item = ODataPropertyDef(def.name, def.type, true);
      foreach (v; value.get!(Json[]))
        checkValue(item, v);
      return;
    }

    bool ok;
    switch (def.type) {
    case Edm.string_, Edm.date, Edm.timeOfDay, Edm.dateTimeOffset, Edm.guid, Edm.binary:
      ok = value.type == Json.Type.string;
      if (ok && def.maxLength > 0 && value.get!string.length > def.maxLength)
        throw EntitySetException.invalid("Property '" ~ def.name ~ "' exceeds " ~ def.maxLength.to!string ~ " characters");
      if (ok && def.type == Edm.dateTimeOffset)
        ok = isIsoTimestamp(value.get!string);
      break;
    case Edm.boolean:
      ok = value.type == Json.Type.bool_;
      break;
    case Edm.int32, Edm.int64:
      ok = value.type == Json.Type.int_ || (value.type == Json.Type.string && isIntegerText(value.get!string));
      if (ok && def.type == Edm.int32 && value.type == Json.Type.int_)
        ok = value.get!long >= int.min && value.get!long <= int.max;
      break;
    case Edm.decimal, Edm.double_:
      ok = value.type == Json.Type.int_ || value.type == Json.Type.float_
        || (value.type == Json.Type.string && isNumberText(value.get!string));
      break;
    default: // complex type
      ok = value.type == Json.Type.object;
    }
    if (!ok)
      throw EntitySetException.invalid("Property '" ~ def.name ~ "' expects " ~ def.type ~ ", got " ~ value.toString);
  }
}

private bool isIntegerText(string s) {
  try {
    s.to!long;
    return true;
  } catch (Exception)
    return false;
}

private bool isNumberText(string s) {
  try {
    s.to!double;
    return true;
  } catch (Exception)
    return false;
}

private bool isIsoTimestamp(string s) @trusted {
  try {
    SysTime.fromISOExtString(s);
    return true;
  } catch (Exception)
    return false;
}

version (unittest) {
  private class TestItems : IEntitySetProvider {
    Json[string] rows;

    Json[] list(const RequestContext ctx) {
      return rows.values;
    }

    Json get(const RequestContext ctx, string key) {
      return key in rows ? rows[key] : Json(null);
    }

    Json create(const RequestContext ctx, Json payload) {
      payload["id"] = (rows.length + 1).to!string;
      rows[payload["id"].get!string] = payload;
      return payload;
    }

    Json update(const RequestContext ctx, string key, Json payload) {
      // note: `rows[key][k] = v` crashes dmd 2.112 with -g (ICE in debug info)
      auto row = rows[key];
      foreach (k, v; payload.get!(Json[string]))
        row[k] = v;
      rows[key] = row;
      return row;
    }

    void remove(const RequestContext ctx, string key) {
      rows.remove(key);
    }
  }

  private class TestPing : IActionHandler {
    Json invoke(const RequestContext ctx, Json params) {
      return Json(params["text"].get!string ~ "!");
    }
  }

  private int status(scope void delegate() @safe dg) {
    try
      dg();
    catch (EntitySetException e)
      return e.status;
    return 0;
  }
}

///
unittest {
  mixin(ShowTest!("ODataEngine"));

  auto m = new ODataServiceModel("uim.test", "TestService");
  m.entitySet("Items", "Item").tenantAware()
    .property("name", Edm.string_, "Name", false)
    .property("qty", Edm.int32)
    .property("code", Edm.string_).immutableProps("code")
    .writable().scopes("Read", "Write");
  m.action("Ping", Edm.string_).parameter("text", Edm.string_, false);

  auto p = new TestItems;

  auto engine = new ODataEngine(m);
  engine.provide("Items", p).handle("Ping", new TestPing);
  engine.verify();

  RequestContext ctx;
  auto body = Json.emptyObject;
  body["name"] = "a";
  body["qty"] = 2;
  body["code"] = "X";
  body["createdAt"] = "ignored"; // computed → dropped
  body["@odata.type"] = "#uim.test.Item";
  auto created = engine.create(ctx, "Items", body);
  assert(created["id"].get!string == "1");
  assert("createdAt" !in created);

  auto patch = Json.emptyObject;
  patch["qty"] = "5"; // IEEE754Compatible string → stored as number
  patch["code"] = "Y"; // immutable → ignored on update
  auto updated = engine.update(ctx, "Items", "1", patch);
  assert(updated["qty"].get!long == 5 && updated["code"].get!string == "X");

  auto bad = Json.emptyObject;
  bad["qty"] = "many";
  assert(status(() { engine.create(ctx, "Items", bad); }) == 400); // wrong type + missing name
  auto unknown = Json.emptyObject;
  unknown["name"] = "b";
  unknown["nope"] = 1;
  assert(status(() { engine.create(ctx, "Items", unknown); }) == 400);
  assert(status(() { engine.read(ctx, "Items", "42"); }) == 404);
  assert(status(() { engine.read(ctx, "Nope", "1"); }) == 404);

  string[string] options = ["$filter": "qty gt 1"];
  assert(engine.query(ctx, "Items", options).total == 1);

  auto params = Json.emptyObject;
  params["text"] = "pong";
  assert(engine.invoke(ctx, "Ping", params).get!string == "pong!");
  assert(status(() { engine.invoke(ctx, "Ping", Json.emptyObject); }) == 400);

  engine.enforceScopes = true;
  assert(status(() { engine.query(ctx, "Items", options); }) == 403);
  ctx.scopes = ["app.Read"];
  assert(engine.query(ctx, "Items", options).total == 1);
  assert(status(() { engine.remove(ctx, "Items", "1"); }) == 403);
  ctx.scopes ~= "app.Write";
  engine.remove(ctx, "Items", "1");
  assert(p.rows.length == 0);
}
