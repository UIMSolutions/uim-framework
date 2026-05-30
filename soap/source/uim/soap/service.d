/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.soap.service;

import vibe.d : runTask;

import uim.soap;

mixin(ShowModule!());

@safe:

class UIMSOAPService : UIMObject, ISOAPService {
  private SOAPConfig _config;
  private bool _configured;

  private SOAPBuildDelegate _buildProvider;
  private SOAPParseDelegate _parseProvider;
  private SOAPSendDelegate _sendProvider;

  bool configure(SOAPConfig config) {
    if (config.endpoint.length == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  SOAPConfig config() const {
    return _config;
  }

  bool setBuildProvider(SOAPBuildDelegate provider) {
    _buildProvider = provider;
    return true;
  }

  bool setParseProvider(SOAPParseDelegate provider) {
    _parseProvider = provider;
    return true;
  }

  bool setSendProvider(SOAPSendDelegate provider) {
    _sendProvider = provider;
    return true;
  }

  SOAPEnvelope buildEnvelope(string operation, string bodyXml, const(SOAPHeader)[] headers = null) {
    if (!_configured || bodyXml.length == 0) {
      return SOAPEnvelopeEmpty();
    }

    if (_buildProvider !is null) {
      try {
        return _buildProvider(_config, operation, bodyXml, headers);
      } catch (Exception) {
        return SOAPEnvelopeEmpty();
      }
    }

    return soapBuildEnvelope(_config.soapVersion, operation, bodyXml, headers);
  }

  SOAPEnvelope parseEnvelope(string xmlPayload) {
    if (!_configured || xmlPayload.length == 0) {
      return SOAPEnvelopeEmpty();
    }

    if (_parseProvider !is null) {
      try {
        return _parseProvider(_config, xmlPayload);
      } catch (Exception) {
        return SOAPEnvelopeEmpty();
      }
    }

    return soapParseEnvelope(xmlPayload);
  }

  SOAPResult call(SOAPEnvelope envelope) {
    if (!_configured) {
      return SOAPResultErr(412, "SOAP service is not configured.");
    }

    if (envelope.rawXml.length == 0 && envelope.bodyXml.length == 0) {
      return SOAPResultErr(400, "SOAP envelope is empty.");
    }

    if (_sendProvider !is null) {
      try {
        return _sendProvider(_config, envelope);
      } catch (Exception ex) {
        return SOAPResultErr(500, ex.msg);
      }
    }

    auto payload = envelope.rawXml.length > 0 ? envelope.rawXml : envelope.bodyXml;
    return SOAPResultOk(200, "SOAP call accepted by in-memory provider", payload);
  }

  bool parseEnvelopeAsync(string xmlPayload, SOAPEnvelopeHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localXmlPayload = xmlPayload;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(parseEnvelope(localXmlPayload));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool callAsync(SOAPEnvelope envelope, SOAPResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localEnvelope = envelope;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(call(localEnvelope));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

ISOAPService SOAPService() {
  return new UIMSOAPService();
}

unittest {
  auto service = SOAPService();

  SOAPConfig config;
  config.endpoint = "https://example.org/soap";
  config.soapAction = "urn:GetCustomer";
  assert(service.configure(config));

  SOAPHeader[] headers;
  headers ~= SOAPHeader("AuthToken", "token-1");

  auto envelope = service.buildEnvelope("GetCustomer", "<id>42</id>", headers);
  assert(envelope.rawXml.length > 0);

  auto parsed = service.parseEnvelope(envelope.rawXml);
  assert(parsed.bodyXml.length > 0);

  auto result = service.call(envelope);
  assert(result.success);
}
