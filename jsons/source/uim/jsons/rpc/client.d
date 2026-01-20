/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.rpc.client;

import uim.jsons;

@safe:

/**
 * JSON-RPC 2.0 client.
 */
class DJsonRpcClient : UIMObject {
  protected long _nextId = 1;

  this() {
    super();
  }

  /**
   * Create a request.
   */
  DJsonRpcRequest createRequest(string method, Json params = Json(null)) {
    auto req = request(method, params, _nextId);
    _nextId++;
    return req;
  }

  /**
   * Create a notification.
   */
  DJsonRpcNotification createNotification(string method, Json params = Json(null)) {
    return notification(method, params);
  }

  /**
   * Create a batch request.
   */
  DJsonRpcBatchRequest createBatch() {
    return new DJsonRpcBatchRequest();
  }

  /**
   * Build a JSON-RPC call.
   */
  string buildCall(string method, Json params = Json(null)) {
    return createRequest(method, params).toJson().toString();
  }

  /**
   * Build a JSON-RPC notification.
   */
  string buildNotification(string method, Json params = Json(null)) {
    return createNotification(method, params).toJson().toString();
  }

  /**
   * Parse a response string.
   */
  DJsonRpcResponse parseResponse(string responseJson) {
    auto json = parseJsonString(responseJson);
    return DJsonRpcResponse.fromJson(json);
  }

  /**
   * Parse a batch response string.
   */
  DJsonRpcBatchResponse parseBatchResponse(string responseJson) {
    auto json = parseJsonString(responseJson);
    return DJsonRpcBatchResponse.fromJson(json);
  }

  /**
   * Reset the ID counter.
   */
  void resetIdCounter(long startId = 1) {
    _nextId = startId;
  }

  /**
   * Get the next ID that will be used.
   */
  long nextId() {
    return _nextId;
  }
}

unittest {
  auto client = new DJsonRpcClient();
  
  auto req = client.createRequest("testMethod", Json([Json(1), Json(2)]));
  assert(req.id.get!long == 1);
  
  auto req2 = client.createRequest("anotherMethod");
  assert(req2.id.get!long == 2);
  
  auto notif = client.createNotification("update");
  assert(notif.method == "update");
}
