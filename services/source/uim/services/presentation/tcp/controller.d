/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.tcp.controller;

import uim.services;
import vibe.core.log : logError;

mixin(ShowModule!());

@safe:

/// A handler of a tcp route.
alias TcpHandler = ITcpResponse delegate(ITcpRequest) @safe;

/// A route of a tcp controller.
private struct TcpRoute {
  string method;
  string[] segments;
  TcpHandler handler;

  /// Whether the route contains :parameters
  bool isPattern() const {
    return segments.any!(segment => segment.startsWith(":"));
  }

  bool matches(string requestMethod, const string[] pathSegments) const {
    if (method != requestMethod || segments.length != pathSegments.length) {
      return false;
    }
    foreach (i, segment; segments) {
      if (!segment.startsWith(":") && segment != pathSegments[i]) {
        return false;
      }
    }
    return true;
  }
}

/// Splits a path into its segments, e.g. "/products/1" -> ["products", "1"]
private string[] pathSegments(string path) {
  return path.split("/").filter!(segment => segment.length > 0).array;
}

/// Base class for tcp controllers with method routing.
class TcpController : ITcpController {
  this(string routePrefix = "/") {
    _prefixSegments = pathSegments(routePrefix);
    _routePrefix = "/" ~ _prefixSegments.join("/");
  }

  string routePrefix() const {
    return _routePrefix;
  }

  bool canHandle(ITcpRequest request) {
    auto segments = pathSegments(request.path);
    return segments.length >= _prefixSegments.length
      && segments[0 .. _prefixSegments.length] == _prefixSegments;
  }

  /// Registers a handler for a method and sub-path, e.g. on("GET", "/:id", ...) (fluent interface).
  /// Registering the same method and sub-path again replaces the handler.
  auto on(string method, string subPath, TcpHandler handler) {
    auto route = TcpRoute(method.toUpper, pathSegments(subPath), handler);
    foreach (ref existing; _routes) {
      if (existing.method == route.method && existing.segments == route.segments) {
        existing.handler = handler;
        return this;
      }
    }
    _routes ~= route;
    return this;
  }

  /// Dispatches a request. Literal routes win over :parameter routes, then the first registered route wins.
  /// A handler that throws produces a 500 response, so that it cannot take down the connection.
  ITcpResponse handle(ITcpRequest request) {
    string method = request.method.toUpper;
    if (!canHandle(request)) {
      return TcpResponse.error("No handler for " ~ method ~ " " ~ request.path, 404);
    }

    auto segments = subPathSegments(request);
    foreach (pattern; [false, true]) {
      foreach (route; _routes) {
        if (route.isPattern == pattern && route.matches(method, segments)) {
          return invoke(route, request);
        }
      }
    }
    return TcpResponse.error("No handler for " ~ method ~ " " ~ request.path, 404);
  }

  /// The path segments relative to the route prefix, e.g. "/products/1" -> ["1"]
  protected string[] subPathSegments(ITcpRequest request) const {
    return pathSegments(request.path)[_prefixSegments.length .. $];
  }

  /// Extracts a path parameter, e.g. pathParam(request, "/:id", "id") -> "42" for "/products/42"
  protected string pathParam(ITcpRequest request, string pattern, string name) const {
    auto segments = subPathSegments(request);
    foreach (i, segment; pathSegments(pattern)) {
      if (segment == ":" ~ name && i < segments.length) {
        return segments[i];
      }
    }
    return null;
  }

  private ITcpResponse invoke(TcpRoute route, ITcpRequest request) {
    try {
      return route.handler(request);
    } catch (Exception exception) {
      // The client only gets a generic message, details stay in the log
      logError("TCP handler failed for %s %s: %s", request.method, request.path, exception.msg);
      return TcpResponse.error("Internal server error", 500);
    }
  }

  private string _routePrefix;
  private string[] _prefixSegments;
  private TcpRoute[] _routes;
}

/// A CRUD controller exposing list/create/read/update/delete over tcp.
class TcpCrudController : TcpController {
  this(string routePrefix) {
    super(routePrefix);
    registerCrudRoutes;
  }

  /// Registers the five CRUD routes (fluent interface)
  auto registerCrudRoutes() {
    on("GET", "/", (request) => listHandler(request));
    on("POST", "/", (request) => createHandler(request));
    on("GET", "/:id", (request) => readHandler(request, pathParam(request, "/:id", "id")));
    on("PUT", "/:id", (request) => updateHandler(request, pathParam(request, "/:id", "id")));
    on("DELETE", "/:id", (request) => deleteHandler(request, pathParam(request, "/:id", "id")));
    return this;
  }

  /// Lists all entities; override in subclasses
  protected ITcpResponse listHandler(ITcpRequest request) {
    return TcpResponse.error("List not implemented", 501);
  }

  /// Creates an entity; override in subclasses
  protected ITcpResponse createHandler(ITcpRequest request) {
    return TcpResponse.error("Create not implemented", 501);
  }

