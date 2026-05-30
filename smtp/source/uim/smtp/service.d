/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.smtp.service;

import std.array : appender;
import std.format : format;

import vibe.d : runTask;

import uim.smtp;

mixin(ShowModule!());

@safe:

class UIMSMTPService : UIMObject, ISMTPService {
  private SMTPServerConfig _config;
  private bool _configured;
  private SMTPTransportDelegate _transport;

  bool configure(SMTPServerConfig config) {
    if (config.host.length == 0 || config.port == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  SMTPServerConfig config() const {
    return _config;
  }

  bool setTransport(SMTPTransportDelegate transport) {
    _transport = transport;
    return true;
  }

  string compose(ISMTPMessage message) {
    if (message is null || !message.isValid()) {
      return "";
    }

    auto toValues = message.to();
    auto ccValues = message.cc();

    auto buffer = appender!string();
    buffer.put(format("From: %s\r\n", smtpFormatAddress(message.from())));
    buffer.put(format("To: %s\r\n", smtpJoinAddresses(toValues)));

    if (ccValues.length > 0) {
      buffer.put(format("Cc: %s\r\n", smtpJoinAddresses(ccValues)));
    }

    if (message.replyTo().length > 0) {
      buffer.put(format("Reply-To: %s\r\n", message.replyTo()));
    }

    buffer.put(format("Subject: %s\r\n", message.subject()));
    buffer.put("MIME-Version: 1.0\r\n");

    auto hasText = message.textBody().length > 0;
    auto hasHtml = message.htmlBody().length > 0;

    if (hasText && hasHtml) {
      auto boundary = smtpGenerateBoundary();
      buffer.put(format("Content-Type: multipart/alternative; boundary=\"%s\"\r\n", boundary));
      buffer.put("\r\n");
      buffer.put(format("--%s\r\n", boundary));
      buffer.put("Content-Type: text/plain; charset=UTF-8\r\n\r\n");
      buffer.put(smtpNormalizeTextBody(message.textBody()));
      buffer.put("\r\n");
      buffer.put(format("--%s\r\n", boundary));
      buffer.put("Content-Type: text/html; charset=UTF-8\r\n\r\n");
      buffer.put(smtpNormalizeTextBody(message.htmlBody()));
      buffer.put("\r\n");
      buffer.put(format("--%s--\r\n", boundary));
    } else if (hasHtml) {
      buffer.put("Content-Type: text/html; charset=UTF-8\r\n\r\n");
      buffer.put(smtpNormalizeTextBody(message.htmlBody()));
      buffer.put("\r\n");
    } else {
      buffer.put("Content-Type: text/plain; charset=UTF-8\r\n\r\n");
      buffer.put(smtpNormalizeTextBody(message.textBody()));
      buffer.put("\r\n");
    }

    return buffer.data;
  }

  SMTPResponse parseResponseLine(string line) {
    return smtpParseResponseLine(line);
  }

  SMTPResult send(ISMTPMessage message) {
    SMTPResult result;

    if (!_configured) {
      result.success = false;
      result.code = 421;
      result.message = "SMTP service is not configured.";
      return result;
    }

    if (message is null || !message.isValid()) {
      result.success = false;
      result.code = 550;
      result.message = "SMTP message is invalid.";
      return result;
    }

    if (!smtpIsValidEmail(message.from().email)) {
      result.success = false;
      result.code = 553;
      result.message = "Sender address is not a valid SMTP address.";
      return result;
    }

    foreach (recipient; message.to()) {
      if (!smtpIsValidEmail(recipient.email)) {
        result.success = false;
        result.code = 553;
        result.message = "At least one recipient address is invalid.";
        return result;
      }
    }

    auto payload = compose(message);
    if (payload.length == 0) {
      result.success = false;
      result.code = 554;
      result.message = "Unable to compose SMTP payload.";
      return result;
    }

    if (_transport !is null) {
      try {
        return _transport(_config, payload);
      } catch (Exception ex) {
        result.success = false;
        result.code = 451;
        result.message = ex.msg;
        return result;
      }
    }

    result.success = true;
    result.code = 250;
    result.message = "Message accepted for delivery (in-memory transport).";
    result.transactionId = smtpMakeTransactionId();
    return result;
  }

  bool sendAsync(ISMTPMessage message, SMTPResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localMessage = message;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(send(localMessage));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

ISMTPService SMTPService() {
  return new UIMSMTPService();
}

unittest {
  auto service = SMTPService();

  SMTPServerConfig config;
  config.host = "smtp.example.org";
  config.port = 587;
  config.security = SMTPSecurity.startTLS;
  assert(service.configure(config));

  auto message = SMTPMessage()
    .from(SMTPAddress("sender@example.org", "Sender"))
    .addTo(SMTPAddress("receiver@example.org", "Receiver"))
    .subject("Status")
    .textBody("Everything is green.");

  auto payload = service.compose(message);
  assert(payload.length > 0);

  auto result = service.send(message);
  assert(result.success);
  assert(result.code == 250);
}
