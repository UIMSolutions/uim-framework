# NAF v4 Architecture - UIM-OPENAPI

This document maps uim-openapi capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM OpenAPI Library |
| Version | 26.x |
| Date | 29 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | OpenAPI document parsing and query |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| OpenAPI | API contract format for HTTP APIs |
| OpenAPI Service | Service that parses and queries OpenAPI content |
| OpenAPI Document | Typed in-memory representation of document metadata and operations |
| Operation | HTTP method/path capability entry extracted from the specification |
| Async Parse | Non-blocking document parse callback executed via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
OpenAPI Integration Capability
|- Document Parsing
|  |- version detection
|  |- title and document version extraction
|- API Surface Discovery
|  |- operation extraction (path + method)
|  |- server URL extraction
|- Query Services
|  |- filter operations by HTTP method
|  |- filter operations by path
|- Async Processing
   |- callback-based parse completion
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async parse callbacks | vibe.d runTask |
| Version and metadata extraction | parser helper functions |
| Query filters | in-memory operation list |
| Type contracts | interface and model declarations |

## OV - Operational View

### OV-1 Operational Concept

1. Application passes OpenAPI source content to the service.
2. Service extracts key document metadata and operation entries.
3. Service returns a typed document abstraction.
4. Application validates and queries methods/paths.
5. Optional asynchronous parse dispatches callback with parsed document.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Parse source | YAML/JSON-like OpenAPI text | typed document instance |
| 2 | Detect version | source text | OpenAPIVersion |
| 3 | Extract API data | source text | title, servers, operations |
| 4 | Validate document | typed document | validation result |
| 5 | Query operations | method or path filter | subset of operations |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - integration workflows   |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.openapi               |
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
| uim.openapi.interfaces.document | OpenAPI contracts, enums, and operation struct |
| uim.openapi.models.document | Concrete OpenAPI document implementation |
| uim.openapi.helpers.parser | metadata/server/operation extraction |
| uim.openapi.service | parse, validate, query, async orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| OpenAPI | 2.0, 3.0, 3.1 | API contract semantics |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Document model | Implemented | version/title/documentVersion/servers/operations |
| Lightweight parser | Implemented | extraction from YAML/JSON-like text |
| Query API | Implemented | by method and by path |
| Async parse | Implemented | callback-based non-blocking processing |
| Strict schema validation | Planned | integration with dedicated validators |

## L - Logical Model

### L-1 Logical Data Model

```text
IOpenAPIDocument
  |- raw: string
  |- version: OpenAPIVersion
  |- title: string
  |- documentVersion: string
  |- servers: string[]
  |- operations: OpenAPIOperation[]

OpenAPIOperation
  |- path: string
  |- method: string
  |- operationId: string
  |- summary: string
```

### L-2 Constraints

* A document is valid only if version is known and title is non-empty.
* A service validation additionally requires at least one operation.
* Async callbacks are exception-isolated.
* Query operations are case-insensitive for method filtering.
