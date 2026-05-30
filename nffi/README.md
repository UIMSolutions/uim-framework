# Library uim-nffi

Updated on 30. May 2026

uim-nffi is a lightweight D library to work with NFFI (NATO Friendly Force Information) workflows using vibe.d runtime patterns. It provides typed configuration, friendly-force track encoding/decoding helpers, publication/query orchestration, and asynchronous callbacks.

## Features

- Typed NFFI contracts (`INFFIService`)
- Configuration model for endpoint, nation code, force identity, and profile settings
- Track codec helpers for simple payload serialization and parsing
- Synchronous APIs for publish, query, and area synchronization
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real NFFI transport backends

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:nffi" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.nffi;

void main() {
  auto service = NFFIService();

  NFFIConfig cfg;
  cfg.endpoint = "https://nffi.example.mil/feed";
  cfg.nationCode = "DEU";
  cfg.forceId = "DEU-ARMY-0007";

  assert(service.configure(cfg));

  auto track = service.getTrack("DEU-ARMY-0007");
  writeln(track.unitId, " ", track.callsign);

  auto result = service.publishTrack(track);
  writeln(result.statusCode, " ", result.message);
}
```

## Modules

- `uim.nffi`: package entrypoint and re-exports
- `uim.nffi.interfaces`: contracts, enums, config, and DTO structs
- `uim.nffi.models`: result and empty-track helper constructors
- `uim.nffi.helpers`: payload encode/decode helper functions
- `uim.nffi.service`: publish/query/sync orchestration and async APIs

## Notes

- Default behavior uses in-memory providers to enable integration without external systems.
- For production usage, inject transport logic via `setPublishProvider`, `setGetProvider`, and `setSyncProvider`.
