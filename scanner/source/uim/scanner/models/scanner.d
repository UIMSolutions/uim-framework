/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scanner.models.scanner;

import std.algorithm.searching : countUntil;

import uim.scanner;

mixin(ShowModule!());

@safe:

class UIMDCodeScannerService : UIMObject, IDCodeScannerService {
  DScanResult scanSource(string source, string filePath = "", DScanOptions options = DScanOptions.init) {
    return scannerScanSource(source, filePath, options);
  }

  DScanResult scanFile(string filePath, DScanOptions options = DScanOptions.init) {
    return scannerScanFile(filePath, options);
  }

  DDirectoryScanResult scanDirectory(string rootPath, bool recursive = true, DScanOptions options = DScanOptions.init) {
    return scannerScanDirectory(rootPath, recursive, options);
  }

  string scanSourceAsJson(string source, string filePath = "", DScanOptions options = DScanOptions.init) {
    return scannerScanSourceAsJson(source, filePath, options);
  }

  string scanFileAsJson(string filePath, DScanOptions options = DScanOptions.init) {
    return scannerScanFileAsJson(filePath, options);
  }

  string scanDirectoryAsJson(string rootPath, bool recursive = true, DScanOptions options = DScanOptions.init) {
    return scannerScanDirectoryAsJson(rootPath, recursive, options);
  }

  string scanSourceAsPrettyJson(string source, string filePath = "", DScanOptions options = DScanOptions.init) {
    return scannerScanSourceAsPrettyJson(source, filePath, options);
  }

  string scanFileAsPrettyJson(string filePath, DScanOptions options = DScanOptions.init) {
    return scannerScanFileAsPrettyJson(filePath, options);
  }

  string scanDirectoryAsPrettyJson(string rootPath, bool recursive = true, DScanOptions options = DScanOptions.init) {
    return scannerScanDirectoryAsPrettyJson(rootPath, recursive, options);
  }

  bool scanSourceAsync(string source, DScanResultHandler handler, string filePath = "", DScanOptions options = DScanOptions.init) {
    return scannerScanSourceAsync(source, handler, filePath, options);
  }
}

IDCodeScannerService DCodeScannerService() {
  return new UIMDCodeScannerService();
}

unittest {
  auto scanner = DCodeScannerService();
  auto code = "module sample.test;\nimport std.string;\nclass Demo {}\nbool validate(string x) { return x.length > 0; }\n";

  auto result = scanner.scanSource(code, "sample.d");
  assert(result.moduleName == "sample.test");
  assert(result.imports.length == 1);
  assert(result.symbols.length >= 2);

  auto json = scanner.scanSourceAsJson(code, "sample.d");
  assert(json.countUntil("\"moduleName\":\"sample.test\"") >= 0);

  auto pretty = scanner.scanSourceAsPrettyJson(code, "sample.d");
  assert(pretty.countUntil("\n") >= 0);
}