  /// Reads a single entity; override in subclasses
  protected ITcpResponse readHandler(ITcpRequest request, string id) {
    return TcpResponse.error("Read not implemented", 501);
  }

  /// Updates a single entity; override in subclasses
  protected ITcpResponse updateHandler(ITcpRequest request, string id) {
    return TcpResponse.error("Update not implemented", 501);
  }

  /// Deletes a single entity; override in subclasses
  protected ITcpResponse deleteHandler(ITcpRequest request, string id) {
    return TcpResponse.error("Delete not implemented", 501);
  }
}

/// An in-memory CRUD controller storing Json entities (ready to use). Not safe to share between threads.
class TcpMemoryController : TcpCrudController {
  this(string routePrefix, string idProperty = "id") {
    _idProperty = idProperty;
    super(routePrefix);
  }

  protected override ITcpResponse listHandler(ITcpRequest request) {
    auto results = Json.emptyArray;
    foreach (entity; _entities) {
      results ~= entity;
    }
    auto json = Json.emptyObject;
    json["results"] = results;
    json["count"] = _entities.length.to!long;
    return TcpResponse.jsonResponse(json);
  }

  protected override ITcpResponse createHandler(ITcpRequest request) {
    auto entity = request.json;
    if (entity.type != Json.Type.object) {
      return TcpResponse.error("Request body must be a JSON object", 400);
    }

    if (_idProperty in entity) {
      string id = entityId(entity);
      if (indexOfEntity(id) >= 0) {
        return TcpResponse.error("Entity already exists: " ~ id, 409);
      }
    } else {
      while (indexOfEntity(_nextId.to!string) >= 0) {
        _nextId++;
      }
      entity[_idProperty] = _nextId++;
    }

    _entities ~= entity;
    return TcpResponse.jsonResponse(entity, 201);
  }

  protected override ITcpResponse readHandler(ITcpRequest request, string id) {
    auto index = indexOfEntity(id);
    return index < 0
      ? TcpResponse.error("Entity not found: " ~ id, 404)
      : TcpResponse.jsonResponse(_entities[index]);
  }

  protected override ITcpResponse updateHandler(ITcpRequest request, string id) {
    auto changes = request.json;
    if (changes.type != Json.Type.object) {
      return TcpResponse.error("Request body must be a JSON object", 400);
    }

    auto index = indexOfEntity(id);
    if (index < 0) {
      return TcpResponse.error("Entity not found: " ~ id, 404);
    }

    // The id identifies the entity and cannot be changed by an update
    foreach (property, value; changes.get!(Json[string])) {
      if (property != _idProperty) {
        _entities[index][property] = value;
      }
    }
    return TcpResponse.jsonResponse(_entities[index]);
  }

  protected override ITcpResponse deleteHandler(ITcpRequest request, string id) {
    auto index = indexOfEntity(id);
    if (index < 0) {
      return TcpResponse.error("Entity not found: " ~ id, 404);
    }
    _entities = _entities.remove(index);
    return tcpResponse(204);
  }

  /// Number of stored entities
  size_t length() const {
    return _entities.length;
  }

  private ptrdiff_t indexOfEntity(string id) {
    foreach (i, entity; _entities) {
      if (entityId(entity) == id) {
        return i;
      }
    }
    return -1;
  }

  private string entityId(Json entity) {
    auto value = entity[_idProperty];
    return value.type == Json.Type.string ? value.get!string : value.toString;
  }

  private string _idProperty;
  private Json[] _entities;
  private long _nextId = 1;
}

