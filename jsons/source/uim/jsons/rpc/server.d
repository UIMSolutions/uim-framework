/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.server;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 server.
 */
class DJsonRpcServer : UIMObject {
  protected DJsonRpcHandlerRegistry _handlers;

  this() {
    super();
    _handlers = new DJsonRpcHandlerRegistry();
  }

  /**
   * Register a method handler.
   */
  DJsonRpcServer register(string methodName, jsonRpcHandler handler) {
    _handlers.register(methodName, handler);
    return this;
  }

  /**
   * Process a JSON-RPC request string.
   */
  string handleRequest(string requestJson) {
    try {
      auto json = parseJsonString(requestJson);
      
      // Check if it's a batch request
      if (json.type == Json.Type.array) {
        return handleBatchRequest(json).toJson().toString();
      } else {
        return handleSingleRequest(json).toJson().toString();
      }
    } catch (Exception e) {
      auto error = parseError(e.msg);
      return errorResponse(error, Json(null)).toJson().toString();
    }
  }

  /**
   * Process a single request.
   */
  protected DJsonRpcResponse handleSingleRequest(Json json) {
    try {
      auto request = DJsonRpcRequest.fromJson(json);
      
      if (!request.validate()) {
        return errorResponse(invalidRequest(), request.id);
      }
      
      // Check if method exists
      if (!_handlers.has(request.method)) {
        return errorResponse(methodNotFound(request.method), request.id);
      }
      
      // Get handler and execute
      auto handler = _handlers.get(request.method);
      
      try {
        auto result = handler(request.params);
        return successResponse(result, request.id);
      } catch (Exception e) {
        return errorResponse(internalError(e.msg), request.id);
      }
      
    } catch (Exception e) {
      return errorResponse(invalidRequest(e.msg), Json(null));
    }
  }

  /**
   * Process a batch request.
   */
  protected DJsonRpcBatchResponse handleBatchRequest(Json json) {
    auto batchResponse = new DJsonRpcBatchResponse();
    
    if (json.get!(Json[]).length == 0) {
      batchResponse.add(errorResponse(invalidRequest("Empty array"), Json(null)));
      return batchResponse;
    }
    
    foreach (item; json.get!(Json[])) {
      auto response = handleSingleRequest(item);
      
      // Don't include responses for notifications
      try {
        auto request = DJsonRpcRequest.fromJson(item);
        if (!request.isNotification()) {
          batchResponse.add(response);
        }
      } catch (Exception) {
        batchResponse.add(response);
      }
    }
    
    return batchResponse;
  }

  /**
   * Get list of registered methods.
   */
  string[] methods() {
    return _handlers.methods();
  }
}

unittest {
  auto server = new DJsonRpcServer();
  
  // Register methods
  server.register("add", (Json params) {
    auto arr = params.get!(Json[]);
    return Json(arr[0].get!long + arr[1].get!long);
  });
  
  server.register("subtract", (Json params) {
    auto arr = params.get!(Json[]);
    return Json(arr[0].get!long - arr[1].get!long);
  });
  
  assert(server.methods().length == 2);
}
