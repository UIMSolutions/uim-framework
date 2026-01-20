/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.error;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 error codes.
 */
enum jsonRpcErrorCode : int {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  ServerError = -32000  // -32000 to -32099 are reserved for implementation-defined server errors
}

/**
 * JSON-RPC error object.
 */
class DJsonRpcError : UIMObject {
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
   * Convert to JSON object.
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
   * Create from JSON object.
   */
  static DJsonRpcError fromJson(Json json) {
    auto error = new DJsonRpcError();
    
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
    return "JSON-RPC Error " ~ _code.to!string ~ ": " ~ _message;
  }
}

// Factory functions for common errors
DJsonRpcError parseError(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new DJsonRpcError(
    jsonRpcErrorCode.ParseError,
    "Parse error",
    data
  );
}

DJsonRpcError invalidRequest(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new DJsonRpcError(
    jsonRpcErrorCode.InvalidRequest,
    "Invalid Request",
    data
  );
}

DJsonRpcError methodNotFound(string methodName = "") {
  auto data = methodName.length > 0 ? Json(methodName) : Json(null);
  return new DJsonRpcError(
    jsonRpcErrorCode.MethodNotFound,
    "Method not found",
    data
  );
}

DJsonRpcError invalidParams(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new DJsonRpcError(
    jsonRpcErrorCode.InvalidParams,
    "Invalid params",
    data
  );
}

DJsonRpcError internalError(string details = "") {
  auto data = details.length > 0 ? Json(details) : Json(null);
  return new DJsonRpcError(
    jsonRpcErrorCode.InternalError,
    "Internal error",
    data
  );
}

DJsonRpcError serverError(int code, string message, Json data = Json(null)) {
  if (code < -32099 || code > -32000) {
    code = jsonRpcErrorCode.ServerError;
  }
  return new DJsonRpcError(code, message, data);
}

unittest {
  auto error = methodNotFound("testMethod");
  assert(error.code == jsonRpcErrorCode.MethodNotFound);
  assert(error.message == "Method not found");
  
  auto json = error.toJson();
  assert("code" in json);
  assert(json["code"].get!int == -32601);
}