///
unittest {
  // base controller routing
  auto controller = new TcpController("/products");
  assert(controller.routePrefix == "/products");
  assert(controller.canHandle(tcpRequest("GET", "/products")));
  assert(controller.canHandle(tcpRequest("GET", "/products/")));
  assert(controller.canHandle(tcpRequest("GET", "/products/1")));
  assert(!controller.canHandle(tcpRequest("GET", "/orders")));
  assert(!controller.canHandle(tcpRequest("GET", "/productsX")));

  // the route prefix is normalized
  assert(new TcpController("/products/").routePrefix == "/products");
  assert(new TcpController("products").routePrefix == "/products");
  assert(new TcpController("").routePrefix == "/");

  // unhandled requests -> 404, also for a path outside of the prefix
  assert(controller.handle(tcpRequest("GET", "/products")).status == 404);
  assert(controller.handle(tcpRequest("GET", "/x")).status == 404);

  // custom handlers
  controller.on("GET", "/", (request) => tcpResponse(200, "list"));
  controller.on("GET", "/:id", (request) => tcpResponse(200, "one"));
  assert(controller.handle(tcpRequest("GET", "/products")).body == "list");
  assert(controller.handle(tcpRequest("GET", "/products/")).body == "list");
  assert(controller.handle(tcpRequest("GET", "/products/42")).body == "one");
  assert(controller.handle(tcpRequest("POST", "/products")).status == 404);
  assert(controller.handle(tcpRequest("GET", "/products/1/2")).status == 404);

  // literal routes win over pattern routes, whatever the registration order
  controller.on("GET", "/new", (request) => tcpResponse(200, "new"));
  assert(controller.handle(tcpRequest("GET", "/products/new")).body == "new");

  // overlapping patterns resolve to the first registered route
  auto overlap = new TcpController("/");
  overlap.on("GET", "/:a/x", (request) => tcpResponse(200, "first"));
  overlap.on("GET", "/y/:b", (request) => tcpResponse(200, "second"));
  assert(overlap.handle(tcpRequest("GET", "/y/x")).body == "first");

  // registering a route again replaces the handler
  controller.on("get", "new", (request) => tcpResponse(200, "replaced"));
  assert(controller.handle(tcpRequest("GET", "/products/new")).body == "replaced");

  // a root controller routes like any other
  auto root = new TcpController;
  root.on("GET", "/ping", (request) => tcpResponse(200, "pong"));
  assert(root.canHandle(tcpRequest("GET", "/anything")));
  assert(root.handle(tcpRequest("GET", "/ping")).body == "pong");

  // a failing handler yields a 500 without leaking details
  auto failing = new TcpController("/fail");
  failing.on("GET", "/", delegate ITcpResponse(request) {
    throw new Exception("secret detail");
  });
  auto failed = failing.handle(tcpRequest("GET", "/fail"));
  assert(failed.status == 500);
  assert(!failed.body.canFind("secret detail"));

  // CRUD controller defaults to 501
  auto crud = new TcpCrudController("/items");
  assert(crud.handle(tcpRequest("GET", "/items")).status == 501);
  assert(crud.handle(tcpRequest("POST", "/items")).status == 501);
  assert(crud.handle(tcpRequest("GET", "/items/1")).status == 501);
  assert(crud.handle(tcpRequest("PUT", "/items/1")).status == 501);
  assert(crud.handle(tcpRequest("DELETE", "/items/1")).status == 501);

  // memory controller: full CRUD cycle
  auto memory = new TcpMemoryController("/products");
  assert(memory.length == 0);

  // create with generated id
  auto created = memory.handle(tcpRequest("POST", "/products").setBody(`{"name":"Milk"}`));
  assert(created.status == 201);
  assert(created.body.canFind(`"id":1`));

  // create with explicit id
  memory.handle(tcpRequest("POST", "/products").setBody(`{"id":5,"name":"Bread"}`));
  assert(memory.length == 2);

  // ids stay unique
  assert(memory.handle(tcpRequest("POST", "/products").setBody(`{"id":5}`)).status == 409);
  memory.handle(tcpRequest("POST", "/products").setBody(`{"id":2}`));
  assert(memory.handle(tcpRequest("POST", "/products").setBody(`{}`)).body.canFind(`"id":3`));
  memory.handle(tcpRequest("DELETE", "/products/2"));
  memory.handle(tcpRequest("DELETE", "/products/3"));

  // create with invalid body
  assert(memory.handle(tcpRequest("POST", "/products").setBody("not json")).status == 400);

  // list
  auto list = memory.handle(tcpRequest("GET", "/products"));
  assert(list.status == 200);
  assert(list.body.canFind(`"count":2`));

  // read
  assert(memory.handle(tcpRequest("GET", "/products/1")).body.canFind("Milk"));
  assert(memory.handle(tcpRequest("GET", "/products/99")).status == 404);

  // update
  auto updated = memory.handle(tcpRequest("PUT", "/products/1").setBody(`{"name":"Oat Milk"}`));
  assert(updated.status == 200);
  assert(updated.body.canFind("Oat Milk"));
  assert(memory.handle(tcpRequest("PUT", "/products/99").setBody(`{"name":"X"}`)).status == 404);
  assert(memory.handle(tcpRequest("PUT", "/products/1").setBody("bad")).status == 400);

  // an update cannot change the id
  memory.handle(tcpRequest("PUT", "/products/1").setBody(`{"id":7}`));
  assert(memory.handle(tcpRequest("GET", "/products/1")).status == 200);
  assert(memory.handle(tcpRequest("GET", "/products/7")).status == 404);

  // delete
  auto deleted = memory.handle(tcpRequest("DELETE", "/products/1"));
  assert(deleted.status == 204);
  assert(deleted.body.length == 0);
  assert(memory.length == 1);
  assert(memory.handle(tcpRequest("DELETE", "/products/1")).status == 404);

  // string ids and a custom id property
  auto keyed = new TcpMemoryController("/users", "key");
  keyed.handle(tcpRequest("POST", "/users").setBody(`{"key":"abc"}`));
  assert(keyed.handle(tcpRequest("GET", "/users/abc")).status == 200);

  // a full round trip through the wire format
  string wire = tcpRequest("POST", "/users").setBody(`{"key":"def"}`).toString;
  auto response = keyed.handle(TcpRequest.parse(wire));
  assert(TcpResponse.parse((cast(TcpResponse) response).toString).status == 201);
}
