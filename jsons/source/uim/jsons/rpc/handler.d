/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.handler;

import uim.jsons;

@safe:

/**
 * Method handler delegate type.
 */
alias jsonRpcHandler = Json delegate(Json params) @safe;

/**
 * Method handler registry.
 */
class DJsonRpcHandlerRegistry : UIMObject {
  protected jsonRpcHandler[string] _handlers;

  this() {
    super();
  }

  /**
   * Register a method handler.
   */
  void register(string methodName, jsonRpcHandler handler) {
    _handlers[methodName] = handler;
  }

  /**
   * Check if a method is registered.
   */
  bool has(string methodName) {
    return (methodName in _handlers) !is null;
  }

  /**
   * Get a method handler.
   */
  jsonRpcHandler get(string methodName) {
    if (auto handler = methodName in _handlers) {
      return *handler;
    }
    return null;
  }

  /**
   * Unregister a method handler.
   */
  bool unregister(string methodName) {
    if (methodName in _handlers) {
      _handlers.remove(methodName);
      return true;
    }
    return false;
  }

  /**
   * Get all registered method names.
   */
  string[] methods() {
    return _handlers.keys;
  }

  /**
   * Clear all handlers.
   */
  void clear() {
    _handlers.clear();
  }
}

unittest {
  auto registry = new DJsonRpcHandlerRegistry();
  
  registry.register("add", (Json params) {
    auto arr = params.get!(Json[]);
    return Json(arr[0].get!long + arr[1].get!long);
  });
  
  assert(registry.has("add"));
  assert(!registry.has("subtract"));
  
  auto handler = registry.get("add");
  assert(handler !is null);
}
