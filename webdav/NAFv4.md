# NAF v4 Architecture - UIM-WEBDAV

This document maps uim-webdav capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM WebDAV Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | WebDAV resource access and orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| WebDAV Service | Service that orchestrates WebDAV resource operations |
| Resource Listing | Collection of resources from PROPFIND/list flow |
| Resource Upload | PUT workflow for file content |
| Collection Creation | MKCOL workflow for directory resources |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
WebDAV Integration Capability
|- Endpoint Configuration
|  |- base URL and credentials
|  |- timeout and security mode
|- Resource Discovery
|  |- list resources by depth
|  |- parse PROPFIND XML metadata
|- Resource Operations
|  |- get resource content
|  |- put resource content
|  |- mkcol and delete workflows
|- Async Processing
   |- async list callback
   |- async put callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| PROPFIND parser | XML/regex helper functions |
| Default integration mode | in-memory provider behavior |
| Real server communication | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures WebDAV endpoint and credentials.
2. Service lists resources in a collection path.
3. Service supports get and put operations for resource content.
4. Service supports mkcol and delete operations.
5. Async APIs return operation results through callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | WebDAVConfig | ready-to-query state |
| 2 | List resources | path + depth | WebDAVResource[] |
| 3 | Upload content | path + bytes/content-type | WebDAVResult |
| 4 | Read/Delete resource | path | payload or result |
| 5 | Parse PROPFIND XML | multistatus payload | normalized resources |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - file and doc workflows  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.webdav                |
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
| uim.webdav.interfaces.client | WebDAV contracts and value types |
| uim.webdav.models.client | result helper factories |
| uim.webdav.helpers.parser | PROPFIND XML parsing helpers |
| uim.webdav.service | list/get/put/mkcol/remove orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| HTTP/1.1 | RFC 9112 | transport semantics |
| WebDAV | RFC 4918 | PROPFIND, MKCOL, PUT, DELETE workflows |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed WebDAV API model | Implemented | list/get/put/mkcol/delete contracts |
| PROPFIND parsing helper | Implemented | multistatus to resource mapping |
| Async operation API | Implemented | callback-based list/put methods |
| In-memory provider defaults | Implemented | integration without server |
| Full HTTP client transport | Planned | authenticated WebDAV over HTTP(S) with headers and depth control |

## L - Logical Model

### L-1 Logical Data Model

```text
WebDAVConfig
  |- baseUrl: string
  |- security: WebDAVSecurity
  |- username: string
  |- password: string

WebDAVResource
  |- href: string
  |- collection: bool
  |- contentLength: ulong
  |- contentType: string
  |- etag: string

WebDAVResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
```

### L-2 Constraints

- Service operations require a configured base URL.
- Path is mandatory for get/put/mkcol/delete flows.
- PROPFIND parsing expects DAV multistatus response blocks.
- Async callback invocation is exception-isolated.
