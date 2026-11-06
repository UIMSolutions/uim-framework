/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.unix.controller;

import uim.service;
import uim.service.presentation.unix.interfaces;
import uim.service.presentation.unix.message;

mixin(ShowModule!());

@safe:

/// Base class for unix socket controllers with method routing.
class UnixController : IUnixController {
  this(string routePrefix = "/") {
    _routePrefix = routePrefix.endsWith("/") && routePrefix.length > 1
      ? routePrefix[0 .. $ - 1]
      : routePrefix;
  }

  string routePrefix() const {
    return _routePrefix;
  }

  bool canHandle(IUnixRequest request) {
    return request.path == _routePrefix
      || request.path.startsWith(_routePrefix == "/" ? "/" : _routePrefix ~ "/");
  }

  /// Registers a handler for a method and sub-path, e.g. on("GET", "/:id", ...) (fluent interface)
  auto on(string method, string subPath, IUnixResponse delegate(IUnixRequest) @safe handler) {
    _handlers[method.toUpper ~ " " ~ normalizeSubPath(subPath)] = handler;
    return this;
  }

  IUnixResponse handle(IUnixRequest request) {
    string subPath = extractSubPath(request.path);
    string method = request.method.toUpper;

    // exact match first, then pattern match with :parameters
    if (auto handler = (method ~ " " ~ subPath) in _handlers) {
      return (*handler)(request);
    }
    foreach (key, handler; _handlers) {
      if (matchRoute(key, method, subPath)) {
        return handler(request);
      }
    }
    return UnixResponse.error("No handler for " ~ method ~ " " ~ request.path, 404);
  }

  /// Extracts the sub-path relative to the route prefix, e.g. "/products/1" -> "/1"
  protected string extractSubPath(string path) const {
    if (path == _routePrefix) {
      return "/";
    }
    return path[_routePrefix.length .. $];
  }

  /// Matches a route key ("GET /:id") against method and sub-path
  protected bool matchRoute(string routeKey, string method, string subPath) const {
    auto parts = routeKey.split(" ");
    if (parts.length != 2 || parts[0] != method) {
      return false;
    }
    auto patternSegments = parts[1].split("/").filter!(s => s.length > 0).array;
    auto pathSegments = subPath.split("/").filter!(s => s.length > 0).array;
    if (patternSegments.length != pathSegments.length) {
      return false;
    }
    foreach (i, pattern; patternSegments) {
      if (!pattern.startsWith(":") && pattern != pathSegments[i]) {
        return false;
      }
    }
    return true;
  }

  /// Extracts a path parameter, e.g. pathParam("/:id", "/42", "id") -> "42"
  protected string pathParam(string pattern, string subPath, string name) const {
    auto patternSegments = pattern.split("/").filter!(s => s.length > 0).array;
    auto pathSegments = subPath.split("/").filter!(s => s.length > 0).array;
    foreach (i, segment; patternSegments) {
      if (segment == ":" ~ name && i < pathSegments.length) {
        return pathSegments[i];
      }
    }
    return null;
  }

  private string normalizeSubPath(string subPath) const {
    return subPath.startsWith("/") ? subPath : "/" ~ subPath;
  }

  private string _routePrefix;
  private IUnixResponse delegate(IUnixRequest) @safe[string] _handlers;
}

/// A CRUD controller exposing list/create/read/update/delete over a unix socket.
class UnixCrudController : UnixController {
  this(string routePrefix) {
    super(routePrefix);
    registerCrudRoutes;
  }

  /// Registers the five CRUD routes (fluent interface)
  auto registerCrudRoutes() {
    on("GET", "/", (request) => listHandler(request));
    on("POST", "/", (request) => createHandler(request));
    on("GET", "/:id", (request) => readHandler(request, pathParam("/:id", extractSubPath(request.path), "id")));
    on("PUT", "/:id", (request) => updateHandler(request, pathParam("/:id", extractSubPath(request.path), "id")));
    on("DELETE", "/:id", (request) => deleteHandler(request, pathParam("/:id", extractSubPath(request.path), "id")));
    return this;
  }

  /// Lists all entities; override in subclasses
  protected IUnixResponse listHandler(IUnixRequest request) {
    return UnixResponse.error("List not implemented", 501);
  }

  /// Creates an entity; override in subclasses
  protected IUnixResponse createHandler(IUnixRequest request) {
    return UnixResponse.error("Create not implemented", 501);
  }

  /// Reads a single entity; override in subclasses
  protected IUnixResponse readHandler(IUnixRequest request, string id) {
    return UnixResponse.error("Read not implemented", 501);
  }

  /// Updates a single entity; override in subclasses
  protected IUnixResponse updateHandler(IUnixRequest request, string id) {
    return UnixResponse.error("Update not implemented", 501);
  }

  /// Deletes a single entity; override in subclasses
  protected IUnixResponse deleteHandler(IUnixRequest request, string id) {
    return UnixResponse.error("Delete not implemented", 501);
  }
}

/// An in-memory CRUD controller storing Json entities (ready to use).
class UnixMemoryController : UnixCrudController {
  this(string routePrefix, string idProperty = "id") {
    _idProperty = idProperty;
    super(routePrefix);
  }

  protected override IUnixResponse listHandler(IUnixRequest request) {
    auto results = Json.emptyArray;
    foreach (entity; _entities) {
      results ~= entity;
    }
    auto json = Json.emptyObject;
    json["results"] = results;
    json["count"] = _entities.length.to!long;
    return UnixResponse.jsonResponse(json);
  }

