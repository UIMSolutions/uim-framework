/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.llrp.service;

import std.conv : to;

import vibe.d : runTask;

import uim.llrp;

mixin(ShowModule!());

@safe:

class UIMLLRPService : UIMObject, ILLRPService {
  private LLRPConfig _config;
  private bool _configured;

  private LLRPEncodeDelegate _encodeProvider;
  private LLRPDecodeDelegate _decodeProvider;
  private LLRPSendDelegate _sendProvider;

  bool configure(LLRPConfig config) {
    if (config.host.length == 0 || config.port == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  LLRPConfig config() const {
    return _config;
  }

  bool setEncodeProvider(LLRPEncodeDelegate provider) {
    _encodeProvider = provider;
    return true;
  }

  bool setDecodeProvider(LLRPDecodeDelegate provider) {
    _decodeProvider = provider;
    return true;
  }

  bool setSendProvider(LLRPSendDelegate provider) {
    _sendProvider = provider;
    return true;
  }

  LLRPMessage encodeMessage(string messageType, uint messageId, string payload) {
    if (!_configured || messageType.length == 0) {
      return LLRPMessageEmpty();
    }

    if (_encodeProvider !is null) {
      try {
        return _encodeProvider(_config, messageType, messageId, payload);
      } catch (Exception) {
        return LLRPMessageEmpty();
      }
    }

    return llrpEncodeMessage(messageType, messageId, payload);
  }

  LLRPMessage decodeFrame(string frame) {
    if (!_configured || frame.length == 0) {
      return LLRPMessageEmpty();
    }

    if (_decodeProvider !is null) {
      try {
        return _decodeProvider(_config, frame);
      } catch (Exception) {
        return LLRPMessageEmpty();
      }
    }

    return llrpDecodeFrame(frame);
  }

  LLRPResult sendMessage(LLRPMessage message) {
    if (!_configured) {
      return LLRPResultErr(412, "LLRP service is not configured.");
    }

    if (message.encodedFrame.length == 0 && message.messageType.length == 0) {
      return LLRPResultErr(400, "LLRP message is empty.");
    }

    if (_sendProvider !is null) {
      try {
        return _sendProvider(_config, message);
      } catch (Exception ex) {
        return LLRPResultErr(500, ex.msg);
      }
    }

    auto frame = message.encodedFrame.length > 0
      ? message.encodedFrame
      : "TYPE=" ~ message.messageType ~ "|ID=" ~ to!string(message.messageId) ~ "|PAYLOAD=" ~ message.payload;

    auto ack = "TYPE=KEEPALIVE_ACK|ID=" ~ to!string(message.messageId) ~ "|PAYLOAD=accepted";
    return LLRPResultOk(200, "LLRP frame accepted by in-memory provider", frame ~ "\n" ~ ack);
  }

  bool decodeFrameAsync(string frame, LLRPMessageHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localFrame = frame;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(decodeFrame(localFrame));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool sendMessageAsync(LLRPMessage message, LLRPResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMessage = message;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(sendMessage(localMessage));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

ILLRPService LLRPService() {
  return new UIMLLRPService();
}

unittest {
  auto service = LLRPService();

  LLRPConfig config;
  config.host = "192.168.10.50";
  config.port = 5084;
  config.clientId = "uim-client";
  assert(service.configure(config));

  auto message = service.encodeMessage("GET_READER_CAPABILITIES", 101, "RequestedData=All");
  assert(message.encodedFrame.length > 0);

  auto decoded = service.decodeFrame(message.encodedFrame);
  assert(decoded.messageId == 101);

  auto result = service.sendMessage(message);
  assert(result.success);
}
