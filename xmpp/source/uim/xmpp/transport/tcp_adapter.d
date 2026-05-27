/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.transport.tcp_adapter;

import std.conv : to;
import std.string : startsWith;

import vibe.core.net : TCPConnection, connectTCP;

import uim.xmpp;

mixin(ShowModule!());

@safe:

struct XMPPEndpoint {
  string scheme;
  string host;
  ushort port;
}

class UIMXMPPTcpAdapter : UIMObject {
  private XMPPEndpoint _endpoint;
  private TCPConnection _connection;

  bool open(string serverUrl) {
    try {
      _endpoint = xmppParseServerUrl(serverUrl);
      _connection = connectTCP(_endpoint.host, _endpoint.port);
      return cast(bool) _connection;
    } catch (Exception) {
      return false;
    }
  }

  bool close() {
    if (!_connection) {
      return false;
    }

    _connection.close();
    _connection = TCPConnection.init;
    return true;
  }

  bool isOpen() const {
    return cast(bool) _connection;
  }

  XMPPEndpoint endpoint() const {
    return _endpoint;
  }

  bool sendRaw(string data) {
    if (!_connection || data.length == 0) {
      return false;
    }

    try {
      _connection.write(data);
      return true;
    } catch (Exception) {
      return false;
    }
  }
}

XMPPEndpoint xmppParseServerUrl(string serverUrl) {
  if (serverUrl.length == 0) {
    throw new Exception("Server URL must not be empty");
  }

  XMPPEndpoint endpoint;

  if (serverUrl.startsWith("xmpp://")) {
    endpoint.scheme = "xmpp";
    endpoint.port = 5222;
    serverUrl = serverUrl[7 .. $];
  } else if (serverUrl.startsWith("xmpps://")) {
    endpoint.scheme = "xmpps";
    endpoint.port = 5223;
    serverUrl = serverUrl[8 .. $];
  } else {
    throw new Exception("Unsupported XMPP server scheme");
  }

  auto hostPort = serverUrl;
  const slashPos = indexOfOrLength(serverUrl, '/');
  if (slashPos < serverUrl.length) {
    hostPort = serverUrl[0 .. slashPos];
  }

  if (hostPort.length == 0) {
    throw new Exception("Missing server host");
  }

  const colonPos = indexOfOrLength(hostPort, ':');
  if (colonPos < hostPort.length) {
    endpoint.host = hostPort[0 .. colonPos];
    auto rawPort = hostPort[colonPos + 1 .. $];
    if (rawPort.length == 0) {
      throw new Exception("Missing server port");
    }
    endpoint.port = rawPort.to!ushort;
  } else {
    endpoint.host = hostPort;
  }

  if (endpoint.host.length == 0) {
    throw new Exception("Missing server host");
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
  auto endpoint = xmppParseServerUrl("xmpp://localhost");
  assert(endpoint.scheme == "xmpp");
  assert(endpoint.host == "localhost");
  assert(endpoint.port == 5222);
}

unittest {
  auto endpoint = xmppParseServerUrl("xmpps://chat.example.org:5224");
  assert(endpoint.scheme == "xmpps");
  assert(endpoint.host == "chat.example.org");
  assert(endpoint.port == 5224);
}

unittest {
  import std.exception : assertThrown;
  assertThrown!Exception(xmppParseServerUrl(""));
  assertThrown!Exception(xmppParseServerUrl("http://localhost"));
  assertThrown!Exception(xmppParseServerUrl("xmpp://"));
  assertThrown!Exception(xmppParseServerUrl("xmpp://localhost:abc"));
}

unittest {
  // Test with trailing slash
  auto endpoint = xmppParseServerUrl("xmpp://example.com:5222/");
  assert(endpoint.host == "example.com");
  assert(endpoint.port == 5222);

  import std.exception : assertThrown;
  assertThrown!Exception(xmppParseServerUrl("xmpp://:5222"));
}
