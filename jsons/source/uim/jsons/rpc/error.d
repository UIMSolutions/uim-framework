/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.rpc.error;

import uim.jsons;

mixin(ShowModule!());

@safe:

/**
 * Json-RPC 2.0 error codes.
 */
enum JsonRpcErrorCode : int {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  ServerError = -32000  // -32000 to -32099 are reserved for implementation-defined server errors
}

/**
 * Json-RPC error object.
 */
class JsonRpcError : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected int _code;
  protected string _message;
  protected Json _data;

  this() {
    super();
    _data = Json(null);
  }

  this(int code, string message, Json data = Json(null)) {
    this();
    _code = code;
    _message = message;
    _data = data;
  }

  // Getters
  int code() { return _code; }
  string message() { return _message; }
  Json data() { return _data; }

  // Setters
  void code(int value) { _code = value; }
  void message(string value) { _message = value; }
  void data(Json value) { _data = value; }

  /**
   * Convert to Json object.
   */
  Json toJson() {
    auto result = Json.emptyObject;
    result["code"] = _code;
    result["message"] = _message;
    if (_data.type != Json.Type.null_) {
      result["data"] = _data;
    }
    return result;
  }

  /**
   * Create from Json object.
   */
  static JsonRpcError fromJson(Json json) {
    auto error = new JsonRpcError();
    
    if (auto code = "code" in json) {
      error.code = code.get!int;
    }
    
    if (auto message = "message" in json) {
      error.message = message.get!string;
    }
    
    if (auto data = "data" in json) {
      error.data = *data;
    }
    
    return error;
  }

  override string toString() const {
    return "Json-RPC Error " ~ _code.to!string ~ ": " ~ _message;
  }
}

// Factory functions for common errors
JsonRpcError parseError(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new JsonRpcError(
    JsonRpcErrorCode.ParseError,
    "Parse error",
    data
  );
}

JsonRpcError invalidRequest(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new JsonRpcError(
    JsonRpcErrorCode.InvalidRequest,
    "Invalid Request",
    data
  );
}

JsonRpcError methodNotFound(string methodName = "") {
  auto data = methodName.length > 0 ? Json(methodName) : Json(null);
  return new JsonRpcError(
    JsonRpcErrorCode.MethodNotFound,
    "Method not found",
    data
  );
}

JsonRpcError invalidParams(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new JsonRpcError(
    JsonRpcErrorCode.InvalidParams,
    "Invalid params",
    data
  );
}

JsonRpcError internalError(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new JsonRpcError(
    JsonRpcErrorCode.InternalError,
    "Internal error",
    data
  );
}

JsonRpcError serverError(int code, string message, Json data = Json(null)) {
  if (code < -32099 || code > -32000) {
    code = JsonRpcErrorCode.ServerError;
  }
  return new JsonRpcError(code, message, data);
}

unittest {
  auto error = methodNotFound("testMethod");
  assert(error.code == JsonRpcErrorCode.MethodNotFound);
  assert(error.message == "Method not found");
  
  auto json = error.toJson();
  assert("code" in json);
  assert(json["code"].get!int == -32601);
}
