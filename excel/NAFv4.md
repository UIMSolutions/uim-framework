# NAF v4 Architecture - UIM-EXCEL

This document maps uim-excel capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM Excel Library |
| Version | 26.x |
| Date | 3 June 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Microsoft Excel compatible workbook processing |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| Workbook | Container holding one or more sheets |
| Sheet | Named table with sparse cell values |
| Cell | Row-column addressed value with optional formula |
| SpreadsheetML | Excel 2003 XML format used for interchange |
| Strict Mode | Service mode enforcing row and column limits |
| Async Operation | Non-blocking save/load via runTask callback |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
Excel Integration Capability
|- Workbook Management
|  |- create workbook
|  |- add sheets
|- Cell Operations
|  |- set cell values
|  |- read cell values
|- File Interchange
|  |- SpreadsheetML import/export
|  |- CSV import/export
|- Runtime Controls
|  |- row and column limits
|  |- strict mode checks
|- Async Processing
   |- async save callback
   |- async load callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| SpreadsheetML transform | XML generation and regex-based parsing helpers |
| CSV transform | CSV escape/parser helpers |
| Cell model management | workbook/sheet/cell helper functions |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures excel service limits and strict mode.
2. Application creates or loads a workbook.
3. Application writes and reads cells in target sheets.
4. Service persists workbook to SpreadsheetML or CSV.
5. Async operations provide callback-based completion for save/load.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | ExcelConfig | ready state |
| 2 | Create workbook | title + firstSheet | ExcelWorkbook |
| 3 | Update cells | sheet + row + column + value | mutated workbook |
| 4 | Persist workbook | workbook + format + path | file |
| 5 | Load workbook | path + format | ExcelWorkbook |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+------------------------------+
| Application Layer            |
| - ETL jobs, reporting, APIs  |
+--------------+---------------+
               |
               v
+------------------------------+
| uim.excel                    |
| - interfaces                 |
| - models                     |
| - helpers (SpreadsheetML/CSV)|
| - service orchestration      |
+--------------+---------------+
               |
               v
+------------------------------+
| vibe.d runtime               |
| - runTask callback scheduling|
+------------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.excel.interfaces.client | service contracts and workbook types |
| uim.excel.models.client | workbook/sheet/cell mutation helpers |
| uim.excel.helpers.spreadsheetml | SpreadsheetML and CSV read/write helpers |
| uim.excel.service | orchestration, limit checks, async operations |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| SpreadsheetML | Excel 2003 XML | workbook interchange |
| CSV | RFC 4180 subset | simple single-sheet interchange |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed workbook API | Implemented | workbook, sheet, cell contracts |
| SpreadsheetML support | Implemented | XML export and import for tabular data |
| CSV support | Implemented | helper-based import and export |
| Async service API | Implemented | callback-based save/load |
| XLSX OOXML support | Planned | ZIP/XML package read and write |

## L - Logical Model

### L-1 Logical Data Model

```text
ExcelConfig
  |- profileName: string
  |- strictMode: bool
  |- maxRows: size_t
  |- maxColumns: size_t
  |- preserveEmptyCells: bool

ExcelWorkbook
  |- title: string
  |- author: string
  |- sheets: ExcelSheet[]

ExcelSheet
  |- name: string
  |- cells: ExcelCell[]
  |- maxRow: size_t
  |- maxColumn: size_t

ExcelCell
  |- row: size_t
  |- column: size_t
  |- value: string
  |- formula: string
```

### L-2 Constraints

- Cell coordinates are 1-based and must be greater than zero.
- Strict mode enforces configured row and column limits.
- CSV operations target a single sheet at a time.
- SpreadsheetML parser is optimized for flat tabular worksheets.
