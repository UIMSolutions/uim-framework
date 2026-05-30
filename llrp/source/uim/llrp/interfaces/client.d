/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.llrp.interfaces.client;

@safe:

enum LLRPVersion : ubyte {
  v10_1 = 0,
  v11 = 1
}

struct LLRPConfig {
  string host;
  ushort port = 5084;
  string readerName;
  string clientId;
  LLRPVersion llrpVersion = LLRPVersion.v11;
  uint keepaliveMs = 5_000;
  uint timeoutMs = 10_000;
  bool strictMode;
}

struct LLRPMessage {
  string messageType;
  uint messageId;
  string payload;
  string encodedFrame;
}

struct LLRPResult {
  bool success;
  ushort statusCode;
  string message;
  string responseFrame;
}

alias LLRPMessageHandler = void delegate(LLRPMessage message) @safe;
alias LLRPResultHandler = void delegate(LLRPResult result) @safe;

alias LLRPEncodeDelegate = LLRPMessage delegate(
  LLRPConfig config,
  string messageType,
  uint messageId,
  string payload
) @safe;

alias LLRPDecodeDelegate = LLRPMessage delegate(
  LLRPConfig config,
  string frame
) @safe;

alias LLRPSendDelegate = LLRPResult delegate(
  LLRPConfig config,
  LLRPMessage message
) @safe;

interface ILLRPService {
  bool configure(LLRPConfig config);
  LLRPConfig config() const;

  bool setEncodeProvider(LLRPEncodeDelegate provider);
  bool setDecodeProvider(LLRPDecodeDelegate provider);
  bool setSendProvider(LLRPSendDelegate provider);

  LLRPMessage encodeMessage(string messageType, uint messageId, string payload);
  LLRPMessage decodeFrame(string frame);
  LLRPResult sendMessage(LLRPMessage message);

  bool decodeFrameAsync(string frame, LLRPMessageHandler handler);
  bool sendMessageAsync(LLRPMessage message, LLRPResultHandler handler);
}
