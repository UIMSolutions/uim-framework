/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-gRPC

This document maps `uim-grpc` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM gRPC Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Protocol | gRPC unary semantics |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| gRPC | High-performance RPC framework using typed service contracts |
| Unary RPC | Request-response interaction with exactly one request and one response |
| Method Path | Fully qualified gRPC endpoint path `/package.Service/Method` |
| Metadata | Key-value headers/trailers associated with a gRPC call |
| Status Code | Canonical gRPC result code (`ok`, `unimplemented`, `internal`, etc.) |
| Framing | gRPC message envelope: 1-byte compression flag + 4-byte message length |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
gRPC Unary Invocation
|- Method Path Handling
|  |- Normalize method paths
|  |- Build service/method paths
|  |- Split path for routing
|- Message Representation
|  |- Typed request model
|  |- Typed response model
|  |- Canonical status model
|- Wire Framing
|  |- Build 5-byte frame headers
|  |- Parse framed payloads
|- Invocation Runtime
   |- Register unary handlers
   |- Execute synchronous invocation
   |- Dispatch asynchronous invocation via vibe.d runTask
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Async callback dispatch | vibe.d `runTask` |
| Status interoperability | gRPC canonical status model |
| Method routing consistency | Path normalization helpers |
| Payload transport readiness | gRPC wire framing helper functions |

## OV - Operational View

### OV-1 Operational Concept

1. A service registers unary handlers by method path.
2. An application creates a unary request containing method path, payload, metadata, and timeout.
3. The channel normalizes and resolves the method path.
4. The matched handler produces a typed unary response.
5. The response is returned synchronously or via async callback.
6. Payloads can be framed/unframed for network transport integration.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Register handler | method path, delegate | route table entry |
| 2 | Build request | method, payload, metadata | `GrpcUnaryRequest` |
| 3 | Resolve route | request method path | matched handler or error |
| 4 | Invoke handler | request | `GrpcUnaryResponse` |
| 5 | Return result | response | app-level completion |
| 6 | Optional frame payload | response payload | network-ready frame |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+--------------------------+
| Application Layer        |
| - service registration   |
| - request invocation     |
+------------+-------------+
             |
             v
+--------------------------+
| uim.grpc                 |
| - UIMGrpcUnaryChannel    |
| - Grpc request/response  |
| - Path + framing helpers |
+------------+-------------+
             |
             v
+--------------------------+
| vibe.d runtime           |
| - runTask async dispatch |
+--------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.grpc.interfaces.unary` | Status enums, unary contracts, channel interface |
| `uim.grpc.helpers.path` | Method path normalization and splitting |
| `uim.grpc.helpers.framing` | gRPC frame encode/decode |
| `uim.grpc.message` | Request/response factory helpers |
| `uim.grpc.channel` | In-process unary routing and invocation |
| `uim.grpc.transports.loopback` | Loopback transport facade |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| gRPC Wire Framing | Canonical | Binary message envelope structure |
| D Language | 2.x | Implementation language |
| vibe.d | 0.10.x | Runtime and async task scheduling |
| Apache License | 2.0 | Distribution and reuse |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Unary contracts and channel | Implemented | Request/response model and handler routing |
| Wire framing helper | Implemented | Frame and unframe payloads |
| Loopback transport facade | Implemented | Local integration and testing path |
| HTTP/2 transport adapter | Planned | Network call execution over gRPC |
| Streaming RPC support | Planned | Client/server/bidirectional stream APIs |

## L - Logical Model

### L-1 Logical Data Model

```text
GrpcUnaryRequest
  |- methodPath: string
  |- payload: ubyte[]
  |- metadata: GrpcMetadataEntry[]
  |- timeoutMs: uint

GrpcUnaryResponse
  |- status: GrpcStatusCode
  |- statusMessage: string
  |- payload: ubyte[]
  |- metadata: GrpcMetadataEntry[]

UIMGrpcUnaryChannel
  |- handlers: GrpcUnaryHandler[string]
```

### L-2 Constraints

- Method path must follow `/service/method` structure.
- Unary invocation returns exactly one response object.
- Frame decode requires exact payload length match with header.
- Unknown methods return `GrpcStatusCode.unimplemented`.
