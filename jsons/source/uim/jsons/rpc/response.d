/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.response;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 response.
 */
class DJsonRpcResponse : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _jsonRpc = "2.0";
  protected Json _result;
  protected DJsonRpcError _error;
  protected Json _id;

  this() {
    super();
    _result = Json(null);
    _id = Json(null);
  }

  this(Json result, Json id) {
    this();
    _result = result;
    _id = id;
  }

  this(DJsonRpcError error, Json id) {
    this();
    _error = error;
    _id = id;
  }

  // Getters
  string jsonRpc() { return _jsonRpc; }
  Json result() { return _result; }
  DJsonRpcError error() { return _error; }
  Json id() { return _id; }

  // Setters
  void result(Json value) { 
    _result = value;
    _error = null;
  }
  
  void error(DJsonRpcError value) { 
    _error = value;
    _result = Json(null);
  }
  
  void id(Json value) { _id = value; }

  /**
   * Check if this is an error response.
   */
  bool isError() {
    return _error !is null;
  }

  /**
   * Check if this is a success response.
   */
  bool isSuccess() {
    return _error is null;
  }

  /**
   * Convert to JSON object.
   */
  Json toJson() {
    auto response = Json.emptyObject;
    response["jsonRpc"] = _jsonRpc;
    
    if (_error !is null) {
      response["error"] = _error.toJson();
    } else {
      response["result"] = _result;
    }
    
    response["id"] = _id;
    
    return response;
  }

  /**
   * Create from JSON object.
   */
  static DJsonRpcResponse fromJson(Json json) {
    auto response = new DJsonRpcResponse();
    
    if (auto jsonRpc = "jsonRpc" in json) {
      if (jsonRpc.get!string != "2.0") {
        throw new Exception("Invalid JSON-RPC version");
      }
    }
    
    if (auto id = "id" in json) {
      response.id = *id;
    }
    
    if (auto error = "error" in json) {
      response.error = DJsonRpcError.fromJson(*error);
    } else if (auto result = "result" in json) {
      response.result = *result;
    }
    
    return response;
  }

  /**
   * Validate the response.
   */
  bool validate() {
    if (_jsonRpc != "2.0") return false;
    
    // Must have either result or error, but not both
    bool hasResult = _result.type != Json.Type.null_;
    bool hasError = _error !is null;
    
    if (hasResult && hasError) return false;
    if (!hasResult && !hasError) return false;
    
    return true;
  }

  override string toString() const {
    if (_error !is null) {
      return "JSON-RPC Error Response: " ~ _error.toString();
    }
    return "JSON-RPC Success Response (id: " ~ _id.toString() ~ ")";
  }
}

// Factory functions
DJsonRpcResponse successResponse(Json result, Json id) {
  return new DJsonRpcResponse(result, id);
}

DJsonRpcResponse successResponse(Json result, long id) {
  return new DJsonRpcResponse(result, Json(id));
}

DJsonRpcResponse successResponse(Json result, string id) {
  return new DJsonRpcResponse(result, Json(id));
}

DJsonRpcResponse errorResponse(DJsonRpcError error, Json id) {
  return new DJsonRpcResponse(error, id);
}

DJsonRpcResponse errorResponse(DJsonRpcError error, long id) {
  return new DJsonRpcResponse(error, Json(id));
}

DJsonRpcResponse errorResponse(DJsonRpcError error, string id) {
  return new DJsonRpcResponse(error, Json(id));
}

unittest {
  auto resp = successResponse(Json(42), 1);
  assert(resp.isSuccess());
  assert(!resp.isError());
  assert(resp.validate());
  
  auto errResp = errorResponse(methodNotFound(), 2);
  assert(errResp.isError());
  assert(!errResp.isSuccess());
}
