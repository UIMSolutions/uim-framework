# NAF v4 Architecture - UIM-OAS

This document maps uim-oas capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM OpenAPI Specification Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | OpenAPI parsing and endpoint extraction |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| OAS | OpenAPI Specification |
| Document | API contract definition source (YAML/JSON-like text) |
| Endpoint | Path and method operation exposed by an API |
| Version Detection | Identification of OpenAPI/Swagger variant |
| Async Parse | Non-blocking parse callback workflow |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
OpenAPI Processing
|- Document Ingestion
|  |- raw source capture
|  |- version and metadata extraction
|- Endpoint Mapping
|  |- path/method extraction
|  |- method-based filtering
|- Validation
|  |- minimal document integrity checks
|- Async Handling
   |- callback-based parse dispatch
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async callback flow | vibe.d runTask |
| Source pattern extraction | regex-based parser helpers |
| Document model | OAS interfaces and enums |
| Query by method | endpoint list filtering logic |

## OV - Operational View

### OV-1 Operational Concept

1. Application provides OpenAPI source content.
2. Service parses source into a typed document model.
3. Service validates minimum contract completeness.
4. Application queries endpoints by HTTP method.
5. Optional asynchronous parsing dispatches result to handlers.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Read source | OAS text | parse candidate |
| 2 | Extract metadata | source text | version/title/doc version |
| 3 | Extract endpoints | source text | endpoint list |
| 4 | Validate document | typed model | valid/invalid result |
| 5 | Async notify | parsed document | callback execution |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - API governance tooling  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.oas                   |
| - interfaces              |
| - parser helpers          |
| - document model          |
| - parse/validate service  |
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
| uim.oas.interfaces.document | OAS contracts, endpoint struct, enums |
| uim.oas.helpers.parser | Source parsing and extraction helpers |
| uim.oas.models.document | Concrete OAS document implementation |
| uim.oas.service | Parse, validate, query, and async orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| OpenAPI Specification | 2.0 / 3.0 / 3.1 detection | API contract modeling |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async runtime support |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Version detection | Implemented | Swagger/OpenAPI variant identification |
| Metadata extraction | Implemented | title and document version parsing |
| Endpoint extraction | Implemented | path/method capture |
| Async parse API | Implemented | non-blocking callback delivery |
| Full schema validation | Planned | strict OpenAPI semantic and schema checks |

## L - Logical Model

### L-1 Logical Data Model

```text
IOASDocument
  |- raw: string
  |- version: OASVersion
  |- title: string
  |- documentVersion: string
  |- endpoints: OASEndpoint[]

OASEndpoint
  |- path: string
  |- method: string
  |- summary: string
```

### L-2 Constraints

* A valid document requires recognized OAS version and non-empty title.
* Validation checks at least one endpoint presence.
* Method queries are case-insensitive.
* Async callback execution is exception-isolated.
