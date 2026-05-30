# Library uim-soap

Updated on 30. May 2026

uim-soap is a lightweight D library to work with SOAP workflows using vibe.d runtime patterns. It provides envelope construction/parsing, typed configuration, synchronous call orchestration, and asynchronous callback helpers.

## Features

- Typed SOAP contracts (`ISOAPService`)
- Configuration model for endpoint, SOAP version, and action
- SOAP envelope builder/parser helpers
- Synchronous APIs for build, parse, and call
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating HTTP/SOAP backends

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:soap" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.soap;

void main() {
  auto service = SOAPService();

  SOAPConfig cfg;
  cfg.endpoint = "https://example.org/soap";
  cfg.soapAction = "urn:GetCustomer";
  cfg.soapVersion = SOAPVersion.soap12;

  assert(service.configure(cfg));

  SOAPHeader[] headers;
  headers ~= SOAPHeader("AuthToken", "abc123");

  auto envelope = service.buildEnvelope("GetCustomer", "<id>42</id>", headers);
  auto result = service.call(envelope);

  writeln(result.statusCode, " ", result.message);
  writeln(result.payload);
}
```

## Modules

- `uim.soap`: package entrypoint and re-exports
- `uim.soap.interfaces`: contracts, enums, config, and DTO structs
- `uim.soap.models`: result and empty-envelope helper constructors
- `uim.soap.helpers`: SOAP envelope parser and builder helpers
- `uim.soap.service`: SOAP build/parse/call orchestration and async APIs

## Notes

- Default behavior uses an in-memory call provider and does not perform network transport.
- For production usage, inject transport logic via `setBuildProvider`, `setParseProvider`, and `setSendProvider`.
