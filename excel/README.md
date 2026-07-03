# Library 📚 uim-excel

Updated on 3. June 2026

A D and vibe.d based Microsoft Excel helper library for the UIM framework.

## Features

- Read and write Excel SpreadsheetML (Excel 2003 XML)
- Read and write CSV (single-sheet workflow)
- Workbook, sheet, and cell models
- Sync and async APIs (via vibe.d `runTask`)
- Strict mode to enforce row/column limits

## Installation

Add this package to your `dub.sdl`:

```sdl
dependency "uim-framework:excel" version="~>1.0.0"
```

## Quick Start

```d
import uim.excel;
import uim.excel.interfaces : ExcelConfig, ExcelFileFormat;

auto service = ExcelService();

ExcelConfig cfg;
cfg.profileName = "default";
cfg.maxRows = 100_000;
cfg.maxColumns = 1_000;
cfg.strictMode = true;

assert(service.configure(cfg));

auto workbook = service.createWorkbook("Sales", "Sheet1");
assert(service.setCell(workbook, "Sheet1", 1, 1, "Region"));
assert(service.setCell(workbook, "Sheet1", 1, 2, "Revenue"));
assert(service.setCell(workbook, "Sheet1", 2, 1, "EU"));
assert(service.setCell(workbook, "Sheet1", 2, 2, "1200"));

assert(service.saveWorkbook(workbook, "sales.xml", ExcelFileFormat.spreadsheetML));
```

## API Overview

### Main Interface

- `IExcelService.configure` - configure limits and strict mode
- `IExcelService.createWorkbook` - create a workbook with first sheet
- `IExcelService.addSheet` - append a sheet if it does not exist
- `IExcelService.setCell` - set or overwrite one cell
- `IExcelService.getCell` - read one cell value
- `IExcelService.saveWorkbook` - save as SpreadsheetML or CSV
- `IExcelService.loadWorkbook` - load from SpreadsheetML or CSV
- `IExcelService.saveWorkbookAsync` - async save callback
- `IExcelService.loadWorkbookAsync` - async load callback

### Formats

- `ExcelFileFormat.spreadsheetML`: Excel XML format (`.xml`)
- `ExcelFileFormat.csv`: CSV export/import for one selected sheet

## Notes and Limits

- `.xlsx` (OOXML ZIP containers) is not implemented yet.
- SpreadsheetML support is intentionally lightweight and focused on tabular data.
- CSV export uses the first sheet unless a sheet name is passed to helper APIs.

## Testing

Run tests from the package directory:

```bash
cd excel
dub test
```
