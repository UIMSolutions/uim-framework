/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.edifact.service;

import vibe.d : runTask;

import uim.edifact;

mixin(ShowModule!());

@safe:

class UIMEDIFACTService : UIMObject, IEDIFACTService {
  private EDIFACTConfig _config;
  private bool _configured;

  private EDIFACTParseDelegate _parseProvider;
  private EDIFACTSerializeDelegate _serializeProvider;
  private EDIFACTAckDelegate _ackProvider;

  bool configure(EDIFACTConfig config) {
    if (config.senderId.length == 0 || config.receiverId.length == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  EDIFACTConfig config() const {
    return _config;
  }

  bool setParseProvider(EDIFACTParseDelegate provider) {
    _parseProvider = provider;
    return true;
  }

  bool setSerializeProvider(EDIFACTSerializeDelegate provider) {
    _serializeProvider = provider;
    return true;
  }

  bool setAckProvider(EDIFACTAckDelegate provider) {
    _ackProvider = provider;
    return true;
  }

  EDIFACTMessage parseInterchange(string interchange) {
    if (!_configured || interchange.length == 0) {
      return EDIFACTMessageEmpty();
    }

    if (_parseProvider !is null) {
      try {
        return _parseProvider(_config, interchange);
      } catch (Exception) {
        return EDIFACTMessageEmpty();
      }
    }

    EDIFACTMessage message;
    message.messageType = "ORDERS";
    message.releaseCode = "D96A";
    message.controllingAgency = "UN";
    message.messageReference = "1";
    message.segments = parseSegments(interchange);

    foreach (segment; message.segments) {
      if (segment.tag == "UNH" && segment.elements.length >= 2) {
        message.messageReference = segment.elements[0];
      }

      if (segment.tag == "BGM" && segment.elements.length >= 2) {
        message.messageType = segment.elements[1];
      }
    }

    return message;
  }

  string serializeMessage(EDIFACTMessage message) {
    if (!_configured || message.segments.length == 0) {
      return "";
    }

    if (_serializeProvider !is null) {
      try {
        return _serializeProvider(_config, message);
      } catch (Exception) {
        return "";
      }
    }

    return edifactSerializeSegments(message.segments);
  }

  EDIFACTResult generateContrlAck(EDIFACTMessage message, bool accepted, string reason = "") {
    if (!_configured) {
      return EDIFACTResultErr(412, "EDIFACT service is not configured.");
    }

    if (_ackProvider !is null) {
      try {
        return _ackProvider(_config, message, accepted, reason);
      } catch (Exception ex) {
        return EDIFACTResultErr(500, ex.msg, _config.controlReference);
      }
    }

    if (accepted) {
      return EDIFACTResultOk(200, "CONTRL accepted", _config.controlReference);
    }

    return EDIFACTResultErr(422, "CONTRL rejected: " ~ reason, _config.controlReference);
  }

  bool parseInterchangeAsync(string interchange, EDIFACTMessageHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localInterchange = interchange;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(parseInterchange(localInterchange));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool serializeMessageAsync(EDIFACTMessage message, EDIFACTResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMessage = message;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          auto payload = serializeMessage(localMessage);
          if (payload.length > 0) {
            localHandler(EDIFACTResultOk(200, "serialized", _config.controlReference));
          } else {
            localHandler(EDIFACTResultErr(400, "serialization failed", _config.controlReference));
          }
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  EDIFACTSegment parseSegment(string line) {
    return edifactParseSegment(line);
  }

  EDIFACTSegment[] parseSegments(string interchange) {
    return edifactParseSegments(interchange);
  }
}

IEDIFACTService EDIFACTService() {
  return new UIMEDIFACTService();
}

unittest {
  auto service = EDIFACTService();

  EDIFACTConfig config;
  config.senderId = "SENDER01";
  config.receiverId = "RECEIVER01";
  config.controlReference = "CTRL-100";
  assert(service.configure(config));

  auto payload = "UNH+1+ORDERS:D:96A:UN'BGM+220+PO-100+9'";
  auto message = service.parseInterchange(payload);
  assert(message.segments.length == 2);

  auto encoded = service.serializeMessage(message);
  assert(encoded.length > 0);

  auto ack = service.generateContrlAck(message, true);
  assert(ack.success);
}
