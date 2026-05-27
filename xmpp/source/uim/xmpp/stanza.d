/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.stanza;

import std.datetime : Clock;
import std.format : format;

import uim.xmpp;

mixin(ShowModule!());

@safe:

class UIMXMPPStanza : UIMObject, IXMPPStanza {
  this(XMPPStanzaKind kind = XMPPStanzaKind.message) {
    super();
    _kind = kind;
    _id = format("xmpp-%s", Clock.currTime().toUnixTime());
  }

  private XMPPStanzaKind _kind;
  XMPPStanzaKind kind() const {
    return _kind;
  }

  IXMPPStanza kind(XMPPStanzaKind value) {
    _kind = value;
    return this;
  }

  private string _id;
  string id() const {
    return _id;
  }

  IXMPPStanza id(string value) {
    _id = value;
    return this;
  }

  private string _toJid;
  string toJid() const {
    return _toJid;
  }

  IXMPPStanza toJid(string value) {
    _toJid = xmppNormalizeJid(value);
    return this;
  }

  private string _fromJid;
  string fromJid() const {
    return _fromJid;
  }

  IXMPPStanza fromJid(string value) {
    _fromJid = xmppNormalizeJid(value);
    return this;
  }

  private string _stanzaType;
  string stanzaType() const {
    return _stanzaType;
  }

  IXMPPStanza stanzaType(string value) {
    _stanzaType = value;
    return this;
  }

  private string _body;
  string body() const {
    return _body;
  }

  IXMPPStanza body(string value) {
    _body = value;
    return this;
  }

  private string _payloadXml;
  string payloadXml() const {
    return _payloadXml;
  }

  IXMPPStanza payloadXml(string value) {
    _payloadXml = value;
    return this;
  }
}

IXMPPStanza XMPPStanza(XMPPStanzaKind kind = XMPPStanzaKind.message) {
  return new UIMXMPPStanza(kind);
}

unittest {
  auto stanza = XMPPStanza(XMPPStanzaKind.message)
    .toJid(" bob@example.org/mobile ")
    .fromJid("alice@example.org/desktop")
    .stanzaType("chat")
    .body("hello")
    .payloadXml("<extra xmlns='urn:test'>ok</extra>");

  assert(stanza.kind() == XMPPStanzaKind.message);
  assert(stanza.toJid() == "bob@example.org/mobile");
  assert(stanza.fromJid() == "alice@example.org/desktop");
  assert(stanza.stanzaType() == "chat");
  assert(stanza.body() == "hello");
}
