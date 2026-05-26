/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.transport.udp_adapter;

import core.time : Duration, seconds;
import std.conv : to;
import std.string : startsWith;

import vibe.core.net : UDPConnection, listenUDP;

import uim.coap;

mixin(ShowModule!());

@safe:

struct CoAPEndpoint {
  string scheme;
  string host;
  ushort port;
}

class UIMCoAPUdpAdapter : UIMObject {
  private CoAPEndpoint _endpoint;
  private UDPConnection _socket;

  bool open(string endpointUrl) {
    try {
      _endpoint = coapParseEndpoint(endpointUrl);
      _socket = listenUDP(cast(ushort) 0);
      _socket.connect(_endpoint.host, _endpoint.port);
      return cast(bool) _socket;
    } catch (Exception) {
      return false;
    }
  }

  bool close() {
    if (!_socket) {
      return false;
    }

    _socket.close();
    _socket = UDPConnection.init;
    return true;
  }

  bool isOpen() const {
    return cast(bool) _socket;
  }

  CoAPEndpoint endpoint() const {
    return _endpoint;
  }

  bool send(ICoAPMessage message) {
    if (!_socket || message is null) {
      return false;
    }

    try {
      auto packet = coapEncodeMessage(message);
      _socket.send(packet);
      return true;
    } catch (Exception) {
      return false;
    }
  }

  bool receive(out ICoAPMessage message, Duration timeout = 2.seconds) {
    message = null;
    if (!_socket) {
      return false;
    }

    try {
      auto packet = _socket.recv(timeout);
      message = coapDecodeMessage(packet);
      return true;
    } catch (Exception) {
      return false;
    }
  }
}

CoAPEndpoint coapParseEndpoint(string endpointUrl) {
  if (endpointUrl.length == 0) {
    throw new Exception("CoAP endpoint must not be empty");
  }

  CoAPEndpoint endpoint;

  if (endpointUrl.startsWith("coap://")) {
    endpoint.scheme = "coap";
    endpoint.port = 5683;
    endpointUrl = endpointUrl[7 .. $];
  } else if (endpointUrl.startsWith("coaps://")) {
    endpoint.scheme = "coaps";
    endpoint.port = 5684;
    endpointUrl = endpointUrl[8 .. $];
  } else {
    throw new Exception("Unsupported CoAP endpoint scheme");
  }

  const slashPos = indexOfOrLength(endpointUrl, '/');
  auto hostPort = endpointUrl[0 .. slashPos];
  if (hostPort.length == 0) {
    throw new Exception("Missing CoAP host");
  }

  const colonPos = indexOfOrLength(hostPort, ':');
  if (colonPos < hostPort.length) {
    endpoint.host = hostPort[0 .. colonPos];
    const rawPort = hostPort[colonPos + 1 .. $];
    if (rawPort.length == 0) {
      throw new Exception("Missing CoAP port");
    }
    endpoint.port = rawPort.to!ushort;
  } else {
    endpoint.host = hostPort;
  }

  if (endpoint.host.length == 0) {
    throw new Exception("Missing CoAP host");
  }

  return endpoint;
}

private size_t indexOfOrLength(string value, dchar needle) {
  foreach (i, ch; value) {
    if (ch == needle) {
      return i;
    }
  }
  return value.length;
}

unittest {
  auto endpoint = coapParseEndpoint("coap://localhost");
  assert(endpoint.scheme == "coap");
  assert(endpoint.host == "localhost");
  assert(endpoint.port == 5683);
}

unittest {
  auto endpoint = coapParseEndpoint("coaps://example.net:5689");
  assert(endpoint.scheme == "coaps");
  assert(endpoint.host == "example.net");
  assert(endpoint.port == 5689);
}
