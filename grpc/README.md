# Library uim-grpc

Updated on 28. May 2026

A lightweight gRPC toolkit for dlang built with vibe.d runtime primitives. The library includes typed unary RPC contracts, gRPC wire framing helpers, method path utilities, and a loopback channel for service-first development and tests.

## Features

- Typed gRPC status model (`GrpcStatusCode`)
- Unary request/response contracts (`GrpcUnaryRequest`, `GrpcUnaryResponse`)
- 5-byte gRPC message framing codec (compression flag + payload length)
- Method path normalization and parsing helpers (`/package.Service/Method`)
- In-process unary channel with sync and async invocation
- vibe.d task-based async dispatch via `runTask`

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:grpc" version="*"
```

## Quick Start

```d
import uim.grpc;
import std.conv : to;
import std.string : representation;

void main() {
  auto channel = GrpcUnaryChannel();

  channel.registerUnary("/demo.Greeter/SayHello", (GrpcUnaryRequest request) {
    auto name = cast(string) request.payload.idup;
    return GrpcOk(("Hello " ~ name).representation);
  });

  auto response = channel.invoke(GrpcRequest(
    "/demo.Greeter/SayHello",
    "UIM".representation
  ));

  assert(response.ok());
  assert(cast(string) response.payload.idup == "Hello UIM");
}
```

## Modules

- `uim.grpc`: package entrypoint and re-exports
- `uim.grpc.interfaces`: status codes, unary contracts, channel interface
- `uim.grpc.message`: request/response factories and helpers
- `uim.grpc.channel`: in-process unary channel implementation
- `uim.grpc.helpers.path`: gRPC method path normalization/parsing
- `uim.grpc.helpers.framing`: gRPC wire frame encode/decode helpers
- `uim.grpc.transports.loopback`: loopback transport facade over unary channel

## Notes

This package focuses on gRPC payload and invocation primitives that integrate cleanly with vibe.d task scheduling. HTTP/2 network transport adapters can be layered on top of the same interfaces without changing service code.
