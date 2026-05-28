/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.session;

import uim.opc;

mixin(ShowModule!());

@safe:

class UIMOpcSession : UIMObject, IOpcSession {
  private string _sessionId;
  private bool   _active;

  this() {
    import std.conv : to;
    import core.time : MonoTime;
    _sessionId = "session-" ~ MonoTime.currTime.ticks.to!string;
    _active    = false;
  }

  string    sessionId() { return _sessionId; }
  bool      isActive()  { return _active;    }

  OpcStatus activate(OpcUserIdentity identity) {
    _active = true;
    return opcGoodStatus("Session activated");
  }

  OpcStatus close() {
    _active = false;
    return opcGoodStatus("Session closed");
  }

  unittest {
    auto s = new UIMOpcSession();
    assert(!s.isActive);
    assert(s.sessionId.length > 0);

    auto st = s.activate(OpcUserIdentity.anonymous_());
    assert(st.good);
    assert(s.isActive);

    st = s.close();
    assert(st.good);
    assert(!s.isActive);
  }
}

// Loopback client — connects directly to a UIMOpcLoopbackServer in-process
class UIMOpcLoopbackClient : UIMObject, IOpcClient {
  private bool         _connected;
  private string       _endpointUrl;
  private UIMOpcLoopbackServer _server;

  this(UIMOpcLoopbackServer server) {
    _server    = server;
    _connected = false;
  }

  OpcStatus connect(OpcEndpoint endpoint) {
    _endpointUrl = endpoint.endpointUrl;
    _connected   = true;
    return opcGoodStatus("Connected");
  }

  OpcStatus disconnect() {
    _connected   = false;
    _endpointUrl = "";
    return opcGoodStatus("Disconnected");
  }

  bool   isConnected() { return _connected;    }
  string endpointUrl() { return _endpointUrl;  }

  IOpcSession createSession() {
    return new UIMOpcSession();
  }

  UIMOpcLoopbackServer addressSpace() { return _server; }

  unittest {
    auto srv = new UIMOpcLoopbackServer();
    auto client = new UIMOpcLoopbackClient(srv);
    assert(!client.isConnected);

    auto ep = OpcEndpoint("opc.tcp://localhost:4840/");
    auto st = client.connect(ep);
    assert(st.good);
    assert(client.isConnected);
    assert(client.endpointUrl == "opc.tcp://localhost:4840/");

    auto session = client.createSession();
    assert(session !is null);
    auto act = session.activate(OpcUserIdentity.anonymous_());
    assert(act.good);
    assert(session.isActive);

    st = client.disconnect();
    assert(st.good);
    assert(!client.isConnected);
  }
}

auto OpcSession() {
  return new UIMOpcSession();
}

auto OpcLoopbackClient(UIMOpcLoopbackServer server) {
  return new UIMOpcLoopbackClient(server);
}
