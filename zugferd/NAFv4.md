# NAF v4 Architecture - UIM-ZUGFERD

This document maps uim-zugferd capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM ZUGFeRD Library |
| Version | 26.x |
| Date | 21 Jul 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Factur-X/ZUGFeRD XML generation and PDF hybrid packaging |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| Factur-X | Franco-German e-invoice profile family aligned with EN 16931 |
| ZUGFeRD | German hybrid invoice standard (PDF + structured XML) |
| CII | Cross Industry Invoice XML syntax used for payload representation |
| Profile | Conformance level such as MINIMUM, BASIC, EN16931, EXTENDED |
| Hybrid Invoice | PDF document enriched with embedded machine-readable XML |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
ZUGFeRD Integration Capability
|- Invoice Modeling
|  |- seller and buyer business party details
|  |- invoice line and tax structures
|- XML Generation
|  |- profile-specific guideline URN selection
|  |- CII invoice XML composition
|- Hybrid PDF Packaging
|  |- XML payload embedding into PDF exchange payload
|  |- XML extraction for downstream processing
|- Async Processing
   |- callback-based non-blocking XML generation
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async workflows | vibe.d runTask |
| XML payload generation | codec helper functions |
| Profile detection | string heuristics against XML profile markers |
| Application integration | typed service interfaces |

## OV - Operational View

### OV-1 Operational Concept

1. Application constructs typed invoice data in memory.
2. Service validates structural minimum requirements.
3. Service builds Factur-X/ZUGFeRD XML payload.
4. Service embeds XML into PDF payload for hybrid exchange.
5. Service can extract XML and detect profile for verification and routing.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Build invoice model | seller/buyer/lines/taxes | IZUGFeRDInvoice |
| 2 | Validate model | IZUGFeRDInvoice | boolean |
| 3 | Generate XML | invoice + profile | CII XML string |
| 4 | Package with PDF | PDF bytes + XML | hybrid payload bytes |
| 5 | Extract and classify | hybrid payload | XML string + profile |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - ERP / billing workflow  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.zugferd               |
| - interfaces              |
| - models                  |
| - codec helpers           |
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
| uim.zugferd.interfaces.invoice | contracts, profile enum, and data structures |
| uim.zugferd.models.invoice | concrete invoice model implementation |
| uim.zugferd.helpers.codec | XML build, profile detection, PDF packaging helpers |
| uim.zugferd.service | validation and orchestration API |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| EN 16931 | current | semantic core for e-invoice payload |
| Factur-X / ZUGFeRD | 2.x family | profile and hybrid document semantics |
| UN/CEFACT CII | 16B/100 style namespace usage | XML structure representation |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed invoice domain model | Implemented | party, lines, tax, totals |
| CII XML generator | Implemented | profile URN and invoice XML build |
| Hybrid PDF payload marker strategy | Implemented | embed and extract XML for app exchange |
| Async XML generation | Implemented | callback-based orchestration |
| Full PDF/A-3 embedded-file object model | Planned | native PDF dictionary/xref object writing |
| Full CIUS/XRechnung rule validation | Planned | strict semantic/business rule engine |

## L - Logical Model

### L-1 Logical Data Model

```text
IZUGFeRDInvoice
  |- id: string
  |- issueDate: string (YYYYMMDD)
  |- currency: string (ISO 4217)
  |- seller: ZUGFeRDParty
  |- buyer: ZUGFeRDParty
  |- lines: ZUGFeRDInvoiceLine[]
  |- taxes: ZUGFeRDTax[]
  |- netAmount: double
  |- taxAmount: double
  |- grossAmount: double

ZUGFeRDProfile
  |- minimum
  |- basicWL
  |- basic
  |- en16931
  |- extended
  |- xrechnung
```

### L-2 Constraints

- A valid invoice requires identifier, issue date, currency, seller and buyer names, at least one line, and totals.
- XML generation returns empty output for invalid invoice payloads.
- Profile detection is heuristic and should be validated against upstream business profile metadata when available.
- PDF embedding in this release is exchange-oriented and not a full PDF/A-3 conformance writer.
