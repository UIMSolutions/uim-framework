# NAF v4 Architecture - UIM-CDM

This document maps `uim-cdm` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM Common Data Model Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Message Standard | Common Data Model |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| CDM | Common Data Model |
| Entity | Named logical record in the model |
| Field | Typed attribute/value pair belonging to an entity |
| Metadata | Key/value descriptive information attached to documents or entities |
| Namespace URI | Logical model namespace identifier |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
Common Data Model Handling
|- Model Construction
|  |- Typed document and entity objects
|  |- Field abstractions and metadata
|- Serialization
|  |- JSON encode
|  |- JSON decode
|- Async Delivery
   |- vibe.d task dispatch
   |- Pluggable HTTP transport
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Async callback handling | vibe.d task scheduler (`runTask`) |
| HTTP message exchange | vibe.http client request API |
| Serialization interoperability | JSON format conventions |
| Library integration | uim core and oop base modules |

## OV - Operational View

### OV-1 Operational Concept

1. The application creates a CDM document with entities, fields, and metadata.
2. The codec serializes the document to JSON for transport or persistence.
3. The transport sends the document asynchronously to the configured HTTP endpoint.
4. The response is decoded and delivered to the application handler.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Create document | CDM identifiers and namespace | CDM document object |
| 2 | Add entities | Typed fields and metadata | Enriched document object |
| 3 | Encode payload | Document object | JSON payload |
| 4 | Dispatch send | Payload | Async HTTP request |
| 5 | Process response | HTTP body | CDM document response |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - data model logic        |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.cdm                   |
| - document model          |
| - JSON codec              |
| - transport interface     |
| - vibe task dispatch      |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask                 |
| - requestHTTP             |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.cdm.types.document` | CDM enums and conversion helpers |
| `uim.cdm.interfaces.document` | Document, entity, and field contracts |
| `uim.cdm.interfaces.transport` | Async transport contract |
| `uim.cdm.document` | Concrete document model |
| `uim.cdm.codec` | JSON encode/decode |
| `uim.cdm.transport` | vibe.d HTTP transport implementation |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| Common Data Model | project-defined | Document and entity semantics |
| D Language | 2.x | Implementation language |
| vibe.d | 0.10.x | Async runtime primitives |
| JSON | RFC 8259 | Message serialization format |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Typed CDM model | Implemented | Document, entity, and field types |
| JSON codec | Implemented | Reversible document serialization |
| Async HTTP transport | Implemented | Callback dispatch with requestHTTP |
| Schema validation | Planned | Model-level constraint checks |
| Backend adapters | Planned | Storage and gateway integrations |

## L - Logical Model

### L-1 Logical Data Model

```text
UIMCdmDocument
  |- id: string
  |- name: string
  |- namespaceUri: string
  |- version: string
  |- created: SysTime
  |- entities: ICdmEntity[]
  |- metadata: string[string]

UIMCdmEntity
  |- name: string
  |- description: string
  |- fields: ICdmField[]
  |- metadata: string[string]
```

### L-2 Constraints

- Document identifiers should be unique within a model registry.
- Namespace URIs should be stable and versioned by project convention.
- Field names should be unique within an entity.
- The default transport expects an HTTP endpoint and exchanges JSON payloads.
