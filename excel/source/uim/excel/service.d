/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.excel.service;

import std.exception : assumeWontThrow;

import vibe.d : runTask;

import uim.excel;

mixin(ShowModule!());

@safe:

class UIMExcelService : UIMObject, IExcelService {
  private ExcelConfig _config;
  private bool _configured;

  bool configure(ExcelConfig config) {
    if (config.maxRows == 0 || config.maxColumns == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  ExcelConfig config() const {
    return _config;
  }

  ExcelWorkbook createWorkbook(string title = "", string firstSheet = "Sheet1") {
    return ExcelWorkbookCreate(title, firstSheet);
  }

  bool addSheet(ref ExcelWorkbook workbook, string sheetName) {
    return excelEnsureSheet(workbook, sheetName);
  }

  bool setCell(
    ref ExcelWorkbook workbook,
    string sheetName,
    size_t row,
    size_t column,
    string value,
    string formula = ""
  ) {
    if (!_configured) {
      return false;
    }

    if (row > _config.maxRows || column > _config.maxColumns) {
      return false;
    }

    return excelSetCell(workbook, sheetName, row, column, value, formula);
  }

  string getCell(
    const(ExcelWorkbook) workbook,
    string sheetName,
    size_t row,
    size_t column
  ) const {
    return excelGetCell(workbook, sheetName, row, column);
  }

  private bool withinLimits(const(ExcelWorkbook) workbook) const {
    if (!_configured) {
      return false;
    }

    foreach (sheet; workbook.sheets) {
      if (sheet.maxRow > _config.maxRows || sheet.maxColumn > _config.maxColumns) {
        return false;
      }
    }

    return true;
  }

  bool saveWorkbook(
    const(ExcelWorkbook) workbook,
    string filePath,
    ExcelFileFormat format = ExcelFileFormat.spreadsheetML
  ) {
    if (!_configured) {
      return false;
    }

    if (_config.strictMode && !withinLimits(workbook)) {
      return false;
    }

    return excelWriteWorkbook(workbook, filePath, format);
  }

  ExcelWorkbook loadWorkbook(
    string filePath,
    ExcelFileFormat format = ExcelFileFormat.spreadsheetML
  ) {
    if (!_configured) {
      return ExcelWorkbookCreate("Workbook", "Sheet1");
    }

    return excelReadWorkbook(filePath, format);
  }

  bool saveWorkbookAsync(
    ExcelWorkbook workbook,
    string filePath,
    ExcelFileFormat format,
    ExcelResultHandler handler
  ) {
    if (handler is null) {
      return false;
    }

    auto localWorkbook = workbook;
    auto localPath = filePath;
    auto localFormat = format;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          auto ok = assumeWontThrow(saveWorkbook(localWorkbook, localPath, localFormat));
          assumeWontThrow(localHandler(ok ? ExcelResultOk() : ExcelResultErr("save failed")));
        } catch (Exception) {
          assumeWontThrow(localHandler(ExcelResultErr("save failed")));
        }
      });
    })();

    return true;
  }

  bool loadWorkbookAsync(
    string filePath,
    ExcelFileFormat format,
    ExcelWorkbookHandler handler
  ) {
    if (handler is null) {
      return false;
    }

    auto localPath = filePath;
    auto localFormat = format;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          assumeWontThrow(localHandler(loadWorkbook(localPath, localFormat)));
        } catch (Exception) {
          assumeWontThrow(localHandler(ExcelWorkbookCreate("Workbook", "Sheet1")));
        }
      });
    })();

    return true;
  }
}

IExcelService ExcelService() {
  return new UIMExcelService();
}

unittest {
  import std.file : exists, remove, tempDir;
  import std.path : buildPath;

  auto service = ExcelService();

  ExcelConfig cfg;
  cfg.profileName = "default";
  cfg.maxRows = 1000;
  cfg.maxColumns = 50;
  cfg.strictMode = true;
  assert(service.configure(cfg));

  auto workbook = service.createWorkbook("Demo", "Sheet1");
  assert(service.setCell(workbook, "Sheet1", 1, 1, "Name"));
  assert(service.setCell(workbook, "Sheet1", 2, 1, "Alice"));
  assert(service.setCell(workbook, "Sheet1", 2, 2, "100"));

  auto filePath = buildPath(tempDir(), "uim-excel-test.xml");
  scope (exit) {
    if (exists(filePath)) {
      remove(filePath);
    }
  }

  assert(service.saveWorkbook(workbook, filePath, ExcelFileFormat.spreadsheetML));

  auto loaded = service.loadWorkbook(filePath, ExcelFileFormat.spreadsheetML);
  assert(service.getCell(loaded, "Sheet1", 2, 1) == "Alice");
}