  // @trusted: Json access is memory-safe here
  @trusted protected override IUnixResponse createHandler(IUnixRequest request) {
    auto entity = request.json;
    if (entity.type != Json.Type.object) {
      return UnixResponse.error("Request body must be a JSON object", 400);
    }
    if (_idProperty !in entity) {
      entity[_idProperty] = _nextId++;
    }
    _entities ~= entity;
    return UnixResponse.jsonResponse(entity, 201);
  }

  protected override IUnixResponse readHandler(IUnixRequest request, string id) {
    auto entity = findEntity(id);
    return entity.type == Json.Type.null_
      ? UnixResponse.error("Entity not found: " ~ id, 404)
      : UnixResponse.jsonResponse(entity);
  }

  // @trusted: Json access is memory-safe here
  @trusted protected override IUnixResponse updateHandler(IUnixRequest request, string id) {
    auto changes = request.json;
    if (changes.type != Json.Type.object) {
      return UnixResponse.error("Request body must be a JSON object", 400);
    }
    foreach (ref entity; _entities) {
      if (entityId(entity) == id) {
        foreach (string property, Json value; changes) {
          entity[property] = value;
        }
        return UnixResponse.jsonResponse(entity);
      }
    }
    return UnixResponse.error("Entity not found: " ~ id, 404);
  }

  protected override IUnixResponse deleteHandler(IUnixRequest request, string id) {
    foreach (i, entity; _entities) {
      if (entityId(entity) == id) {
        _entities = _entities.remove(i);
        return UnixResponse.jsonResponse(Json.emptyObject, 204);
      }
    }
    return UnixResponse.error("Entity not found: " ~ id, 404);
  }

  /// Number of stored entities
  size_t length() const {
    return _entities.length;
  }

  // @trusted: Json access is memory-safe here
  @trusted private Json findEntity(string id) {
    foreach (entity; _entities) {
      if (entityId(entity) == id) {
        return entity;
      }
    }
    return Json(null);
  }

  // @trusted: Json access is memory-safe here
  @trusted private string entityId(Json entity) {
    auto value = _idProperty in entity;
    return value is null ? null : (*value).toString.strip(`"`);
  }

  private string _idProperty;
  private Json[] _entities;
  private long _nextId = 1;
}

///
unittest {
  // base controller routing
  auto controller = new UnixController("/products");
  assert(controller.routePrefix == "/products");
  assert(controller.canHandle(unixRequest("GET", "/products")));
  assert(controller.canHandle(unixRequest("GET", "/products/1")));
  assert(!controller.canHandle(unixRequest("GET", "/orders")));
  assert(!controller.canHandle(unixRequest("GET", "/productsX")));

  // trailing slash is normalized
  assert(new UnixController("/products/").routePrefix == "/products");

  // unhandled request -> 404
  auto missing = controller.handle(unixRequest("GET", "/products"));
  assert(missing.status == 404);

  // custom handlers
  controller.on("GET", "/", (request) => unixResponse(200, "list"));
  controller.on("GET", "/:id", (request) => unixResponse(200, "one"));
  assert(controller.handle(unixRequest("GET", "/products")).body == "list");
  assert(controller.handle(unixRequest("GET", "/products/42")).body == "one");
  assert(controller.handle(unixRequest("POST", "/products")).status == 404);

  // CRUD controller defaults to 501
  auto crud = new UnixCrudController("/items");
  assert(crud.handle(unixRequest("GET", "/items")).status == 501);
  assert(crud.handle(unixRequest("POST", "/items")).status == 501);
  assert(crud.handle(unixRequest("GET", "/items/1")).status == 501);
  assert(crud.handle(unixRequest("PUT", "/items/1")).status == 501);
  assert(crud.handle(unixRequest("DELETE", "/items/1")).status == 501);

  // memory controller: full CRUD cycle
  auto memory = new UnixMemoryController("/products");
  assert(memory.length == 0);

  // create with generated id
  auto createRequest = unixRequest("POST", "/products").setBody(`{"name":"Milk"}`);
  auto created = memory.handle(createRequest);
  assert(created.status == 201);
  assert(created.body.canFind(`"id":1`));

  // create with explicit id
  memory.handle(unixRequest("POST", "/products").setBody(`{"id":5,"name":"Bread"}`));
  assert(memory.length == 2);

  // create with invalid body
  assert(memory.handle(unixRequest("POST", "/products").setBody("not json")).status == 400);

  // list
  auto list = memory.handle(unixRequest("GET", "/products"));
  assert(list.status == 200);
  assert(list.body.canFind(`"count":2`));

  // read
  assert(memory.handle(unixRequest("GET", "/products/1")).body.canFind("Milk"));
  assert(memory.handle(unixRequest("GET", "/products/99")).status == 404);

  // update
  auto updated = memory.handle(unixRequest("PUT", "/products/1").setBody(`{"name":"Oat Milk"}`));
  assert(updated.status == 200);
  assert(updated.body.canFind("Oat Milk"));
  assert(memory.handle(unixRequest("PUT", "/products/99").setBody(`{"name":"X"}`)).status == 404);
  assert(memory.handle(unixRequest("PUT", "/products/1").setBody("bad")).status == 400);

  // delete
  assert(memory.handle(unixRequest("DELETE", "/products/1")).status == 204);
  assert(memory.length == 1);
  assert(memory.handle(unixRequest("DELETE", "/products/1")).status == 404);
}
