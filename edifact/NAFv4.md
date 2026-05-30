# NAF v4 Architecture - UIM-EDIFACT

This document maps uim-edifact capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM EDIFACT Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | EDIFACT parsing, serialization, and acknowledgment orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| EDIFACT Service | Service that orchestrates parse, serialize, and ack workflows |
| Segment | EDIFACT tag plus data elements |
| Interchange | Delimited EDIFACT payload with message segments |
| CONTRL Ack | Functional acknowledgment of message acceptance/rejection |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
EDIFACT Integration Capability
|- Interchange Configuration
|  |- sender and receiver identifiers
|  |- syntax profile and control reference
|- Message Processing
|  |- parse segment list from interchange
|  |- serialize segment list to interchange
|- Acknowledgment Handling
|  |- generate CONTRL accepted result
|  |- generate CONTRL rejected result
|- Async Processing
   |- async parse callback
   |- async serialize callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Segment conversion | codec helper functions |
| Default integration mode | in-memory parse/ack behavior |
| External processing engine | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures EDIFACT sender/receiver context.
2. Service parses the interchange payload into typed segments.
3. Service serializes message segments back into EDIFACT text.
4. Service generates CONTRL-style accept/reject responses.
5. Async APIs expose non-blocking parse/serialize paths.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | EDIFACTConfig | ready state |
| 2 | Parse interchange | EDIFACT string | EDIFACTMessage |
| 3 | Serialize message | EDIFACTMessage | interchange text |
| 4 | Generate ack | message + status | EDIFACTResult |
| 5 | Parse segment line | one segment string | EDIFACTSegment |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - B2B order workflows     |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.edifact               |
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
| uim.edifact.interfaces.client | EDIFACT contracts and value types |
| uim.edifact.models.client | result/message helper factories |
| uim.edifact.helpers.codec | segment parsing and serialization helpers |
| uim.edifact.service | parse/serialize/ack orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| UN/EDIFACT | ISO 9735 | message and segment syntax |
| CONTRL | UN/EDIFACT message | functional acknowledgment concept |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed EDIFACT API model | Implemented | parse/serialize/ack contracts |
| Segment parser helper | Implemented | line and interchange parsing |
| Async operation API | Implemented | callback-based parse/serialize |
| In-memory provider defaults | Implemented | integration without external engine |
| Full schema/message validation | Planned | directory-driven message validation |

## L - Logical Model

### L-1 Logical Data Model

```text
EDIFACTConfig
  |- senderId: string
  |- receiverId: string
  |- syntax: EDIFACTSyntax
  |- controlReference: string

EDIFACTSegment
  |- tag: string
  |- elements: string[]

EDIFACTMessage
  |- messageType: string
  |- releaseCode: string
  |- controllingAgency: string
  |- messageReference: string
  |- segments: EDIFACTSegment[]

EDIFACTResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
  |- controlReference: string
```

### L-2 Constraints

- Service operations require configured sender and receiver identifiers.
- Parsing expects EDIFACT segment delimiter `'` and data element separator `+`.
- Serialization requires at least one segment.
- Async callback invocation is exception-isolated.
