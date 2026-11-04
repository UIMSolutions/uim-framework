/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.unix.server;

import uim.services;
import uim.services.presentation.unix.controller;
import uim.services.presentation.unix.interfaces;
import uim.services.presentation.unix.message;

mixin(ShowModule!());

@safe:

/// A unix domain socket server dispatching requests to controllers.
class UnixServer : IUnixServer {
  this(string socketPath = "/tmp/uim-service.sock") {
    _socketPath = socketPath;
  }

  string socketPath() const {
    return _socketPath;
  }

  bool running() const {
    return _running;
  }

  /// Registers a controller (fluent interface)
  auto registerController(IUnixController controller) {
    _controllers ~= controller;
    return this;
  }

  /// Removes a controller (fluent interface)
  auto unregisterController(IUnixController controller) {
    _controllers = _controllers.filter!(c => c !is controller).array;
    return this;
  }

  /// All registered controllers
  IUnixController[] controllers() {
    return _controllers.dup;
  }

  /// Dispatches a request to the first matching controller
  IUnixResponse dispatch(IUnixRequest request) {
    if (request is null) {
      return UnixResponse.error("Request is required", 400);
    }
    foreach (controller; _controllers) {
      if (controller.canHandle(request)) {
        return controller.handle(request);
      }
    }
    return UnixResponse.error("No controller for path: " ~ request.path, 404);
  }

  /// Handles a raw wire-format message and returns the raw response
  string handleMessage(string message) {
    try {
      auto request = UnixRequest.parse(message);
      auto response = cast(UnixResponse)dispatch(request);
      return response !is null ? response.toString : UnixResponse.error("Invalid response", 500).toString;
    } catch (Exception e) {
      return UnixResponse.error("Bad request: " ~ e.msg, 400).toString;
    }
  }

  /// Starts the server
  void start() {
    _running = true;
  }

  /// Stops the server
  void stop() {
    _running = false;
  }

  private string _socketPath;
  private bool _running;
  private IUnixController[] _controllers;
}

/// Creates a unix socket server, e.g. unixServer("/tmp/app.sock")
UnixServer unixServer(string socketPath = "/tmp/uim-service.sock") {
  return new UnixServer(socketPath);
}

///
unittest {
  auto server = new UnixServer("/tmp/test.sock");
  assert(server.socketPath == "/tmp/test.sock");
  assert(!server.running);

  server.start();
  assert(server.running);
  server.stop();
  assert(!server.running);

  // no controllers -> 404
  auto notFound = server.dispatch(unixRequest("GET", "/products"));
  assert(notFound.status == 404);
  assert(notFound.body.canFind("/products"));

  // null request -> 400
  assert(server.dispatch(null).status == 400);

  // controller registration and dispatch
  auto products = new UnixMemoryController("/products");
  auto orders = new UnixMemoryController("/orders");
  server.registerController(products).registerController(orders);
  assert(server.controllers.length == 2);

  auto created = server.dispatch(unixRequest("POST", "/products").setBody(`{"name":"Milk"}`));
  assert(created.status == 201);

  auto list = server.dispatch(unixRequest("GET", "/products"));
  assert(list.status == 200);
  assert(list.body.canFind("Milk"));

  // second controller is independent
  auto orderList = server.dispatch(unixRequest("GET", "/orders"));
  assert(orderList.status == 200);
  assert(orderList.body.canFind(`"count":0`));

  // unregister
  server.unregisterController(orders);
  assert(server.controllers.length == 1);
  assert(server.dispatch(unixRequest("GET", "/orders")).status == 404);

  // raw message handling (wire format round trip)
  string rawResponse = server.handleMessage("GET /products\nX-Tenant-Id: default\n\n");
  auto parsed = UnixResponse.parse(rawResponse);
  assert(parsed.status == 200);
  assert(parsed.body.canFind("Milk"));

  // invalid raw message -> 400
  string badResponse = server.handleMessage("garbage\n\n");
  assert(UnixResponse.parse(badResponse).status == 400);

  // factory
  assert(unixServer().socketPath == "/tmp/uim-service.sock");
}
