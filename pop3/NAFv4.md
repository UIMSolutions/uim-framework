# NAF v4 Architecture - UIM-POP3

This document maps uim-pop3 capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM POP3 Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | POP3 mailbox retrieval and lifecycle orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| POP3 Service | Service that orchestrates POP3 mailbox operations |
| POP3 Status | Mailbox aggregate state from STAT semantics |
| POP3 Message Meta | Message number/size/uid reference entry |
| POP3 Message | Retrieved message payload with headers and body |
| Async Operation | Non-blocking operation callback executed via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
POP3 Integration Capability
|- Mailbox Configuration
|  |- host, port, security setup
|  |- credentials and timeout options
|- Mailbox Inspection
|  |- STAT parsing and status model
|  |- LIST and UIDL parsing
|- Message Lifecycle
|  |- RETR parsing and message construction
|  |- DELE orchestration
|- Async Processing
   |- status callback execution
   |- retrieve/delete callback execution
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Response parsing | codec helper functions |
| Mailbox defaults | model helper constructors |
| External server integration | provider delegate injection |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures POP3 server and credentials.
2. Service provides mailbox statistics and listing information.
3. Application retrieves message content by message number.
4. Application can mark messages for deletion.
5. Async APIs deliver operation outcomes through callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | POP3Config | ready-to-query mailbox state |
| 2 | Read mailbox status | STAT response or provider | POP3Status |
| 3 | Read message index | LIST/UIDL response or provider | POP3MessageMeta[] |
| 4 | Retrieve message | message number + RETR payload | POP3Message |
| 5 | Mark for deletion | message number | POP3Result |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - mailbox processing      |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.pop3                  |
| - interfaces              |
| - models                  |
| - codec helpers           |
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
| uim.pop3.interfaces.mailbox | POP3 contracts, enums, and value types |
| uim.pop3.models.mailbox | status/result/message factory helpers |
| uim.pop3.helpers.codec | POP3 response parser helpers |
| uim.pop3.service | stat/list/uidl/retr/dele and async orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| POP3 | RFC 1939 | mailbox command and response semantics |
| STLS (POP3) | RFC 2595 | optional secure session upgrade reference |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed POP3 model and service API | Implemented | status, listing, retrieval, delete models |
| POP3 parser helper layer | Implemented | STAT/LIST/UIDL/RETR parsing |
| Async operation API | Implemented | callback-based status/retrieve/delete methods |
| In-memory provider defaults | Implemented | integration-ready behavior without server |
| Full socket POP3 transport | Planned | USER/PASS, STAT, LIST, UIDL, RETR, DELE, QUIT flow |

## L - Logical Model

### L-1 Logical Data Model

```text
POP3Config
  |- host: string
  |- port: ushort
  |- security: POP3Security
  |- username: string
  |- password: string

POP3Status
  |- success: bool
  |- messageCount: uint
  |- mailboxSizeBytes: ulong
  |- message: string

POP3MessageMeta
  |- number: uint
  |- sizeBytes: ulong
  |- uid: string

POP3Message
  |- number: uint
  |- uid: string
  |- headers: string
  |- body: string
```

### L-2 Constraints

- Service operations require a configured host and non-zero port.
- Message numbers must be greater than zero for `RETR` and `DELE`.
- `STAT` parser expects `+OK <count> <size>` shape.
- Async callback invocation is exception-isolated.
