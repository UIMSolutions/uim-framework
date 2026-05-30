/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.soap.helpers.codec;

import std.array : appender;
import std.string : indexOf, strip;

import uim.soap.interfaces;

@safe:

string soapVersionNamespace(SOAPVersion soapVersion) {
  return soapVersion == SOAPVersion.soap11
    ? "http://schemas.xmlsoap.org/soap/envelope/"
    : "http://www.w3.org/2003/05/soap-envelope";
}

SOAPEnvelope soapBuildEnvelope(
  SOAPVersion soapVersion,
  string operation,
  string bodyXml,
  const(SOAPHeader)[] headers = null
) {
  SOAPEnvelope envelope;

  auto ns = soapVersionNamespace(soapVersion);
  auto buffer = appender!string();
  buffer.put("<soap:Envelope xmlns:soap=\"");
  buffer.put(ns);
  buffer.put("\">\n");

  if (headers.length > 0) {
    buffer.put("  <soap:Header>\n");
    foreach (header; headers) {
      buffer.put("    <");
      buffer.put(header.name);
      buffer.put(">");
      buffer.put(header.value);
      buffer.put("</");
      buffer.put(header.name);
      buffer.put(">\n");
    }
    buffer.put("  </soap:Header>\n");
  }

  buffer.put("  <soap:Body>\n");
  if (operation.length > 0) {
    buffer.put("    <");
    buffer.put(operation);
    buffer.put(">");
    buffer.put(bodyXml);
    buffer.put("</");
    buffer.put(operation);
    buffer.put(">\n");
  } else {
    buffer.put("    ");
    buffer.put(bodyXml);
    buffer.put("\n");
  }
  buffer.put("  </soap:Body>\n");
  buffer.put("</soap:Envelope>");

  envelope.operation = operation;
  envelope.bodyXml = bodyXml;
  envelope.headers = headers.dup;
  envelope.rawXml = buffer.data;
  return envelope;
}

SOAPEnvelope soapParseEnvelope(string xmlPayload) {
  SOAPEnvelope envelope;

  auto trimmed = xmlPayload.strip();
  if (trimmed.length == 0) {
    return envelope;
  }

  envelope.rawXml = trimmed;

  auto bodyStartTag = "<soap:Body>";
  auto bodyEndTag = "</soap:Body>";

  auto bodyStart = trimmed.indexOf(bodyStartTag);
  auto bodyEnd = trimmed.indexOf(bodyEndTag);

  if (bodyStart < 0 || bodyEnd < 0 || bodyEnd <= bodyStart) {
    envelope.bodyXml = trimmed;
    return envelope;
  }

  auto contentStart = cast(size_t) bodyStart + bodyStartTag.length;
  auto contentEnd = cast(size_t) bodyEnd;
  envelope.bodyXml = trimmed[contentStart .. contentEnd].strip();

  auto opOpen = envelope.bodyXml.indexOf("<");
  if (opOpen >= 0) {
    auto opClose = envelope.bodyXml.indexOf(">", opOpen + 1);
    if (opClose > opOpen + 1) {
      auto tag = envelope.bodyXml[cast(size_t) opOpen + 1 .. cast(size_t) opClose];
      auto spacePos = tag.indexOf(" ");
      envelope.operation = (spacePos > 0 ? tag[0 .. cast(size_t) spacePos] : tag);
    }
  }

  return envelope;
}

unittest {
  SOAPHeader[] headers;
  headers ~= SOAPHeader("AuthToken", "abc123");

  auto envelope = soapBuildEnvelope(
    SOAPVersion.soap12,
    "GetCustomer",
    "<id>42</id>",
    headers
  );

  assert(envelope.rawXml.length > 0);
  assert(envelope.operation == "GetCustomer");

  auto parsed = soapParseEnvelope(envelope.rawXml);
  assert(parsed.bodyXml.length > 0);
}
