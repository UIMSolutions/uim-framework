/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.excel.interfaces.client;

@safe:

enum ExcelFileFormat : ubyte {
  spreadsheetML = 0,
  csv = 1
}

struct ExcelConfig {
  string profileName;
  bool strictMode;
  size_t maxRows = 1_048_576;
  size_t maxColumns = 16_384;
  bool preserveEmptyCells;
}

struct ExcelCell {
  size_t row = 1;
  size_t column = 1;
  string value;
  string formula;
  string typeHint = "String";
}

struct ExcelSheet {
  string name = "Sheet1";
  ExcelCell[] cells;
  size_t maxRow;
  size_t maxColumn;
}

struct ExcelWorkbook {
  string title;
  string author;
  ExcelSheet[] sheets;
}

struct ExcelOperationResult {
  bool success;
  string message;
}

alias ExcelWorkbookHandler = void delegate(ExcelWorkbook workbook) @safe;
alias ExcelResultHandler = void delegate(ExcelOperationResult result) @safe;

interface IExcelService {
  bool configure(ExcelConfig config);
  ExcelConfig config() const;

  ExcelWorkbook createWorkbook(string title = "", string firstSheet = "Sheet1");
  bool addSheet(ref ExcelWorkbook workbook, string sheetName);

  bool setCell(
    ref ExcelWorkbook workbook,
    string sheetName,
    size_t row,
    size_t column,
    string value,
    string formula = ""
  );

  string getCell(
    const(ExcelWorkbook) workbook,
    string sheetName,
    size_t row,
    size_t column
  ) const;

  bool saveWorkbook(
    const(ExcelWorkbook) workbook,
    string filePath,
    ExcelFileFormat format = ExcelFileFormat.spreadsheetML
  );

  ExcelWorkbook loadWorkbook(
    string filePath,
    ExcelFileFormat format = ExcelFileFormat.spreadsheetML
  );

  bool saveWorkbookAsync(
    ExcelWorkbook workbook,
    string filePath,
    ExcelFileFormat format,
    ExcelResultHandler handler
  );

  bool loadWorkbookAsync(
    string filePath,
    ExcelFileFormat format,
    ExcelWorkbookHandler handler
  );
}
