/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.edifact.interfaces.client;

@safe:

enum EDIFACTSyntax : ubyte {
  unoa = 0,
  unob = 1,
  unoc = 2
}

struct EDIFACTConfig {
  string senderId;
  string receiverId;
  EDIFACTSyntax syntax = EDIFACTSyntax.unoc;
  string controlReference = "000000001";
  bool strictMode;
}

struct EDIFACTSegment {
  string tag;
  string[] elements;
}

struct EDIFACTMessage {
  string messageType;
  string releaseCode;
  string controllingAgency;
  string messageReference;
  EDIFACTSegment[] segments;
}

struct EDIFACTResult {
  bool success;
  ushort statusCode;
  string message;
  string controlReference;
}

alias EDIFACTMessageHandler = void delegate(EDIFACTMessage message) @safe;
alias EDIFACTResultHandler = void delegate(EDIFACTResult result) @safe;
alias EDIFACTSegmentsHandler = void delegate(EDIFACTSegment[] segments) @safe;

alias EDIFACTParseDelegate = EDIFACTMessage delegate(
  EDIFACTConfig config,
  string interchange
) @safe;

alias EDIFACTSerializeDelegate = string delegate(
  EDIFACTConfig config,
  EDIFACTMessage message
) @safe;

alias EDIFACTAckDelegate = EDIFACTResult delegate(
  EDIFACTConfig config,
  EDIFACTMessage message,
  bool accepted,
  string reason
) @safe;

interface IEDIFACTService {
  bool configure(EDIFACTConfig config);
  EDIFACTConfig config() const;

  bool setParseProvider(EDIFACTParseDelegate provider);
  bool setSerializeProvider(EDIFACTSerializeDelegate provider);
  bool setAckProvider(EDIFACTAckDelegate provider);

  EDIFACTMessage parseInterchange(string interchange);
  string serializeMessage(EDIFACTMessage message);
  EDIFACTResult generateContrlAck(EDIFACTMessage message, bool accepted, string reason = "");

  bool parseInterchangeAsync(string interchange, EDIFACTMessageHandler handler);
  bool serializeMessageAsync(EDIFACTMessage message, EDIFACTResultHandler handler);

  EDIFACTSegment parseSegment(string line);
  EDIFACTSegment[] parseSegments(string interchange);
}
