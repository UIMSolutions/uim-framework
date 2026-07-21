# NAF v4 Architecture - UIM-CDC

This document maps uim-cdc capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM CDC Library |
| Version | 26.x |
| Date | 21 Jul 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Virtual COM Port / USB CDC data exchange |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| CDC | USB Communication Device Class serial-style channel |
| Virtual COM Port | OS-exposed serial endpoint mapped to USB CDC device |
| Loopback Mode | In-memory endpoint used for test and simulation |
| CDC Frame | Unit of exchanged data represented as text and payload bytes |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
CDC Integration Capability
|- Port Configuration
|  |- baud/parity/dataBits/stopBits setup
|  |- timeout and newline framing behavior
|- Data Exchange
|  |- write text and raw bytes
|  |- read single framed payload
|- Async Orchestration
|  |- async write callback
|  |- async polling callback
|- Testability
   |- loopback endpoint without hardware dependency
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async callbacks | vibe.d runTask |
| File-backed endpoint I/O | phobos stdio/file wrappers |
| Frame detection | codec helpers |
| Interface contracts | typed service and DTO structures |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures CDC port parameters.
2. Service opens device endpoint or loopback endpoint.
3. Application writes text/bytes to CDC channel.
4. Service reads and returns framed data from endpoint.
5. Async APIs provide callback-based send/poll behavior.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Open port | CDCPortConfig | open/closed state |
| 2 | Send payload | text or bytes | CDCResult |
| 3 | Read frame | port buffer | CDCFrame |
| 4 | Poll async | handler + interval | callback frame |
| 5 | Close port | lifecycle command | released resources |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - telemetry/control apps  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.cdc                   |
| - interfaces              |
| - models/service          |
| - codec helpers           |
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
| uim.cdc.interfaces.port | CDC contracts, enums, DTOs |
| uim.cdc.helpers.codec | loopback/path/frame helper functions |
| uim.cdc.service | device read/write wrappers |
| uim.cdc.models.port | service implementation |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| USB CDC ACM | common class profile | virtual serial communication semantics |
| OS serial devices | platform-specific | endpoint path realization |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| CDC service contracts | Implemented | typed port/frame/result model |
| Loopback transport mode | Implemented | hardware-independent validation |
| Sync and async APIs | Implemented | write/read and callback operations |
| Full non-blocking serial backend | Planned | dedicated serial event loop and framing buffers |
| Control-line signaling (DTR/RTS) | Planned | modem-style CDC control support |

## L - Logical Model

### L-1 Logical Data Model

```text
CDCPortConfig
  |- devicePath: string
  |- baudRate: uint
  |- dataBits: ubyte
  |- parity: CDCParity
  |- stopBits: CDCStopBits
  |- readTimeoutMs: uint
  |- newlineDelimited: bool

CDCFrame
  |- channel: string
  |- text: string
  |- payload: ubyte[]

CDCResult
  |- success: bool
  |- bytesTransferred: size_t
  |- message: string
```

### L-2 Constraints

- Device path is required to open a CDC service endpoint.
- Loopback mode is intended for tests and simulation.
- Real CDC endpoint behavior depends on device driver and permission model.
- Newline frame mode expects line delimiters for segmented reads.
