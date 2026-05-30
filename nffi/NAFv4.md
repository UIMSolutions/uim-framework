# NAF v4 Architecture - UIM-NFFI

This document maps uim-nffi capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM NFFI Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Friendly force track exchange and synchronization |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| NFFI Service | Service that orchestrates publish, query, and synchronization workflows |
| Friendly Force Track | Structured position/status representation for own and allied units |
| Affiliation | Ownership category (Friendly/Hostile/Neutral/Unknown) |
| Symbol Code | Military symbology code associated with a force element |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
NFFI Integration Capability
|- Service Configuration
|  |- endpoint and nation profile setup
|  |- force identity and standards profile setup
|- Track Management
|  |- publish one friendly force track
|  |- query one force track by unit id
|- Area Synchronization
|  |- synchronize area/unit set to local cache
|- Async Processing
   |- async get callback
   |- async publish and sync callbacks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Track conversion | codec helper functions |
| Default integration mode | in-memory provider behavior |
| Real tactical integration | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures NFFI endpoint and force context.
2. Service queries friendly tracks by unit identifier.
3. Service publishes updates for local unit track state.
4. Service synchronizes all tracks for a requested area.
5. Async APIs expose non-blocking query/publish/sync paths.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | NFFIConfig | ready state |
| 2 | Query track | unitId | NFFITrack |
| 3 | Publish track | NFFITrack | NFFIResult |
| 4 | Sync area | areaId | NFFITrack[] |
| 5 | Encode/decode | NFFITrack or payload | payload or NFFITrack |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - C2 and COP workflows    |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.nffi                  |
| - interfaces              |
| - models                  |
| - track codec helpers     |
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
| uim.nffi.interfaces.client | NFFI contracts and value types |
| uim.nffi.models.client | result and empty-track helper factories |
| uim.nffi.helpers.codec | track payload encode/decode helpers |
| uim.nffi.service | publish/get/synchronize orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| NFFI | NATO profile family | friendly force information exchange |
| APP-11/ATP-45 | profile references | position reporting model guidance |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed NFFI API model | Implemented | publish/query/sync contracts |
| Track codec helpers | Implemented | payload conversion helpers |
| Async operation API | Implemented | callback-based get/publish/sync |
| In-memory provider defaults | Implemented | integration without external system |
| Full tactical message profile mapping | Planned | profile-compliant validation and transport mappings |

## L - Logical Model

### L-1 Logical Data Model

```text
NFFIConfig
  |- endpoint: string
  |- nationCode: string
  |- forceId: string
  |- standard: NFFIStandard
  |- timeoutMs: uint

NFFITrack
  |- unitId: string
  |- callsign: string
  |- affiliation: string
  |- symbolCode: string
  |- latitude: double
  |- longitude: double
  |- altitude: double
  |- timestamp: long
  |- source: string

NFFIResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
  |- referenceId: string
```

### L-2 Constraints

- Service operations require configured non-empty endpoint.
- Track publication requires non-empty unit identifier.
- Synchronization requires non-empty area identifier.
- Async callback invocation is exception-isolated.
