/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.unix.interfaces;

import uim.service;

mixin(ShowModule!());

@safe:

/// A request received over a unix domain socket connection.
interface IUnixRequest {
  /// The request method, e.g. "GET", "POST"
  string method() const;

  /// The request path, e.g. "/products/1"
  string path() const;

  /// The request headers
  string[string] headers() const;

  /// Returns a header value, null if absent
  string header(string name) const;

  /// The raw request body
  string body() const;

  /// The body parsed as Json (Json(null) if empty or invalid)
  Json json() const;
}

/// A response sent over a unix domain socket connection.
interface IUnixResponse {
  /// The response status code, e.g. 200
  int status() const;

  /// The response headers
  string[string] headers() const;

  /// The response body
  string body() const;

  /// Sets the status code (fluent interface)
  IUnixResponse status(int value);

  /// Sets a header (fluent interface)
  IUnixResponse header(string name, string value);

  /// Sets the body (fluent interface)
  IUnixResponse body(string value);

  /// Sets a Json body and the content type (fluent interface)
  IUnixResponse json(Json value);
}

/// A controller handling requests of a unix socket server.
interface IUnixController {
  /// The route prefix of the controller, e.g. "/products"
  string routePrefix() const;

  /// Whether the controller can handle the given request
  bool canHandle(IUnixRequest request);

  /// Handles a request and produces a response
  IUnixResponse handle(IUnixRequest request);
}

/// A server listening on a unix domain socket.
interface IUnixServer {
  /// The socket path, e.g. "/tmp/app.sock"
  string socketPath() const;

  /// Whether the server is running
  bool running() const;

  /// Starts the server
  void start();

  /// Stops the server
  void stop();
}

/// A single client connection of a unix socket server.
interface IUnixConnection {
  /// Reads a raw request message from the connection
  string readMessage();

  /// Writes a raw response message to the connection
  void writeMessage(string message);

  /// Closes the connection
  void close();
}
