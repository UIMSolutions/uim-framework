/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.transport.xml_codec;

import std.string : startsWith;

import uim.xmpp;

mixin(ShowModule!());

@safe:

string xmppEncodeStanza(IXMPPStanza stanza) {
  if (stanza is null) {
    return "";
  }

  auto tag = stanzaTag(stanza.kind());
  auto xml = "<" ~ tag;

  if (stanza.id().length > 0) {
    xml ~= " id='" ~ xmppEscapeXml(stanza.id()) ~ "'";
  }
  if (stanza.toJid().length > 0) {
    xml ~= " to='" ~ xmppEscapeXml(stanza.toJid()) ~ "'";
  }
  if (stanza.fromJid().length > 0) {
    xml ~= " from='" ~ xmppEscapeXml(stanza.fromJid()) ~ "'";
  }
  if (stanza.stanzaType().length > 0) {
    xml ~= " type='" ~ xmppEscapeXml(stanza.stanzaType()) ~ "'";
  }

  const body = stanza.body();
  const payload = stanza.payloadXml();
  if (body.length == 0 && payload.length == 0) {
    return xml ~ "/>";
  }

  xml ~= ">";
  if (body.length > 0) {
    xml ~= "<body>" ~ xmppEscapeXml(body) ~ "</body>";
  }
  if (payload.length > 0) {
    xml ~= payload;
  }
  xml ~= "</" ~ tag ~ ">";
  return xml;
}

bool xmppTryDecodeStanza(string xml, out IXMPPStanza stanza) {
  stanza = null;
  auto trimmed = xmppNormalizeJid(xml);
  if (trimmed.length == 0 || !trimmed.startsWith("<")) {
    return false;
  }

  auto kind = parseKind(trimmed);
  if (kind == XMPPStanzaKind.message && !trimmed.startsWith("<message")) {
    if (trimmed.startsWith("<presence")) {
      kind = XMPPStanzaKind.presence;
    } else if (trimmed.startsWith("<iq")) {
      kind = XMPPStanzaKind.iq;
    } else {
      return false;
    }
  }

  auto decoded = XMPPStanza(kind);
  decoded.id(attributeValue(trimmed, "id"));
  decoded.toJid(attributeValue(trimmed, "to"));
  decoded.fromJid(attributeValue(trimmed, "from"));
  decoded.stanzaType(attributeValue(trimmed, "type"));
  decoded.body(tagValue(trimmed, "body"));

  stanza = decoded;
  return true;
}

string xmppEscapeXml(string value) {
  string outValue;
  outValue.reserve(value.length + 8);

  foreach (ch; value) {
    switch (ch) {
      case '&': outValue ~= "&amp;"; break;
      case '<': outValue ~= "&lt;"; break;
      case '>': outValue ~= "&gt;"; break;
      case '\"': outValue ~= "&quot;"; break;
      case '\'': outValue ~= "&apos;"; break;
      default: outValue ~= ch; break;
    }
  }

  return outValue;
}

private string stanzaTag(XMPPStanzaKind kind) {
  final switch (kind) {
    case XMPPStanzaKind.message: return "message";
    case XMPPStanzaKind.presence: return "presence";
    case XMPPStanzaKind.iq: return "iq";
  }
}

private XMPPStanzaKind parseKind(string xml) {
  if (xml.startsWith("<presence")) {
    return XMPPStanzaKind.presence;
  }
  if (xml.startsWith("<iq")) {
    return XMPPStanzaKind.iq;
  }
  return XMPPStanzaKind.message;
}

private string attributeValue(string xml, string attributeName) {
  auto needle = attributeName ~ "='";
  auto start = indexOf(xml, needle);
  if (start < 0) {
    needle = attributeName ~ "=\"";
    start = indexOf(xml, needle);
    if (start < 0) {
      return "";
    }
  }

  auto from = cast(size_t) (start + cast(int) needle.length);
  if (from >= xml.length) {
    return "";
  }

  auto quote = xml[from - 1];
  auto end = indexOf(xml[from .. $], quote);
  if (end < 0) {
    return "";
  }

  return xml[from .. from + cast(size_t) end].idup;
}

