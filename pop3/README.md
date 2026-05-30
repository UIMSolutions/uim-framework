# Library uim-pop3

Updated on 30. May 2026

uim-pop3 is a lightweight D library to work with POP3 workflows using vibe.d runtime patterns. It provides mailbox status/list parsing, message retrieval and deletion orchestration, and asynchronous operations.

## Features

- Typed POP3 contracts (`IPOP3Service`)
- POP3 mailbox configuration model with security mode support
- POP3 command-response helper parsing for `STAT`, `LIST`, `UIDL`, `RETR`
- Synchronous mailbox operations (`stat`, `list`, `uidl`, `retr`, `dele`)
- Async callbacks via vibe.d `runTask`
- Optional operation provider delegates for integrating real POP3 transport later

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:pop3" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.pop3;

void main() {
  auto service = POP3Service();

  POP3Config cfg;
  cfg.host = "pop.example.org";
  cfg.port = 110;
  cfg.security = POP3Security.none;
  cfg.username = "mailbox";
  cfg.password = "secret";

  assert(service.configure(cfg));

  auto status = service.stat();
  writeln("messages=", status.messageCount, ", bytes=", status.mailboxSizeBytes);

  auto listing = service.list();
  foreach (entry; listing) {
    writeln("#", entry.number, " size=", entry.sizeBytes);
  }

  if (listing.length > 0) {
    auto message = service.retr(listing[0].number);
    writeln(message.headers);
  }

  service.statAsync((POP3Status asyncStatus) @safe {
    writeln("async success=", asyncStatus.success);
  });
}
```

## Modules

- `uim.pop3`: package entrypoint and re-exports
- `uim.pop3.interfaces`: POP3 contracts, enums, and DTO structs
- `uim.pop3.models`: status/message/result helper constructors
- `uim.pop3.helpers`: POP3 response parsing helpers
- `uim.pop3.service`: operation orchestration, parsing facade, and async methods

## Notes

- Default behavior uses in-memory providers, enabling integration without external POP3 infrastructure.
- For production mailbox access, inject real providers via `setStatProvider`, `setListProvider`, `setUidlProvider`, `setRetrProvider`, and `setDeleProvider`.
