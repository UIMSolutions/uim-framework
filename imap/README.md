# Library uim-imap

Updated on 30. May 2026

uim-imap is a lightweight D library to work with IMAP workflows using vibe.d runtime patterns. It offers mailbox listing and selection, message search and fetch operations, deletion orchestration, and asynchronous execution helpers.

## Features

- Typed IMAP contracts (`IIMAPService`)
- IMAP configuration model with security mode support
- Response helpers for `LIST`, `SEARCH`, and `FETCH` payload parsing
- Synchronous APIs for mailbox and message operations
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real IMAP transport later

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:imap" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.imap;

void main() {
  auto service = IMAPService();

  IMAPConfig cfg;
  cfg.host = "imap.example.org";
  cfg.port = 143;
  cfg.security = IMAPSecurity.startTLS;
  cfg.username = "mailbox";
  cfg.password = "secret";

  assert(service.configure(cfg));

  foreach (mailbox; service.listMailboxes()) {
    writeln(mailbox.name, " total=", mailbox.messages, " unseen=", mailbox.unseen);
  }

  auto ids = service.search("INBOX", "UNSEEN");
  if (ids.length > 0) {
    auto message = service.fetch("INBOX", ids[0]);
    writeln(message.headers);
  }

  service.selectMailboxAsync("INBOX", (IMAPMailboxInfo info) @safe {
    writeln("async selected=", info.name);
  });
}
```

## Modules

- `uim.imap`: package entrypoint and re-exports
- `uim.imap.interfaces`: IMAP contracts, enums, and DTO structs
- `uim.imap.models`: mailbox/message/result helper constructors
- `uim.imap.helpers`: IMAP response parsing helpers
- `uim.imap.service`: operation orchestration, parsing facade, and async methods

## Notes

- Default behavior uses in-memory providers to allow immediate integration without an IMAP server.
- For production mailbox access, inject real providers via `setListMailboxesProvider`, `setSelectMailboxProvider`, `setSearchProvider`, `setFetchProvider`, and `setDeleteProvider`.
