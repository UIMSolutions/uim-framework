/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-ADatP3

This document maps `uim-adatp3` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM ADatP-3 Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Message Standard | NATO ADatP-3 |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| ADatP-3 | NATO Message Text Formatting System |
| SITREP | Situation Report message type |
| SPOTREP | Spot Report message type |
| FRAGO | Fragmentary Order message type |
| Precedence | Message handling urgency (routine, priority, immediate, flash) |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
ADatP-3 Message Exchange
|- Message Construction
|  |- Typed message classes and interfaces
|  |- Header metadata (ID, originator, recipient, timestamp)
|- Message Prioritization
|  |- NATO-style precedence values
|- Serialization
|  |- JSON encode for transport/storage
|  |- JSON decode to typed objects
|- Async Delivery
   |- vibe.d runTask callback dispatch
   |- Pluggable transport interface
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Async callback handling | vibe.d task scheduler (`runTask`) |
| Message model compatibility | ADatP-3 field semantics |
| Serialization interoperability | JSON format conventions |
| Library integration | uim core and oop base modules |

## OV - Operational View

### OV-1 Operational Concept

1. The application creates an ADatP-3 message with mission metadata and fields.
2. The codec serializes the message into JSON for transport or persistence.
3. A transport implementation sends the message asynchronously.
4. A response callback receives a decoded ADatP-3 message.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Create message | Type, ID, originator, recipient | ADatP-3 message object |
| 2 | Add report fields | Key/value tactical data | Enriched message object |
| 3 | Encode payload | Message object | JSON payload |
| 4 | Dispatch async send | Payload/message | Transport callback scheduling |
| 5 | Process response | Callback input | Application-level handling |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - mission/report logic    |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.adatp3                |
| - message model           |
| - JSON codec              |
| - transport interface     |
| - vibe task dispatch      |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask                 |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.adatp3.types.message` | ADatP-3 enums and conversion helpers |
| `uim.adatp3.interfaces.message` | Message contract |
| `uim.adatp3.interfaces.transport` | Async transport contract |
| `uim.adatp3.message` | Message implementation |
| `uim.adatp3.codec` | JSON encode/decode |
| `uim.adatp3.transport` | vibe.d task-based transport implementation |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| NATO ADatP-3 | operational | Message structure semantics |
| D Language | 2.x | Implementation language |
| vibe.d | 0.10.x | Async runtime primitives |
| JSON | RFC 8259 | Message serialization format |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Typed ADatP-3 model | Implemented | Message class and interfaces |
| JSON codec | Implemented | Reversible message serialization |
| Async transport shim | Implemented | Callback dispatch with runTask |
| HTTP integration | Implemented | Async endpoint delivery using vibe-http requestHTTP |
| Validation profiles | Planned | Field-level schema/constraint checks |

## L - Logical Model

### L-1 Logical Data Model

```text
UIMADatP3Message
  |- messageType: ADatP3MessageType
  |- messageId: string
  |- originator: string
  |- recipient: string
  |- timestamp: SysTime
  |- priority: ADatP3Priority
  |- fields: string[string]

UIMADatP3Transport
  |- connected: bool
  |- endpoint: string
```

### L-2 Constraints

- Endpoint URLs for the default transport must use `http://` or `https://`.
- Message IDs should be globally unique per reporting chain.
- Field keys must be non-empty strings.
- The default transport is loopback-oriented and intended for integration bootstrap.
