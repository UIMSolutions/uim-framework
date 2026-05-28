# NAF v4 Architecture - UIM-OPF

This document maps uim-opf capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM Open Logistics Foundation API Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Open Logistics Foundation API integration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| OLF | Open Logistics Foundation |
| OPF Service | Integration service handling API requests and resource storage |
| Resource | Logistics object represented via typed model and payload |
| Request Abstraction | Method + path + body + headers API call descriptor |
| Async Handler | Callback invoked through non-blocking runTask execution |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
Open Logistics API Integration
|- Resource Modeling
|  |- typed resource identity and state
|  |- metadata and payload handling
|- API Composition
|  |- HTTP method mapping
|  |- base URL and path normalization
|- Query and Retrieval
|  |- lookup by id
|  |- filtering by resource type
|- Async Processing
   |- non-blocking response callback flow
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async callbacks | vibe.d runTask |
| URL composition | OPF helper functions |
| Resource indexing | in-memory dictionary store |
| API semantics | OPF enums and interface contracts |

## OV - Operational View

### OV-1 Operational Concept

1. Application establishes OPF service connection with a base API URL.
2. Application registers or updates logistics resources.
3. Service composes API calls using method and normalized path.
4. Synchronous requests return immediate response objects.
5. Asynchronous requests dispatch responses through callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Connect endpoint | base URL | active API session |
| 2 | Upsert resource | resource model | indexed resource |
| 3 | Compose request | method + path + headers | target URL and request metadata |
| 4 | Execute request | composed request | API response object |
| 5 | Async notify | response + handler | callback execution |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - logistics workflows     |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.opf                   |
| - interfaces              |
| - models                  |
| - helper utilities        |
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
| uim.opf.interfaces.api | OPF API contracts, enums, and response struct |
| uim.opf.models.resource | Concrete logistics resource implementation |
| uim.opf.helpers.http | Method string conversion and URL/path normalization |
| uim.opf.service | Resource registry and sync/async request orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| HTTP Method Semantics | common REST pattern | API request intent mapping |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Resource model | Implemented | id/type/status/payload/metadata |
| Request abstraction | Implemented | sync and async operation helpers |
| URL helper layer | Implemented | normalized endpoint composition |
| Auth support | Planned | token and credential policies |
| Real HTTP transport | Planned | direct requestHTTP backend integration |

## L - Logical Model

### L-1 Logical Data Model

```text
IOPFResource
  |- id: string
  |- resourceType: OPFResourceType
  |- status: string
  |- payload: string
  |- metadata: string[string]

OPFApiResponse
  |- statusCode: ushort
  |- body: string
  |- headers: string[string]
```

### L-2 Constraints

* Service-level operations require an active connection.
* Resource upsert requires a valid non-empty resource id.
* Paths are normalized before URL composition.
* Async callbacks are exception-isolated.
