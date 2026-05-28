/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.interfaces.stanza;

import uim.xmpp;

mixin(ShowModule!());

@safe:

enum XMPPStanzaKind : ubyte {
  message = 0,
  presence = 1,
  iq = 2
}

interface IXMPPStanza {
  XMPPStanzaKind kind() const;
  IXMPPStanza kind(XMPPStanzaKind value);

  string id() const;
  IXMPPStanza id(string value);

  string toJid() const;
  IXMPPStanza toJid(string value);

  string fromJid() const;
  IXMPPStanza fromJid(string value);

  string stanzaType() const;
  IXMPPStanza stanzaType(string value);

  string body() const;
  IXMPPStanza body(string value);

  string payloadXml() const;
  IXMPPStanza payloadXml(string value);
}
