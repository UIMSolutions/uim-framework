# NAF v4 Architecture - UIM-SCANNER

This document maps uim-scanner capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM Scanner Library |
| Version | 26.x |
| Date | 21 Jul 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | D source scanning and metadata extraction |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| Scan Result | Structured output with module/import/symbol metadata |
| Symbol Entry | Declaration metadata for a D type/function/alias |
| Directory Scan | Aggregate result for multiple `.d` files under a root |
| Async Scan | Non-blocking scan callback scheduled through runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
D Source Scan Capability
|- Source Parsing
|  |- module declaration extraction
|  |- import statement extraction
|- Declaration Detection
|  |- type declarations (class/struct/interface/enum/union/template)
|  |- function-like declaration detection
|  |- alias and mixin-template detection
|- File and Directory Scanning
|  |- single-file scan from path
|  |- recursive folder scan for .d files
|- Async Processing
   |- callback-based source scanning with vibe.d runTask
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async scan callback | vibe.d runTask |
| File and directory scanning | std.file |
| Declaration heuristics | helper parser functions |
| Service contracts | typed interfaces and result DTOs |

## OV - Operational View

### OV-1 Operational Concept

1. Application submits source text or file path.
2. Scanner identifies module and imports.
3. Scanner extracts top-level declaration metadata.
4. Scanner returns typed scan result.
5. Optional async call dispatches result via callback.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Select scan mode | source or file path | scan context |
| 2 | Parse metadata | text lines | module/import list |
| 3 | Parse declarations | text lines | symbol list |
| 4 | Aggregate file scans | directory path | DDirectoryScanResult |
| 5 | Dispatch callback | async handler | non-blocking result delivery |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - tooling, analysis flow  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.scanner               |
| - interfaces              |
| - models/service          |
| - parser helpers          |
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
| uim.scanner.interfaces.scanner | scanner contracts and result structures |
| uim.scanner.helpers.codec | import/declaration parsing helpers |
| uim.scanner.service | scan orchestration for source/file/directory |
| uim.scanner.models.scanner | service implementation export |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| std.file | druntime/phobos | file and directory traversal |
| regex/string utilities | phobos | lightweight parse heuristics |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Source scanner DTO model | Implemented | module/import/symbol result model |
| Line-oriented parser helpers | Implemented | declaration and import extraction |
| Directory scanning | Implemented | recursive `.d` scan aggregation |
| Async API | Implemented | callback-based source scan |
| Full AST parser integration | Planned | grammar-accurate parse tree extraction |
| Semantic reference resolution | Planned | symbol table and cross-file linking |

## L - Logical Model

### L-1 Logical Data Model

```text
DScanResult
  |- filePath: string
  |- moduleName: string
  |- imports: DImportEntry[]
  |- symbols: DSymbolEntry[]
  |- lineCount: size_t
  |- byteCount: size_t
  |- hasUnitTests: bool

DDirectoryScanResult
  |- rootPath: string
  |- files: DScanResult[]
  |- fileCount: size_t
  |- symbolCount: size_t
```

### L-2 Constraints

- Scanner behavior is heuristic and optimized for speed, not full compiler-grade parsing.
- Function detection is line-oriented and best-effort.
- Non-D files are excluded from file and directory scans.
