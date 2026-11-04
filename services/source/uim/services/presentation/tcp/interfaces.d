/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.tcp.interfaces;

import uim.services;

mixin(ShowModule!());

@safe:

/// A request received over a tcp connection.
interface ITcpRequest {
  /// The request method, e.g. "GET", "POST"
  string method() const;

  /// The request path, e.g. "/products/1"
  string path() const;

  /// The address of the client, null if unknown
  string peer() const;

  /// The request headers
  string[string] headers() const;

  /// Returns a header value (case-insensitive), null if absent
  string header(string name) const;

  /// The raw request body
  string body() const;

  /// The body parsed as Json (Json(null) if empty or invalid)
  Json json() const;
}

/// A response sent over a tcp connection.
interface ITcpResponse {
  /// The response status code, e.g. 200
  int status() const;

  /// The response headers
  string[string] headers() const;

  /// The response body
  string body() const;

  /// Sets the status code (fluent interface)
  ITcpResponse status(int value);

  /// Sets a header (fluent interface)
  ITcpResponse header(string name, string value);

  /// Sets the body (fluent interface)
  ITcpResponse body(string value);

  /// Sets a Json body and the content type (fluent interface)
  ITcpResponse json(Json value);
}

/// A controller handling requests of a tcp server.
interface ITcpController {
  /// The route prefix of the controller, e.g. "/products"
  string routePrefix() const;

  /// Whether the controller can handle the given request
  bool canHandle(ITcpRequest request);

  /// Handles a request and produces a response
  ITcpResponse handle(ITcpRequest request);
}

/// A server listening on a tcp port.
interface ITcpServer {
  /// The address the server binds to, e.g. "127.0.0.1"
  string host() const;

  /// The port the server listens on, e.g. 9000
  ushort port() const;

  /// Whether the server is running
  bool running() const;

  /// Starts the server
  void start();

  /// Stops the server
  void stop();
}

/// A single client connection of a tcp server.
interface ITcpConnection {
  /// The address of the remote endpoint
  string peer() const;

  /// Reads one complete message from the byte stream, see tcpFrameLength
  string readMessage();

  /// Writes a complete message to the connection
  void writeMessage(string message);

  /// Closes the connection
  void close();
}
