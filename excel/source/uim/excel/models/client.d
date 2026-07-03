/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.excel.models.client;

import std.string : strip;

import uim.excel;

mixin(ShowModule!());

@safe:

ExcelOperationResult ExcelResultOk(string message = "ok") {
  ExcelOperationResult value;
  value.success = true;
  value.message = message;
  return value;
}

ExcelOperationResult ExcelResultErr(string message) {
  ExcelOperationResult value;
  value.success = false;
  value.message = message;
  return value;
}

ExcelWorkbook ExcelWorkbookCreate(string title = "", string firstSheet = "Sheet1") {
  ExcelWorkbook workbook;
  workbook.title = title;

  ExcelSheet sheet;
  auto normalizedName = firstSheet.strip();
  sheet.name = normalizedName.length > 0 ? normalizedName : "Sheet1";
  workbook.sheets ~= sheet;

  return workbook;
}

long excelFindSheetIndex(const(ExcelWorkbook) workbook, string sheetName) {
  foreach (index, sheet; workbook.sheets) {
    if (sheet.name == sheetName) {
      return cast(long) index;
    }
  }

  return -1;
}

bool excelEnsureSheet(ref ExcelWorkbook workbook, string sheetName) {
  auto normalizedName = sheetName.strip();
  if (normalizedName.length == 0) {
    return false;
  }

  if (excelFindSheetIndex(workbook, normalizedName) >= 0) {
    return true;
  }

  ExcelSheet sheet;
  sheet.name = normalizedName;
  workbook.sheets ~= sheet;
  return true;
}

bool excelSetCell(
  ref ExcelWorkbook workbook,
  string sheetName,
  size_t row,
  size_t column,
  string value,
  string formula = ""
) {
  if (row == 0 || column == 0) {
    return false;
  }

  if (!excelEnsureSheet(workbook, sheetName)) {
    return false;
  }

  const sheetIndex = excelFindSheetIndex(workbook, sheetName);
  if (sheetIndex < 0) {
    return false;
  }

  auto idx = cast(size_t) sheetIndex;
  foreach (cellIndex, ref cell; workbook.sheets[idx].cells) {
    if (cell.row == row && cell.column == column) {
      workbook.sheets[idx].cells[cellIndex].value = value;
      workbook.sheets[idx].cells[cellIndex].formula = formula;

      if (row > workbook.sheets[idx].maxRow) {
        workbook.sheets[idx].maxRow = row;
      }

      if (column > workbook.sheets[idx].maxColumn) {
        workbook.sheets[idx].maxColumn = column;
      }

      return true;
    }
  }

  ExcelCell cell;
  cell.row = row;
  cell.column = column;
  cell.value = value;
  cell.formula = formula;

  workbook.sheets[idx].cells ~= cell;

  if (row > workbook.sheets[idx].maxRow) {
    workbook.sheets[idx].maxRow = row;
  }

  if (column > workbook.sheets[idx].maxColumn) {
    workbook.sheets[idx].maxColumn = column;
  }

  return true;
}

string excelGetCell(
  const(ExcelWorkbook) workbook,
  string sheetName,
  size_t row,
  size_t column
) {
  if (row == 0 || column == 0) {
    return "";
  }

  const sheetIndex = excelFindSheetIndex(workbook, sheetName);
  if (sheetIndex < 0) {
    return "";
  }

  foreach (cell; workbook.sheets[cast(size_t) sheetIndex].cells) {
    if (cell.row == row && cell.column == column) {
      return cell.value;
    }
  }

  return "";
}

unittest {
  auto workbook = ExcelWorkbookCreate("Demo");
  assert(workbook.sheets.length == 1);
  assert(workbook.sheets[0].name == "Sheet1");

  assert(excelSetCell(workbook, "Sheet1", 1, 1, "Hello"));
  assert(excelGetCell(workbook, "Sheet1", 1, 1) == "Hello");

  assert(excelEnsureSheet(workbook, "Data"));
  assert(workbook.sheets.length == 2);
}
