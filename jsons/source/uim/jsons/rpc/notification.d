/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.notification;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 notification (request without id).
 */
class DJsonRpcNotification : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _jsonRpc = "2.0";
  protected string _method;
  protected Json _params;

  this() {
    super();
    _params = Json(null);
  }

  this(string method, Json params = Json(null)) {
    this();
    _method = method;
    _params = params;
  }

  // Getters
  string jsonRpc() { return _jsonRpc; }
  string method() { return _method; }
  Json params() { return _params; }

  // Setters
  void method(string value) { _method = value; }
  void params(Json value) { _params = value; }

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
    
    return result;
  }

  /**
   * Create from JSON object.
   */
  static DJsonRpcNotification fromJson(Json json) {
    auto notification = new DJsonRpcNotification();
    
    if (auto jsonRpc = "jsonRpc" in json) {
      if (jsonRpc.get!string != "2.0") {
        throw new Exception("Invalid JSON-RPC version");
      }
    }
    
    if (auto method = "method" in json) {
      notification.method = method.get!string;
    } else {
      throw new Exception("Missing method field");
    }
    
    if (auto params = "params" in json) {
      notification.params = *params;
    }
    
    return notification;
  }

  /**
   * Convert to request (for internal use).
   */
  DJsonRpcRequest toRequest() {
    return new DJsonRpcRequest(_method, _params, Json(null));
  }

  override string toString() const {
    return "JSON-RPC Notification: " ~ _method;
  }
}

// Factory functions
DJsonRpcNotification notification(string method, Json params = Json(null)) {
  return new DJsonRpcNotification(method, params);
}

DJsonRpcNotification notificationWithArrayParams(string method, Json[] params) {
  return new DJsonRpcNotification(method, Json(params));
}

DJsonRpcNotification notificationWithObjectParams(string method, Json[string] params) {
  return new DJsonRpcNotification(method, Json(params));
}

unittest {
  auto notif = notification("update", Json([Json("param1"), Json("param2")]));
  assert(notif.method == "update");
  
  auto json = notif.toJson();
  assert("id" !in json);
  assert("method" in json);
}
