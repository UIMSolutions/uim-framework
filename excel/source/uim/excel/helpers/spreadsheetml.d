/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.excel.helpers.spreadsheetml;

import std.algorithm.searching : countUntil;
import std.algorithm.sorting : sort;
import std.array : appender;
import std.conv : to;
import std.file : readText, write;
import std.regex : Captures, matchFirst, matchAll, regex;
import std.string : join, splitLines, replace;

import uim.excel.interfaces;
import uim.excel.models;

@safe:

private string excelEscapeXml(string value) {
  auto escaped = value;
  escaped = escaped.replace("&", "&amp;");
  escaped = escaped.replace("<", "&lt;");
  escaped = escaped.replace(">", "&gt;");
  escaped = escaped.replace("\"", "&quot;");
  escaped = escaped.replace("'", "&apos;");
  return escaped;
}

private string excelUnescapeXml(string value) {
  auto unescaped = value;
  unescaped = unescaped.replace("&lt;", "<");
  unescaped = unescaped.replace("&gt;", ">");
  unescaped = unescaped.replace("&quot;", "\"");
  unescaped = unescaped.replace("&apos;", "'");
  unescaped = unescaped.replace("&amp;", "&");
  return unescaped;
}

private bool excelIsNumeric(string value) {
  try {
    const converted = value.to!double;
    return converted == converted;
  } catch (Exception) {
    return false;
  }
}

private string csvEscape(string value) {
  if (countUntil(value, '"') >= 0 || countUntil(value, ',') >= 0 || countUntil(value, '\n') >= 0) {
    return "\"" ~ value.replace("\"", "\"\"") ~ "\"";
  }

  return value;
}

private string[] csvParseLine(string line) {
  string[] values;
  auto buffer = appender!string();
  bool inQuotes;

  for (size_t i = 0; i < line.length; ++i) {
    const c = line[i];

    if (c == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buffer.put('"');
        ++i;
      } else {
        inQuotes = !inQuotes;
      }
      continue;
    }

    if (!inQuotes && c == ',') {
      values ~= buffer.data;
      buffer = appender!string();
      continue;
    }

    buffer.put(c);
  }

  values ~= buffer.data;
  return values;
}

string excelWorkbookToCsv(const(ExcelWorkbook) workbook, string sheetName = "") {
  if (workbook.sheets.length == 0) {
    return "";
  }

  size_t selectedSheet = 0;
  if (sheetName.length > 0) {
    const found = excelFindSheetIndex(workbook, sheetName);
    if (found >= 0) {
      selectedSheet = cast(size_t) found;
    }
  }

  const sheet = workbook.sheets[selectedSheet];
  if (sheet.maxRow == 0 || sheet.maxColumn == 0) {
    return "";
  }

  auto lines = appender!(string[])();

  for (size_t row = 1; row <= sheet.maxRow; ++row) {
    auto rowValues = appender!(string[])();
    for (size_t col = 1; col <= sheet.maxColumn; ++col) {
      rowValues.put(csvEscape(excelGetCell(workbook, sheet.name, row, col)));
    }

    lines.put(rowValues.data.join(","));
  }

  return lines.data.join("\n") ~ "\n";
}

ExcelWorkbook excelWorkbookFromCsv(string csvContent, string sheetName = "Sheet1") {
  auto workbook = ExcelWorkbookCreate("CSV Workbook", sheetName);

  size_t row = 1;
  foreach (line; splitLines(csvContent)) {
    if (line.length == 0) {
      continue;
    }

    auto fields = csvParseLine(line);
    foreach (colIndex, value; fields) {
      excelSetCell(workbook, sheetName, row, colIndex + 1, value);
    }

    ++row;
  }

  return workbook;
}

