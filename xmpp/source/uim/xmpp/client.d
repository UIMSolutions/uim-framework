/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.client;

import std.datetime : Clock;
import std.format : format;
import std.string : startsWith;

import vibe.d : runTask;

import uim.xmpp;

mixin(ShowModule!());

@safe:

class UIMXMPPClient : UIMObject, IXMPPClient {
  private bool _connected = false;
  private string _serverUrl;
  private string _jid;
  private string _password;
  private XMPPStanzaHandler[][XMPPStanzaKind] _handlers;
  private UIMXMPPTcpAdapter _transport;
  private bool _transportEnabled = false;

  bool connect(string serverUrl, string jid = "", string password = "") {
    if (serverUrl.length == 0) {
      return false;
    }

    _serverUrl = serverUrl;
    _jid = jid.length > 0 ? xmppNormalizeJid(jid) : format("anon-%s@localhost", Clock.currTime().toUnixTime());
    _password = password;

    _transportEnabled = false;
    _transport = null;

    if (serverUrl.startsWith("xmpp://") || serverUrl.startsWith("xmpps://")) {
      auto adapter = new UIMXMPPTcpAdapter();
      if (adapter.open(serverUrl)) {
        _transport = adapter;
        _transportEnabled = true;
      } else {
        adapter.close();
      }
    }

    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    if (_transportEnabled && _transport !is null) {
      _transport.close();
      _transport = null;
      _transportEnabled = false;
    }

    _handlers = null;
    _password = "";
    _connected = false;
    return true;
  }

  bool send(IXMPPStanza stanza) {
    if (!_connected || stanza is null) {
      return false;
    }

    if (stanza.fromJid().length == 0) {
      stanza.fromJid(_jid);
    }

    if (_transportEnabled && _transport !is null) {
      auto xml = xmppEncodeStanza(stanza);
      if (xml.length > 0) {
        _transport.sendRaw(xml);
      }
    }

    dispatch(stanza);
    return true;
  }

  bool on(XMPPStanzaKind kind, XMPPStanzaHandler handler) {
    if (!_connected || handler is null) {
      return false;
    }

    _handlers[kind] ~= handler;
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string jid() const {
    return _jid;
  }

  string serverUrl() const {
    return _serverUrl;
  }

  bool usingTcpTransport() const {
    return _transportEnabled;
  }

  protected void dispatch(IXMPPStanza stanza) @trusted {
    if (stanza is null || stanza.kind() !in _handlers) {
      return;
    }

    foreach (handler; _handlers[stanza.kind()]) {
      auto localHandler = handler;
      auto localStanza = stanza;
      runTask(() nothrow {
        try {
          localHandler(localStanza);
        } catch (Exception) {
        }
      });
    }
  }
}

auto XMPPClient() {
  return new UIMXMPPClient();
}

unittest {
  auto client = XMPPClient();
  assert(client.connect("xmpp://localhost:5222", "alice@example.org", "secret"));
  assert(client.connected());
  assert(client.jid() == "alice@example.org");
  assert(client.disconnect());
}

unittest {
  auto client = XMPPClient();
  assert(client.connect("xmpp://localhost:5222", "alice@example.org"));

  int hit = 0;
  assert(client.on(XMPPStanzaKind.message, (IXMPPStanza stanza) {
    assert(stanza.kind() == XMPPStanzaKind.message);
    assert(stanza.body() == "hello");
    hit++;
  }));

  auto stanza = XMPPStanza(XMPPStanzaKind.message)
    .toJid("bob@example.org")
    .stanzaType("chat")
    .body("hello");

  assert(client.send(stanza));

  import vibe.d : sleep;
  import core.time : msecs;
  sleep(20.msecs);

  assert(hit == 1);
  assert(client.disconnect());
}

unittest {
  auto client = XMPPClient();
  client.connect("xmpp://localhost");

  int messageCount = 0;
  int iqCount = 0;

  client.on(XMPPStanzaKind.message, (s) { messageCount++; });
  client.on(XMPPStanzaKind.iq, (s) { iqCount++; });

  client.send(XMPPStanza(XMPPStanzaKind.message));
  client.send(XMPPStanza(XMPPStanzaKind.iq));

  import vibe.d : sleep;
  import core.time : msecs;
  sleep(50.msecs);

  assert(messageCount == 1);
  assert(iqCount == 1);
}

unittest {
  auto client = XMPPClient();
  
  // Test sending while disconnected
  assert(!client.send(XMPPStanza()));
  
  // Test anonymous JID generation
  assert(client.connect("xmpp://localhost"));
  assert(client.jid().startsWith("anon-"));
  assert(client.connected());
  
  // Test handler registration while disconnected
  auto otherClient = XMPPClient();
  assert(!otherClient.on(XMPPStanzaKind.message, (s) {}));
  
  // Test invalid connection string
  assert(!otherClient.connect(""));
  assert(!otherClient.connected());
}

unittest {
  auto client = XMPPClient();
  client.connect("xmpp://localhost");

  int countA = 0;
  int countB = 0;

  // Test multiple handlers for the same kind
  client.on(XMPPStanzaKind.message, (s) { countA++; });
  client.on(XMPPStanzaKind.message, (s) { countB++; });

  client.send(XMPPStanza(XMPPStanzaKind.message));

  import vibe.d : sleep;
  import core.time : msecs;
  sleep(50.msecs);

  assert(countA == 1);
  assert(countB == 1);
  
  // Test disconnect behavior
  assert(client.disconnect());
  assert(!client.connected());
  // Registration should fail when disconnected
  assert(!client.on(XMPPStanzaKind.presence, (s) {}));
}
