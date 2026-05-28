# NAF v4 Architecture - UIM-JC3IEDM

This document maps uim-jc3iedm capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM JC3IEDM Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | JC3IEDM aligned command-and-control information exchange |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| JC3IEDM | Joint Consultation, Command and Control Information Exchange Data Model |
| Entity | Operational data object (unit, equipment, action, etc.) |
| Affiliation | Operational side relationship (friendly, hostile, neutral, unknown) |
| Position | Spatial reference of an entity |
| Attribute | Key-value metadata field attached to an entity |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
JC3IEDM Data Handling
|- Entity Lifecycle
|  |- create and update entity records
|  |- normalize and validate identifiers
|- Semantic Classification
|  |- type-based queries
|  |- affiliation-based queries
|- Attribute Query
|  |- key/value filtering
|- Async Processing
   |- stream entities via runTask handlers
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async streams | vibe.d runTask |
| Entity indexing | in-memory dictionary store |
| Identifier normalization | JC3IEDM helper functions |
| Domain abstraction | JC3IEDM contracts and enums |

## OV - Operational View

### OV-1 Operational Concept

1. Application opens a JC3IEDM service session.
2. Operational entities are upserted with classification, affiliation, and position data.
3. Queries retrieve subsets by type, affiliation, or attribute constraints.
4. Entity snapshots can be streamed asynchronously to processing handlers.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Connect service | endpoint | active session |
| 2 | Upsert entity | JC3IEDM entity | indexed record |
| 3 | Type query | entity type | matching entities |
| 4 | Affiliation query | affiliation | matching entities |
| 5 | Async stream | callback handler | dispatched entity events |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - C2 and situational apps |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.jc3iedm               |
| - interfaces              |
| - helpers                 |
| - entity model            |
| - service and queries     |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask scheduling      |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.jc3iedm.interfaces.entity | Contracts, enums, and position struct |
| uim.jc3iedm.helpers.text | Identifier normalization |
| uim.jc3iedm.models.entity | Concrete JC3IEDM entity implementation |
| uim.jc3iedm.service | In-memory persistence, query, and stream orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async runtime support |
| JC3IEDM Domain Model | conceptual alignment | C2 information organization |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Entity model | Implemented | Type, affiliation, position, attributes |
| Query operations | Implemented | Type/affiliation/attribute filtering |
| Async stream API | Implemented | Non-blocking handler callbacks |
| Schema-mapped codecs | Planned | XML/JSON mapping profiles |
| Federated connectors | Planned | External C2 exchange endpoints |

## L - Logical Model

### L-1 Logical Data Model

```text
IJC3IEDMEntity
  |- id: string
  |- name: string
  |- entityType: JC3IEDMEntityType
  |- affiliation: JC3IEDMAffiliation
  |- position: JC3IEDMPosition
  |- attributes: string[string]

JC3IEDMPosition
  |- latitude: double
  |- longitude: double
  |- altitude: double
```

### L-2 Constraints

* Service operations require an active connection state.
* Entity upsert requires valid non-empty id and name values.
* Entity IDs are normalized for stable indexing.
* Async handlers are exception-isolated during streaming.
