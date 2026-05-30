# NAF v4 Architecture - UIM-SOAP

This document maps uim-soap capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM SOAP Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | SOAP envelope composition, parsing, and call orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| SOAP Service | Service that orchestrates build, parse, and call workflows |
| SOAP Envelope | XML envelope containing optional header and body |
| SOAP Action | Operation indicator for SOAP endpoint routing |
| In-memory Provider | Default provider that returns success without transport |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
SOAP Integration Capability
|- Endpoint Configuration
|  |- endpoint and SOAP action setup
|  |- SOAP 1.1 / 1.2 selection
|- Envelope Processing
|  |- build SOAP envelope from operation/body/headers
|  |- parse SOAP payload into typed envelope model
|- Call Orchestration
|  |- synchronous call path
|  |- provider-injected transport path
|- Async Processing
   |- async parse callback
   |- async call callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| Envelope conversion | codec helper functions |
| Default integration mode | in-memory provider behavior |
| Real SOAP transport | injected provider delegates |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures SOAP endpoint and action context.
2. Service builds SOAP envelope payload from operation/body/header input.
3. Service parses SOAP payload into typed envelope output.
4. Service executes call orchestration and returns SOAP result.
5. Async APIs expose non-blocking parse/call paths.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | SOAPConfig | ready state |
| 2 | Build envelope | operation + body + headers | SOAPEnvelope |
| 3 | Parse envelope | SOAP XML payload | SOAPEnvelope |
| 4 | Call envelope | SOAPEnvelope | SOAPResult |
| 5 | Async execution | payload or envelope + handler | callback result |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - SOAP business workflows |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.soap                  |
| - interfaces              |
| - models                  |
| - envelope helpers        |
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
| uim.soap.interfaces.client | SOAP contracts and value types |
| uim.soap.models.client | result and empty-envelope helper factories |
| uim.soap.helpers.codec | envelope build and parse helpers |
| uim.soap.service | build/parse/call orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| SOAP 1.1 | W3C Note | envelope and messaging format |
| SOAP 1.2 | W3C Recommendation | envelope and processing model |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed SOAP API model | Implemented | build/parse/call contracts |
| Envelope helper functions | Implemented | XML envelope composition and extraction |
| Async operation API | Implemented | callback-based parse/call |
| In-memory provider defaults | Implemented | integration without transport |
| HTTP transport and fault mapping | Planned | send envelope over HTTP and parse SOAP faults |

## L - Logical Model

### L-1 Logical Data Model

```text
SOAPConfig
  |- endpoint: string
  |- soapAction: string
  |- soapVersion: SOAPVersion
  |- namespaceUri: string
  |- timeoutMs: uint

SOAPHeader
  |- name: string
  |- value: string

SOAPEnvelope
  |- operation: string
  |- headers: SOAPHeader[]
  |- bodyXml: string
  |- rawXml: string

SOAPResult
  |- success: bool
  |- statusCode: ushort
  |- message: string
  |- payload: string
```

### L-2 Constraints

- Service operations require configured non-empty endpoint.
- Build operation requires non-empty body XML.
- Parse operation expects SOAP envelope containing `soap:Body` for structured extraction.
- Async callback invocation is exception-isolated.
