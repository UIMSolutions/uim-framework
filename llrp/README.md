# Library uim-llrp

Updated on 30. May 2026

uim-llrp is a lightweight D library to work with LLRP (Low Level Reader Protocol) workflows using vibe.d runtime patterns. It provides message encoding/decoding helpers, typed configuration, synchronous send orchestration, and asynchronous callback APIs.

## Features

- Typed LLRP contracts (`ILLRPService`)
- Configuration model for reader host, port, and client/session options
- Frame encoder/decoder helpers for simple LLRP message exchange modeling
- Synchronous APIs for encode, decode, and send
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real TCP/LLRP transport

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:llrp" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.llrp;

void main() {
  auto service = LLRPService();

  LLRPConfig cfg;
  cfg.host = "192.168.10.50";
  cfg.port = 5084;
  cfg.clientId = "uim-client";

  assert(service.configure(cfg));

  auto request = service.encodeMessage("GET_READER_CAPABILITIES", 101, "RequestedData=All");
  auto response = service.sendMessage(request);

  writeln(response.statusCode, " ", response.message);
  writeln(response.responseFrame);
}
```

## Modules

- `uim.llrp`: package entrypoint and re-exports
- `uim.llrp.interfaces`: contracts, enums, config, and DTO structs
- `uim.llrp.models`: result and empty-message helper constructors
- `uim.llrp.helpers`: frame parser and encoder helpers
- `uim.llrp.service`: encode/decode/send orchestration and async APIs

## Notes

- Default behavior uses an in-memory provider and does not perform real network transport.
- For production usage, inject transport logic via `setEncodeProvider`, `setDecodeProvider`, and `setSendProvider`.
