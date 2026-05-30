/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.soap.interfaces.client;

@safe:

enum SOAPVersion : ubyte {
  soap11 = 0,
  soap12 = 1
}

struct SOAPConfig {
  string endpoint;
  string soapAction;
  SOAPVersion soapVersion = SOAPVersion.soap12;
  string namespaceUri;
  bool strictMode;
  uint timeoutMs = 10_000;
}

struct SOAPHeader {
  string name;
  string value;
}

struct SOAPEnvelope {
  string operation;
  SOAPHeader[] headers;
  string bodyXml;
  string rawXml;
}

struct SOAPResult {
  bool success;
  ushort statusCode;
  string message;
  string payload;
}

alias SOAPEnvelopeHandler = void delegate(SOAPEnvelope envelope) @safe;
alias SOAPResultHandler = void delegate(SOAPResult result) @safe;

alias SOAPBuildDelegate = SOAPEnvelope delegate(
  SOAPConfig config,
  string operation,
  string bodyXml,
  const(SOAPHeader)[] headers
) @safe;

alias SOAPParseDelegate = SOAPEnvelope delegate(
  SOAPConfig config,
  string xmlPayload
) @safe;

alias SOAPSendDelegate = SOAPResult delegate(
  SOAPConfig config,
  SOAPEnvelope envelope
) @safe;

interface ISOAPService {
  bool configure(SOAPConfig config);
  SOAPConfig config() const;

  bool setBuildProvider(SOAPBuildDelegate provider);
  bool setParseProvider(SOAPParseDelegate provider);
  bool setSendProvider(SOAPSendDelegate provider);

  SOAPEnvelope buildEnvelope(string operation, string bodyXml, const(SOAPHeader)[] headers = null);
  SOAPEnvelope parseEnvelope(string xmlPayload);
  SOAPResult call(SOAPEnvelope envelope);

  bool parseEnvelopeAsync(string xmlPayload, SOAPEnvelopeHandler handler);
  bool callAsync(SOAPEnvelope envelope, SOAPResultHandler handler);
}
