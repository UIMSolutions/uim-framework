/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scanner.service;

import std.algorithm.searching : countUntil, endsWith, startsWith;
import std.array : split;
import std.file : SpanMode, dirEntries, exists, isFile, readText;
import std.path : buildNormalizedPath, extension;
import std.string : strip;

import vibe.d : runTask;

import uim.scanner;

mixin(ShowModule!());

@safe:

private string scannerReadTextTrusted(string filePath) @trusted {
  return readText(filePath);
}

private string[] scannerListDlangFilesTrusted(string rootPath, bool recursive) @trusted {
  string[] files;
  auto mode = recursive ? SpanMode.depth : SpanMode.shallow;

  foreach (entry; dirEntries(rootPath, "*.d", mode)) {
    if (entry.isFile) {
      files ~= buildNormalizedPath(entry.name);
    }
  }

  return files;
}

DScanResult scannerScanSource(string source, string filePath = "", DScanOptions options = DScanOptions.init) {
  DScanResult result;
  result.filePath = filePath;
  result.byteCount = source.length;
  result.hasUnitTests = source.countUntil("unittest") >= 0;

  auto lines = source.split("\n");
  result.lineCount = lines.length;

  foreach (idx, rawLine; lines) {
    auto line = rawLine.strip();
    if (line.length == 0) {
      continue;
    }

    if (line.startsWith("module ")) {
      auto mod = line[7 .. $].strip();
      if (mod.endsWith(";")) {
        mod = mod[0 .. $ - 1].strip();
      }
      result.moduleName = mod;
      continue;
    }

    auto importEntry = scannerParseImportLine(line);
    if (importEntry.moduleName.length > 0) {
      result.imports ~= importEntry;
      continue;
    }

    auto symbol = scannerParseDeclaration(line, idx + 1);
    if (symbol.kind != DSymbolKind.unknown) {
      if (symbol.kind == DSymbolKind.function_ && !options.includeFunctions) {
        continue;
      }

      result.symbols ~= symbol;
    }
  }

  return result;
}

DScanResult scannerScanFile(string filePath, DScanOptions options = DScanOptions.init) {
  if (!exists(filePath) || !isFile(filePath) || extension(filePath) != ".d") {
    return DScanResult.init;
  }

  auto source = scannerReadTextTrusted(filePath);
  return scannerScanSource(source, filePath, options);
}

DDirectoryScanResult scannerScanDirectory(string rootPath, bool recursive = true, DScanOptions options = DScanOptions.init) {
  DDirectoryScanResult result;
  result.rootPath = rootPath;

  if (!exists(rootPath)) {
    return result;
  }

  auto files = scannerListDlangFilesTrusted(rootPath, recursive);
  foreach (filePath; files) {
    auto scan = scannerScanFile(filePath, options);
    if (scan.filePath.length == 0) {
      continue;
    }

    result.files ~= scan;
    result.fileCount++;
    result.symbolCount += scan.symbols.length;
  }

  return result;
}

bool scannerScanSourceAsync(string source, DScanResultHandler handler, string filePath = "", DScanOptions options = DScanOptions.init) {
  if (handler is null) {
    return false;
  }

  auto localSource = source;
  auto localHandler = handler;
  auto localFilePath = filePath;
  auto localOptions = options;

  (() @trusted {
    runTask(() nothrow {
      try {
        localHandler(scannerScanSource(localSource, localFilePath, localOptions));
      } catch (Exception) {
      }
    });
  })();

  return true;
}

unittest {
  auto source = "module uim.example;\nimport std.array;\ninterface IThing {}\nclass Impl : IThing {}\n";
  auto result = scannerScanSource(source, "x.d");

  assert(result.moduleName == "uim.example");
  assert(result.imports.length == 1);
  assert(result.symbols.length >= 2);
}
