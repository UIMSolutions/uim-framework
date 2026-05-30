# NAF v4 Architecture - UIM-OPCUA

This document maps uim-opcua capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM OPC UA Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | OPC UA node access and method orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| OPC UA Service | Service that orchestrates read, write, and invoke workflows |
| NodeId | OPC UA address of a variable, object, or method |
| Attribute | OPC UA attribute identifier such as Value |
| Method Call | Invocation on an OPC UA object method node |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
OPC UA Integration Capability
|- Session Configuration
|  |- endpoint and security setup
|  |- application/session identity setup
|- Node Services
|  |- read node value and metadata
|  |- write node value with type
|- Method Services
|  |- invoke method with input args
|- Async Processing
   |- async read callback
   |- async write callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Payload conversion | codec helper functions |
| Default integration mode | in-memory provider behavior |
| Real OPC UA stack | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures endpoint, security mode, and session properties.
2. Service reads node attributes and values.
3. Service writes typed values to target nodes.
4. Service invokes OPC UA methods on object nodes.
5. Async APIs expose non-blocking read/write operations.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | OPCUAConfig | ready state |
| 2 | Read node | nodeId + attributeId | OPCUANodeRead |
| 3 | Write node | nodeId + value + dataType | OPCUAResult |
| 4 | Invoke method | methodNodeId + objectNodeId + args | OPCUAResult |
| 5 | Async execution | node/value + handler | callback result |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - industrial workflows    |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.opcua                 |
| - interfaces              |
| - models                  |
| - request/response helpers|
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
| uim.opcua.interfaces.client | OPC UA contracts and value types |
| uim.opcua.models.client | result and empty-node helper factories |
| uim.opcua.helpers.codec | request build and response parse helpers |
| uim.opcua.service | read/write/invoke orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| OPC UA | IEC 62541 | information model and service semantics |
| OPC UA Binary/TCP | UA transport profile | production transport target |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed OPC UA API model | Implemented | read/write/invoke contracts |
| Request/response helpers | Implemented | simple payload conversion |
| Async operation API | Implemented | callback-based read/write |
| In-memory provider defaults | Implemented | integration without OPC UA server |
| Full secure channel and session protocol | Planned | binary encoding, secure channel, and monitored item support |

## L - Logical Model

### L-1 Logical Data Model

```text
OPCUAConfig
  |- endpointUrl: string
  |- applicationUri: string
  |- sessionName: string
  |- securityMode: OPCUASecurityMode
  |- securityPolicyUri: string

OPCUANodeRead
  |- nodeId: string
  |- attributeId: string
  |- value: string
  |- dataType: string
  |- sourceTimestamp: long

OPCUAResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
  |- serviceResponse: string
```

### L-2 Constraints

- Service operations require configured non-empty endpoint URL.
- Read and write operations require non-empty node identifiers.
- Method invocation requires both method and object node identifiers.
- Async callback invocation is exception-isolated.
