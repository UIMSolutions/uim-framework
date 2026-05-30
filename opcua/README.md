# Library uim-opcua

Updated on 30. May 2026

uim-opcua is a lightweight D library to work with OPC UA (Open Platform Communications Unified Architecture) workflows using vibe.d runtime patterns. It provides typed configuration, node read/write/method orchestration, request/response helper functions, and asynchronous callback APIs.

## Features

- Typed OPC UA contracts (`IOPCUAService`)
- Configuration model for endpoint, security, and session context
- Request/response helpers for basic read and write message modeling
- Synchronous APIs for read, write, and method invocation
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real OPC UA transport stacks

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:opcua" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.opcua;

void main() {
  auto service = OPCUAService();

  OPCUAConfig cfg;
  cfg.endpointUrl = "opc.tcp://192.168.1.50:4840";
  cfg.sessionName = "uim-session";

  assert(service.configure(cfg));

  auto readResult = service.readNode("ns=2;s=Machine/Speed");
  writeln(readResult.nodeId, " = ", readResult.value);

  auto writeResult = service.writeNode("ns=2;s=Machine/Setpoint", "1800", "Int32");
  writeln(writeResult.statusCode, " ", writeResult.message);
}
```

## Modules

- `uim.opcua`: package entrypoint and re-exports
- `uim.opcua.interfaces`: contracts, enums, config, and DTO structs
- `uim.opcua.models`: result and empty-value helper constructors
- `uim.opcua.helpers`: request builder and response parser helpers
- `uim.opcua.service`: read/write/invoke orchestration and async APIs

## Notes

- Default behavior uses an in-memory provider and does not perform real OPC UA network transport.
- For production usage, inject transport logic via `setReadProvider`, `setWriteProvider`, and `setInvokeProvider`.
