# Library uim-smtp

Updated on 30. May 2026

uim-smtp is a lightweight D library to work with SMTP workflows using vibe.d runtime patterns. It offers message modeling, MIME composition, SMTP response parsing, and synchronous/asynchronous send orchestration.

## Features

- Typed SMTP contracts (`ISMTPService`, `ISMTPMessage`)
- SMTP server configuration model with security/auth modes
- Header and body composition for plain text or multipart (text + HTML)
- SMTP response line parsing (e.g. `250 Ok`, `250-PIPELINING`)
- Async send callbacks via vibe.d `runTask`
- Optional transport delegate for integrating real socket/TLS delivery later

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:smtp" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.smtp;

void main() {
  auto service = SMTPService();

  SMTPServerConfig cfg;
  cfg.host = "smtp.example.org";
  cfg.port = 587;
  cfg.security = SMTPSecurity.startTLS;
  cfg.authMode = SMTPAuthMode.login;
  cfg.username = "mailer";
  cfg.password = "secret";

  assert(service.configure(cfg));

  auto message = SMTPMessage()
    .from(SMTPAddress("noreply@example.org", "UIM Notifier"))
    .addTo(SMTPAddress("user@example.org", "User"))
    .subject("Welcome")
    .textBody("Welcome to UIM.")
    .htmlBody("<h1>Welcome to UIM.</h1>");

  auto result = service.send(message);
  writeln(result.code, " ", result.message);

  service.sendAsync(message, (SMTPResult asyncResult) @safe {
    writeln("async=", asyncResult.success);
  });
}
```

## Modules

- `uim.smtp`: package entrypoint and re-exports
- `uim.smtp.interfaces`: SMTP contracts, enums, and DTO structs
- `uim.smtp.models`: concrete SMTP message model implementation
- `uim.smtp.helpers`: codec helpers for address formatting, body normalization, and response parsing
- `uim.smtp.service`: compose, parse, send, and async orchestration

## Notes

- Default send behavior uses an in-memory transport result (`250`) so integration can start without SMTP infrastructure.
- For production delivery, inject a transport implementation via `setTransport`.
- `Bcc` recipients are excluded from message headers by design.
