# NAF v4 Architecture - UIM-LLRP

This document maps uim-llrp capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM LLRP Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | LLRP message encoding, decoding, and reader orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| LLRP Service | Service that orchestrates encode, decode, and send workflows |
| Reader | RFID reader endpoint speaking Low Level Reader Protocol |
| Frame | Structured LLRP transport payload representation |
| Keepalive Ack | Basic acknowledgement for reader session continuity |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
LLRP Integration Capability
|- Reader Configuration
|  |- host and port setup
|  |- client/session options and protocol version
|- Message Processing
|  |- encode typed request into frame
|  |- decode frame into typed message
|- Reader Messaging
|  |- synchronous send workflow
|  |- provider-injected transport workflow
|- Async Processing
   |- async decode callback
   |- async send callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Frame conversion | codec helper functions |
| Default integration mode | in-memory provider behavior |
| Real reader transport | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures reader endpoint and LLRP session context.
2. Service encodes a typed message into a transport frame.
3. Service decodes reader frames into typed message structures.
4. Service sends message frames and receives acknowledgements.
5. Async APIs expose non-blocking decode/send paths.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | LLRPConfig | ready state |
| 2 | Encode message | type + id + payload | LLRPMessage |
| 3 | Decode frame | encoded frame string | LLRPMessage |
| 4 | Send message | LLRPMessage | LLRPResult |
| 5 | Async execution | frame/message + handler | callback result |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - RFID reader workflows   |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.llrp                  |
| - interfaces              |
| - models                  |
| - frame codec helpers     |
| - service orchestration   |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask callback engine |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.llrp.interfaces.client | LLRP contracts and value types |
| uim.llrp.models.client | result and empty-message helper factories |
| uim.llrp.helpers.codec | frame encode and decode helpers |
| uim.llrp.service | encode/decode/send orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| LLRP | EPCglobal 1.0.1/1.1 | reader protocol model |
| TCP/IP | RFC stack | underlying transport for production providers |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed LLRP API model | Implemented | encode/decode/send contracts |
| Frame codec helpers | Implemented | message-to-frame conversion |
| Async operation API | Implemented | callback-based decode/send |
| In-memory provider defaults | Implemented | integration without reader hardware |
| Binary packet encoding and socket transport | Planned | full LLRP wire-format support |

## L - Logical Model

### L-1 Logical Data Model

```text
LLRPConfig
  |- host: string
  |- port: ushort
  |- readerName: string
  |- clientId: string
  |- llrpVersion: LLRPVersion

LLRPMessage
  |- messageType: string
  |- messageId: uint
  |- payload: string
  |- encodedFrame: string

LLRPResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
  |- responseFrame: string
```

### L-2 Constraints

- Service operations require configured non-empty host and non-zero port.
- Encode operation requires non-empty message type.
- Decode operation expects a non-empty encoded frame string.
- Async callback invocation is exception-isolated.
