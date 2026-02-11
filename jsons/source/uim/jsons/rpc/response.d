/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.rpc.response;

import uim.jsons;

mixin(ShowModule!());

@safe:
/**
 * Json-RPC 2.0 response.
 */
class JsonRpcResponse : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _jsonRpc = "2.0";
  protected Json _result;
  protected JsonRpcError _error;
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

  this(JsonRpcError error, Json id) {
    this();
    _error = error;
    _id = id;
  }

  // Getters
  string jsonRpc() { return _jsonRpc; }
  Json result() { return _result; }
  JsonRpcError error() { return _error; }
  Json id() { return _id; }

  // Setters
  void result(Json value) { 
    _result = value;
    _error = null;
  }
  
  void error(JsonRpcError value) { 
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
   * Convert to Json object.
   */
  override Json toJson() {
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
   * Create from Json object.
   */
  static JsonRpcResponse fromJson(Json json) {
    auto response = new JsonRpcResponse();
    
    if (auto jsonRpc = "jsonRpc" in json) {
      if (jsonRpc.get!string != "2.0") {
        throw new Exception("Invalid Json-RPC version");
      }
    }
    
    if (auto id = "id" in json) {
      response.id = *id;
    }
    
    if (auto error = "error" in json) {
      response.error = JsonRpcError.fromJson(*error);
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
      return "Json-RPC Error Response: " ~ _error.toString();
    }
    return "Json-RPC Success Response (id: " ~ _id.toString() ~ ")";
  }
}

// Factory functions
JsonRpcResponse successResponse(Json result, Json id) {
  return new JsonRpcResponse(result, id);
}

JsonRpcResponse successResponse(Json result, long id) {
  return new JsonRpcResponse(result, Json(id));
}

JsonRpcResponse successResponse(Json result, string id) {
  return new JsonRpcResponse(result, Json(id));
}

JsonRpcResponse errorResponse(JsonRpcError error, Json id) {
  return new JsonRpcResponse(error, id);
}

JsonRpcResponse errorResponse(JsonRpcError error, long id) {
  return new JsonRpcResponse(error, Json(id));
}

JsonRpcResponse errorResponse(JsonRpcError error, string id) {
  return new JsonRpcResponse(error, Json(id));
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
