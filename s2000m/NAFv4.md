/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-S2000M

This document maps `uim-s2000m` capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM S2000M Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | S2000M material management exchanges |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| S2000M | International specification for material management (S-Series) |
| Issue 8.0 | April 2025 issue in the S-Series 2025 block release |
| CDM | Common Data Model used for S-Series harmonization |
| XSD | XML Schema Definition for integrity and compliance validation |
| EAP | Enterprise Architect model exchange file format |
| XMI | Tool-neutral UML model interchange format |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
S2000M Data Exchange Support
|- Message Metadata Parsing
|  |- XML root extraction
|  |- transaction code extraction
|  |- issue detection
|- Classification
|  |- chapter inference from transaction code
|  |- issue alignment checks
|- Service Orchestration
|  |- synchronous parsing API
|  |- asynchronous parsing callback via vibe.d tasks
|- Reference Artifacts
   |- Issue 8.0 document links
   |- XSD schema references
   |- EAP/XMI data model references
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Async parsing callback | vibe.d `runTask` |
| XML metadata extraction | D regex/string modules |
| Architecture references | Official S2000M downloads metadata |
| Domain mapping | S2000M issue and chapter semantics |

## OV - Operational View

### OV-1 Operational Concept

1. Application receives or produces an S2000M XML payload.
2. Application calls `S2000MService.parseXml`.
3. Service extracts root element, transaction code, and issue marker.
4. Service classifies the message into a chapter domain.
5. Application validates expected issue compatibility.
6. Application can request official artifact references for governance workflows.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Receive XML payload | XML text | candidate S2000M message |
| 2 | Parse metadata | XML text | root, transaction code, issue |
| 3 | Infer chapter | transaction code | chapter enum |
| 4 | Validate issue | document + expected issue | valid/invalid decision |
| 5 | Resolve references | none | official S2000M artifact links |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - ERP/MRO integration     |
| - data exchange services  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.s2000m               |
| - interfaces              |
| - models                  |
| - helpers                 |
| - service                 |
| - download catalog        |
+-------------+-------------+
              |
              v
+---------------------------+
| Runtime/Foundation        |
| - vibe.d task scheduler   |
| - D stdlib parsing        |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.s2000m.interfaces.document` | S2000M contracts, enums, artifact struct |
| `uim.s2000m.models.document` | Concrete parsed S2000M document model |
| `uim.s2000m.helpers.xml` | XML metadata extraction and inference helpers |
| `uim.s2000m.service` | S2000M parse/validate orchestration |
| `uim.s2000m.catalog` | Official S2000M download artifact references |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| S2000M | Issue 8.0 reference | material management exchange context |
| XML + XSD | S2000M provided schemas | exchange contract and validation support |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async runtime helper usage |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Metadata parser | Implemented | Root/transaction/issue extraction |
| Chapter inference | Implemented | Transaction-based chapter classification |
| Issue validation | Implemented | Expected issue matching logic |
| XSD validation integration | Planned | Optional strict schema validation pipeline |
| Process-level mappers | Planned | Extended chapter transaction mapping sets |

## L - Logical Model

### L-1 Logical Data Model

```text
S2000MDocument
  |- rawXml: string
  |- rootElement: string
  |- transactionCode: string
  |- chapter: S2000MChapter
  |- issue: S2000MIssue

S2000MDownloadArtifact
  |- title: string
  |- url: string
  |- description: string
```

### L-2 Constraints

- `isValid` requires non-empty XML and root element.
- Unknown or missing issue markers are treated as `legacy`.
- Chapter inference is heuristic and should be complemented by organization-specific process mapping where needed.
- Official artifact URLs should be periodically reviewed against the S-Series download page.