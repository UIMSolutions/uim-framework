# Library uim-edifact

Updated on 30. May 2026

uim-edifact is a lightweight D library to work with EDIFACT workflows using vibe.d runtime patterns. It provides interchange parsing, segment serialization, CONTRL acknowledgment generation, and asynchronous processing helpers.

## Features

- Typed EDIFACT contracts (`IEDIFACTService`)
- Config model for sender/receiver and control reference handling
- Segment parser and serializer for common `'` and `+` delimiters
- Synchronous APIs for parse, serialize, and CONTRL acknowledgment workflows
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating external EDIFACT engines

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:edifact" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.edifact;

void main() {
  auto service = EDIFACTService();

  EDIFACTConfig cfg;
  cfg.senderId = "SENDER01";
  cfg.receiverId = "RECEIVER01";
  cfg.controlReference = "CTRL-100";

  assert(service.configure(cfg));

  auto interchange = "UNH+1+ORDERS:D:96A:UN'BGM+220+PO-100+9'";
  auto message = service.parseInterchange(interchange);
  writeln("segments=", message.segments.length);

  auto serialized = service.serializeMessage(message);
  writeln(serialized);

  auto ack = service.generateContrlAck(message, true);
  writeln(ack.statusCode, " ", ack.message);
}
```

## Modules

- `uim.edifact`: package entrypoint and re-exports
- `uim.edifact.interfaces`: contracts, enums, and EDIFACT DTO structs
- `uim.edifact.models`: result/message helper constructors
- `uim.edifact.helpers`: EDIFACT segment parser and serializer helpers
- `uim.edifact.service`: parse/serialize/ack orchestration and async APIs

## Notes

- Default behavior uses in-memory parsing/ack logic and does not perform transport.
- For production integrations, inject provider delegates via `setParseProvider`, `setSerializeProvider`, and `setAckProvider`.
