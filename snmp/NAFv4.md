# NAF v4 Architecture - UIM-SNMP

This document maps uim-snmp capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM SNMP Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | SNMP data retrieval and write orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| SNMP Service | Service that orchestrates SNMP get/walk/set operations |
| OID Value | Typed result for one object identifier |
| Walk Result | Collection of OID values under a root branch |
| Security Level | SNMPv3 security profile level |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
SNMP Integration Capability
|- Endpoint Configuration
|  |- host and port setup
|  |- SNMP version and security profile
|- OID Retrieval
|  |- single OID get operation
|  |- subtree walk operation
|- OID Mutation
|  |- set value by oid/type
|- Async Processing
   |- async get callback
   |- async walk and set callbacks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| OID parsing | codec helper functions |
| Default integration mode | in-memory provider behavior |
| Real network communication | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures SNMP endpoint, version, and credentials/community.
2. Service reads one value through `get`.
3. Service enumerates branches through `walk`.
4. Service writes values through `set`.
5. Async APIs deliver responses via callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | SNMPConfig | ready-to-query state |
| 2 | Read OID | OID string | SNMPOidValue |
| 3 | Walk subtree | root OID + max repetitions | SNMPOidValue[] |
| 4 | Write OID | OID + value + type | SNMPResult |
| 5 | Parse textual line | raw line | normalized OID value |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - monitoring and control  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.snmp                  |
| - interfaces              |
| - models                  |
| - parser helpers          |
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
| uim.snmp.interfaces.client | SNMP contracts and value types |
| uim.snmp.models.client | result and empty-value helper factories |
| uim.snmp.helpers.codec | OID and walk output parsing helpers |
| uim.snmp.service | get/walk/set orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| SNMP | RFC 1157 / RFC 1905 / RFC 3416 | get/set/walk semantics |
| SNMPv3 USM | RFC 3414 | security level concepts |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed SNMP API model | Implemented | get/walk/set contracts |
| Textual OID parser helper | Implemented | line to value normalization |
| Async operation API | Implemented | callback-based get/walk/set |
| In-memory provider defaults | Implemented | integration without network device |
| UDP transport and BER encoding | Planned | real SNMP packet exchange and decoding |

## L - Logical Model

### L-1 Logical Data Model

```text
SNMPConfig
  |- host: string
  |- port: ushort
  |- version: SNMPVersion
  |- securityLevel: SNMPSecurityLevel
  |- community: string

SNMPOidValue
  |- oid: string
  |- typeTag: string
  |- value: string
  |- timestamp: long

SNMPResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
```

### L-2 Constraints

- Service operations require configured host and non-zero port.
- OID is mandatory for get/set operations.
- Walk operation requires non-empty root OID and non-zero max repetitions.
- Async callback invocation is exception-isolated.
