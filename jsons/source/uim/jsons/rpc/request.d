/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.request;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 request.
 */
class DJsonRpcRequest : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _jsonRpc = "2.0";
  protected string _method;
  protected Json _params;
  protected Json _id;

  this() {
    super();
    _params = Json(null);
    _id = Json(null);
  }

  this(string method, Json params = Json(null), Json id = Json(null)) {
    this();
    _method = method;
    _params = params;
    _id = id;
  }

  // Getters
  string jsonRpc() { return _jsonRpc; }
  string method() { return _method; }
  Json params() { return _params; }
  Json id() { return _id; }

  // Setters
  void method(string value) { _method = value; }
  void params(Json value) { _params = value; }
  void id(Json value) { _id = value; }

  /**
   * Check if this is a notification (no id).
   */
  bool isNotification() {
    return _id.type == Json.Type.null_;
  }

  /**
   * Convert to JSON object.
   */
  Json toJson() {
    auto result = Json.emptyObject;
    result["jsonRpc"] = _jsonRpc;
    result["method"] = _method;
    
    if (_params.type != Json.Type.null_) {
      result["params"] = _params;
    }
    
    if (_id.type != Json.Type.null_) {
      result["id"] = _id;
    }
    
    return result;
  }

  /**
   * Create from JSON object.
   */
  static DJsonRpcRequest fromJson(Json json) {
    auto request = new DJsonRpcRequest();
    
    if (auto jsonRpc = "jsonRpc" in json) {
      if (jsonRpc.get!string != "2.0") {
        throw new Exception("Invalid JSON-RPC version");
      }
    } else {
      throw new Exception("Missing jsonRpc field");
    }
    
    if (auto method = "method" in json) {
      request.method = method.get!string;
    } else {
      throw new Exception("Missing method field");
    }
    
    if (auto params = "params" in json) {
      request.params = *params;
    }
    
    if (auto id = "id" in json) {
      request.id = *id;
    }
    
    return request;
  }

  /**
   * Validate the request.
   */
  bool validate() {
    if (_jsonRpc != "2.0") return false;
    if (_method.length == 0) return false;
    
    // Params must be array or object if present
    if (_params.type != Json.Type.null_ && 
        _params.type != Json.Type.array && 
        _params.type != Json.Type.object) {
      return false;
    }
    
    // ID must be string, number or null
    if (_id.type != Json.Type.null_ &&
        _id.type != Json.Type.string &&
        _id.type != Json.Type.int_ &&
        _id.type != Json.Type.float_) {
      return false;
    }
    
    return true;
  }

  override string toString() const {
    return "JSON-RPC Request: " ~ _method ~ " (id: " ~ _id.toString() ~ ")";
  }
}

// Factory functions
DJsonRpcRequest request(string method, Json params = Json(null), long id = 1) {
  return new DJsonRpcRequest(method, params, Json(id));
}

DJsonRpcRequest request(string method, Json params, string id) {
  return new DJsonRpcRequest(method, params, Json(id));
}

DJsonRpcRequest requestWithArrayParams(string method, Json[] params, long id = 1) {
  return new DJsonRpcRequest(method, Json(params), Json(id));
}

DJsonRpcRequest requestWithObjectParams(string method, Json[string] params, long id = 1) {
  return new DJsonRpcRequest(method, Json(params), Json(id));
}

unittest {
  auto req = request("subtract", Json([Json(42), Json(23)]), 1);
  assert(req.method == "subtract");
  assert(!req.isNotification());
  assert(req.validate());
  
  auto json = req.toJson();
  assert("jsonRpc" in json);
  assert(json["jsonRpc"].get!string == "2.0");
}
