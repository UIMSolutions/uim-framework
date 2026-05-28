/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.interfaces.client;

import uim.xmpp;

mixin(ShowModule!());

@safe:

alias XMPPStanzaHandler = void delegate(IXMPPStanza stanza) @safe;

interface IXMPPClient {
  bool connect(string serverUrl, string jid = "", string password = "");
  bool disconnect();

  bool send(IXMPPStanza stanza);
  bool on(XMPPStanzaKind kind, XMPPStanzaHandler handler);

  bool connected() const;
  string jid() const;
  string serverUrl() const;
}
