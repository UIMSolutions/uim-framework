# UIM-EXCEL UML Description

## Overview

The UIM-EXCEL library provides typed workbook models and a vibe.d powered service layer to read and write Microsoft Excel compatible formats (SpreadsheetML and CSV).

## Core Types

```plantuml
@startuml EXCEL_Core

enum ExcelFileFormat {
  spreadsheetML
  csv
}

struct ExcelConfig {
  + profileName: string
  + strictMode: bool
  + maxRows: size_t
  + maxColumns: size_t
  + preserveEmptyCells: bool
}

struct ExcelCell {
  + row: size_t
  + column: size_t
  + value: string
  + formula: string
  + typeHint: string
}

struct ExcelSheet {
  + name: string
  + cells: ExcelCell[]
  + maxRow: size_t
  + maxColumn: size_t
}

struct ExcelWorkbook {
  + title: string
  + author: string
  + sheets: ExcelSheet[]
}

struct ExcelOperationResult {
  + success: bool
  + message: string
}

interface IExcelService {
  + configure(config: ExcelConfig): bool
  + config(): ExcelConfig
  + createWorkbook(title: string, firstSheet: string): ExcelWorkbook
  + addSheet(workbook: ref ExcelWorkbook, sheetName: string): bool
  + setCell(workbook: ref ExcelWorkbook, sheetName: string, row: size_t, column: size_t, value: string, formula: string): bool
  + getCell(workbook: const ExcelWorkbook, sheetName: string, row: size_t, column: size_t): string
  + saveWorkbook(workbook: const ExcelWorkbook, filePath: string, format: ExcelFileFormat): bool
  + loadWorkbook(filePath: string, format: ExcelFileFormat): ExcelWorkbook
  + saveWorkbookAsync(workbook: ExcelWorkbook, filePath: string, format: ExcelFileFormat, handler: ExcelResultHandler): bool
  + loadWorkbookAsync(filePath: string, format: ExcelFileFormat, handler: ExcelWorkbookHandler): bool
}

class UIMExcelService
UIMExcelService ..|> IExcelService

@enduml
```

## Helper Layer

```plantuml
@startuml EXCEL_Helpers

class SpreadsheetMLHelpers {
  + excelWorkbookToSpreadsheetML(workbook): string
  + excelWorkbookFromSpreadsheetML(xml): ExcelWorkbook
  + excelWorkbookToCsv(workbook, sheetName): string
  + excelWorkbookFromCsv(csv, sheetName): ExcelWorkbook
  + excelWriteWorkbook(workbook, filePath, format): bool
  + excelReadWorkbook(filePath, format): ExcelWorkbook
}

class ExcelModelHelpers {
  + ExcelWorkbookCreate(title, firstSheet): ExcelWorkbook
  + excelEnsureSheet(workbook, sheetName): bool
  + excelSetCell(workbook, sheetName, row, column, value, formula): bool
  + excelGetCell(workbook, sheetName, row, column): string
}

UIMExcelService --> SpreadsheetMLHelpers : read/write formats
UIMExcelService --> ExcelModelHelpers : cell and sheet mutation

@enduml
```

## Sequence

```plantuml
@startuml EXCEL_Sequence

actor Application
participant Service as "UIMExcelService"
participant Model as "Model Helpers"
participant Helper as "SpreadsheetML Helpers"
participant Task as "vibe.d runTask"
participant Handler as "Callback"

Application -> Service: configure(config)
Application -> Service: createWorkbook("Sales", "Sheet1")
Service -> Model: ExcelWorkbookCreate
Model --> Service: workbook

Application -> Service: setCell(workbook, "Sheet1", 2, 1, "Alice", "")
Service -> Model: excelSetCell

Application -> Service: saveWorkbook(workbook, "sales.xml", spreadsheetML)
Service -> Helper: excelWriteWorkbook
Helper --> Service: bool
Service --> Application: bool

Application -> Service: loadWorkbookAsync("sales.xml", spreadsheetML, handler)
Service -> Task: runTask
Task -> Service: loadWorkbook
Service -> Helper: excelReadWorkbook
Helper --> Service: workbook
Service -> Handler: callback(workbook)

@enduml
```