string excelWorkbookToSpreadsheetML(const(ExcelWorkbook) workbook) {
  auto xml = appender!string();

  xml.put("<?xml version=\"1.0\"?>\n");
  xml.put("<?mso-application progid=\"Excel.Sheet\"?>\n");
  xml.put("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"\n");
  xml.put(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"\n");
  xml.put(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"\n");
  xml.put(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\">\n");

  foreach (sheet; workbook.sheets) {
    xml.put("  <Worksheet ss:Name=\"");
    xml.put(excelEscapeXml(sheet.name.length > 0 ? sheet.name : "Sheet1"));
    xml.put("\">\n");
    xml.put("    <Table>\n");

    auto orderedCells = sheet.cells.dup;
    orderedCells.sort!((a, b) {
      if (a.row == b.row) {
        return a.column < b.column;
      }
      return a.row < b.row;
    });

    size_t i = 0;
    while (i < orderedCells.length) {
      auto rowNumber = orderedCells[i].row;
      xml.put("      <Row ss:Index=\"");
      xml.put(rowNumber.to!string);
      xml.put("\">\n");

      while (i < orderedCells.length && orderedCells[i].row == rowNumber) {
        auto cell = orderedCells[i];
        xml.put("        <Cell ss:Index=\"");
        xml.put(cell.column.to!string);
        xml.put("\"");

        if (cell.formula.length > 0) {
          xml.put(" ss:Formula=\"");
          xml.put(excelEscapeXml(cell.formula));
          xml.put("\"");
        }

        xml.put("><Data ss:Type=\"");
        xml.put(excelIsNumeric(cell.value) ? "Number" : "String");
        xml.put("\">");
        xml.put(excelEscapeXml(cell.value));
        xml.put("</Data></Cell>\n");

        ++i;
      }

      xml.put("      </Row>\n");
    }

    xml.put("    </Table>\n");
    xml.put("  </Worksheet>\n");
  }

  xml.put("</Workbook>\n");
  return xml.data;
}

private size_t parseIndex(string attrs, size_t fallback) {
  auto indexMatch = matchFirst(attrs, regex(`ss:Index="(\d+)"`));
  if (indexMatch.empty) {
    return fallback;
  }

  try {
    return indexMatch.captures[1].to!size_t;
  } catch (Exception) {
    return fallback;
  }
}

private string parseFormula(string attrs) {
  auto formulaMatch = matchFirst(attrs, regex(`ss:Formula="([^"]*)"`));
  if (formulaMatch.empty) {
    return "";
  }

  return excelUnescapeXml(formulaMatch.captures[1]);
}

ExcelWorkbook excelWorkbookFromSpreadsheetML(string xmlContent) {
  ExcelWorkbook workbook;

  auto worksheetRegex = regex(`<Worksheet\b[^>]*ss:Name="([^"]+)"[^>]*>([\s\S]*?)</Worksheet>`);
  auto rowRegex = regex(`<Row\b([^>]*)>([\s\S]*?)</Row>`);
  auto cellRegex = regex(`<Cell\b([^>]*)>([\s\S]*?)</Cell>`);
  auto dataRegex = regex(`<Data\b[^>]*>([\s\S]*?)</Data>`);

  foreach (worksheetMatch; matchAll(xmlContent, worksheetRegex)) {
    ExcelSheet sheet;
    sheet.name = excelUnescapeXml(worksheetMatch.captures[1]);

    auto worksheetBody = worksheetMatch.captures[2];

    size_t currentRow = 0;
    foreach (rowMatch; matchAll(worksheetBody, rowRegex)) {
      currentRow = parseIndex(rowMatch.captures[1], currentRow + 1);
      auto rowBody = rowMatch.captures[2];

      size_t currentColumn = 0;
      foreach (cellMatch; matchAll(rowBody, cellRegex)) {
        auto attrs = cellMatch.captures[1];
        auto body = cellMatch.captures[2];

        currentColumn = parseIndex(attrs, currentColumn + 1);

        ExcelCell cell;
        cell.row = currentRow;
        cell.column = currentColumn;
        cell.formula = parseFormula(attrs);

        auto dataMatch = matchFirst(body, dataRegex);
        if (!dataMatch.empty) {
          cell.value = excelUnescapeXml(dataMatch.captures[1]);
        }

        sheet.cells ~= cell;

        if (cell.row > sheet.maxRow) {
          sheet.maxRow = cell.row;
        }

        if (cell.column > sheet.maxColumn) {
          sheet.maxColumn = cell.column;
        }
      }
    }

    workbook.sheets ~= sheet;
  }

  if (workbook.sheets.length == 0) {
    workbook = ExcelWorkbookCreate("Workbook", "Sheet1");
  }

  return workbook;
}

bool excelWriteWorkbook(
  const(ExcelWorkbook) workbook,
  string filePath,
  ExcelFileFormat format
) {
  string content;

  final switch (format) {
    case ExcelFileFormat.spreadsheetML:
      content = excelWorkbookToSpreadsheetML(workbook);
      break;
    case ExcelFileFormat.csv:
      content = excelWorkbookToCsv(workbook);
      break;
  }

  try {
    write(filePath, content);
    return true;
  } catch (Exception) {
    return false;
  }
}

ExcelWorkbook excelReadWorkbook(string filePath, ExcelFileFormat format) {
  try {
    auto content = readText(filePath);

    final switch (format) {
      case ExcelFileFormat.spreadsheetML:
        return excelWorkbookFromSpreadsheetML(content);
      case ExcelFileFormat.csv:
        return excelWorkbookFromCsv(content);
    }
  } catch (Exception) {
    return ExcelWorkbookCreate("Workbook", "Sheet1");
  }
}

unittest {
  auto workbook = ExcelWorkbookCreate("Test", "Sheet1");
  assert(excelSetCell(workbook, "Sheet1", 1, 1, "Name"));
  assert(excelSetCell(workbook, "Sheet1", 2, 1, "Alice"));
  assert(excelSetCell(workbook, "Sheet1", 2, 2, "42"));

  auto xml = excelWorkbookToSpreadsheetML(workbook);
  auto loaded = excelWorkbookFromSpreadsheetML(xml);

  assert(loaded.sheets.length == 1);
  assert(excelGetCell(loaded, "Sheet1", 2, 1) == "Alice");

  auto csv = excelWorkbookToCsv(workbook, "Sheet1");
  auto fromCsv = excelWorkbookFromCsv(csv, "Sheet1");
  assert(excelGetCell(fromCsv, "Sheet1", 2, 1) == "Alice");
}
