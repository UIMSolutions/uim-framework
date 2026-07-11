# NAF v4 Architecture - UIM-SARIF

This document maps uim-sarif capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM SARIF Library |
| Version | 26.x |
| Date | 10 July 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | SARIF 2.1.0 log modeling and JSON processing |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| SARIF | Static Analysis Results Interchange Format |
| Log | Top-level SARIF report document |
| Run | A single tool execution entry inside a log |
| Result | A finding emitted by static analysis |
| Location | A logical or physical place associated with a result |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
SARIF Processing
|- Log ingestion
|  |- JSON parsing
|  |- schema-oriented object mapping
|- Result modeling
|  |- findings, messages, and locations
|  |- rule metadata
|- Serialization
|  |- log to JSON output
|  |- round-trip conversion
|- Runtime integration
   |- vibe.d async parsing callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| JSON round-trip | std.json and model mapping functions |
| Async parse flow | vibe.d runTask |
| Log validation | SarifLog.isValid |
| Rule and result model | SarifToolComponent and SarifResult |

## OV - Operational View

### OV-1 Operational Concept

1. An application receives SARIF JSON from a scanner, file, or service.
2. The service parses the payload into a typed SARIF log.
3. The application validates the log and inspects results.
4. The log can be serialized back to SARIF JSON.
5. Async parsing can dispatch a parsed log through a callback.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Read payload | SARIF JSON | parse candidate |
| 2 | Decode model | JSON object tree | SarifLog |
| 3 | Validate log | SarifLog | valid or invalid |
| 4 | Inspect results | SarifLog | findings and locations |
| 5 | Emit JSON | SarifLog | SARIF text |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - CI pipelines            |
| - code scanning tools     |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.sarif                 |
| - model                   |
| - service                 |
| - JSON round-tripping     |
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
| uim.sarif.model | SARIF data structures and JSON codecs |
| uim.sarif.service | Parse, validate, stringify, async dispatch |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| SARIF | 2.1.0 | static analysis interchange model |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async runtime support |
| std.json | D standard library | JSON parsing and serialization |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Core log model | Implemented | version, runs, tool, results, and locations |
| JSON round-trip | Implemented | parse and stringify helpers |
| Async parse API | Implemented | non-blocking callback delivery |
| Full SARIF schema coverage | Planned | broaden model coverage to the full standard |

## L - Logical Model

### L-1 Logical Data Model

```text
SarifLog
  |- sarifVersion: SarifVersion
  |- runs: SarifRun[]

SarifRun
  |- tool: SarifTool
  |- results: SarifResult[]

SarifResult
  |- ruleId: string
  |- level: string
  |- kind: string
  |- message: SarifMessage
  |- locations: SarifLocation[]
```

### L-2 Constraints

* A valid log must declare SARIF 2.1.0.
* Results may carry zero or more locations.
* Rule metadata is optional but supported for practical scanner integration.
* Async parsing is exception-isolated inside the callback worker.
