/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.rpc.batch;

import uim.jsons;

@safe:

/**
 * Json-RPC 2.0 batch request.
 */
class JsonRpcBatchRequest : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected JsonRpcRequest[] _requests;

  this() {
    super();
  }

  this(JsonRpcRequest[] requests) {
    this();
    _requests = requests;
  }

  // Getters
  JsonRpcRequest[] requests() { return _requests.dup; }

  /**
   * Add a request to the batch.
   */
  void add(JsonRpcRequest request) {
    _requests ~= request;
  }

  /**
   * Get number of requests in batch.
   */
  size_t count() {
    return _requests.length;
  }

  /**
   * Check if batch is empty.
   */
  bool isEmpty() {
    return _requests.length == 0;
  }

  /**
   * Convert to Json array.
   */
  override Json toJson() {
    Json[] jsonArray;
    foreach (request; _requests) {
      jsonArray ~= request.toJson();
    }
    return Json(jsonArray);
  }

  /**
   * Create from Json array.
   */
  static JsonRpcBatchRequest fromJson(Json json) {
    auto batch = new JsonRpcBatchRequest();
    
    if (json.type != Json.Type.array) {
      throw new Exception("Batch request must be an array");
    }
    
    foreach (item; json.get!(Json[])) {
      batch.add(JsonRpcRequest.fromJson(item));
    }
    
    return batch;
  }
}

/**
 * Json-RPC 2.0 batch response.
 */
class JsonRpcBatchResponse : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected JsonRpcResponse[] _responses;

  this() {
    super();
  }

  this(JsonRpcResponse[] responses) {
    this();
    _responses = responses;
  }

  // Getters
  JsonRpcResponse[] responses() { return _responses.dup; }

  /**
   * Add a response to the batch.
   */
  void add(JsonRpcResponse response) {
    _responses ~= response;
  }

  /**
   * Get number of responses in batch.
   */
  size_t count() {
    return _responses.length;
  }

  /**
   * Check if batch is empty.
   */
  bool isEmpty() {
    return _responses.length == 0;
  }

  /**
   * Convert to Json array.
   */
  override Json toJson() {
    Json[] jsonArray;
    foreach (response; _responses) {
      jsonArray ~= response.toJson();
    }
    return Json(jsonArray);
  }

  /**
   * Create from Json array.
   */
  static JsonRpcBatchResponse fromJson(Json json) {
    auto batch = new JsonRpcBatchResponse();
    
    if (json.type != Json.Type.array) {
      throw new Exception("Batch response must be an array");
    }
    
    foreach (item; json.get!(Json[])) {
      batch.add(JsonRpcResponse.fromJson(item));
    }
    
    return batch;
  }
}

unittest {
  auto batch = new JsonRpcBatchRequest();
  batch.add(request("method1", Json(null), 1));
  batch.add(request("method2", Json(null), 2));
  
  assert(batch.count() == 2);
  assert(!batch.isEmpty());
  
  auto json = batch.toJson();
  assert(json.type == Json.Type.array);
  assert(json.get!(Json[]).length == 2);
}