private string tagValue(string xml, string tagName) {
  auto open = "<" ~ tagName ~ ">";
  auto close = "</" ~ tagName ~ ">";

  auto start = indexOf(xml, open);
  if (start < 0) {
    return "";
  }

  auto from = cast(size_t) (start + cast(int) open.length);
  auto end = indexOf(xml[from .. $], close);
  if (end < 0) {
    return "";
  }

  return xml[from .. from + cast(size_t) end].idup;
}

private int indexOf(string haystack, string needle) {
  if (needle.length == 0 || haystack.length < needle.length) {
    return -1;
  }

  foreach (i; 0 .. haystack.length - needle.length + 1) {
    if (haystack[i .. i + needle.length] == needle) {
      return cast(int) i;
    }
  }

  return -1;
}

private int indexOf(string haystack, dchar needle) {
  foreach (i, ch; haystack) {
    if (ch == needle) {
      return cast(int) i;
    }
  }
  return -1;
}

unittest {
  auto stanza = XMPPStanza(XMPPStanzaKind.message)
    .id("m-1")
    .toJid("bob@example.org")
    .fromJid("alice@example.org")
    .stanzaType("chat")
    .body("hello <xmpp>");

  auto xml = xmppEncodeStanza(stanza);
  assert(xml.startsWith("<message"));
  assert(indexOf(xml, "&lt;xmpp&gt;") >= 0);
}

unittest {
  IXMPPStanza decoded;
  assert(
    xmppTryDecodeStanza(
      "<message id='m-2' to='bob@example.org' from='alice@example.org' type='chat'><body>hi</body></message>",
      decoded
    )
  );
  assert(decoded !is null);
  assert(decoded.kind() == XMPPStanzaKind.message);
  assert(decoded.id() == "m-2");
  assert(decoded.body() == "hi");
}

unittest {
  auto presence = XMPPStanza(XMPPStanzaKind.presence)
    .fromJid("alice@example.org")
    .stanzaType("unavailable");
  auto xml = xmppEncodeStanza(presence);
  assert(indexOf(xml, "from='alice@example.org'") >= 0);
  assert(indexOf(xml, "type='unavailable'") >= 0);
  assert(indexOf(xml, "<presence") == 0);

  IXMPPStanza decoded;
  assert(xmppTryDecodeStanza("<presence from='bob@example.com' type='subscribe'/>", decoded));
  assert(decoded.kind() == XMPPStanzaKind.presence);
  assert(decoded.fromJid() == "bob@example.com");
  assert(decoded.stanzaType() == "subscribe");
  
  assert(xmppEscapeXml("< > & \" '") == "&lt; &gt; &amp; &quot; &apos;");
}

unittest {
  // Test IQ encoding without payload
  auto iq = XMPPStanza(XMPPStanzaKind.iq).id("req-1").stanzaType("get");
  auto xml = xmppEncodeStanza(iq);
  assert(xml == "<iq id='req-1' type='get'/>");

  // Test malformed decoding
  IXMPPStanza decoded;
  assert(!xmppTryDecodeStanza("", decoded));
  assert(!xmppTryDecodeStanza("not xml", decoded));
  assert(!xmppTryDecodeStanza("<unknown/>", decoded));

  // Test encoding null
  assert(xmppEncodeStanza(null) == "");

  // Test presence without type
  assert(xmppTryDecodeStanza("<presence from='alice@example.com'/>", decoded));
  assert(decoded.kind() == XMPPStanzaKind.presence);
  assert(decoded.fromJid() == "alice@example.com");

  // Test double quotes in attributes
  assert(
    xmppTryDecodeStanza(
      "<message to=\"bob@example.com\" type=\"chat\"><body>Hi</body></message>",
      decoded
    )
  );
  assert(decoded.toJid() == "bob@example.com");
  assert(decoded.stanzaType() == "chat");
}
