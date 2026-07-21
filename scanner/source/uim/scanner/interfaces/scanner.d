/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scanner.interfaces.scanner;

@safe:

enum DSymbolKind : ubyte {
  unknown = 0,
  class_ = 1,
  struct_ = 2,
  interface_ = 3,
  enum_ = 4,
  union_ = 5,
  template_ = 6,
  function_ = 7,
  alias_ = 8,
  mixinTemplate = 9
}

struct DImportEntry {
  string moduleName;
  bool isStatic;
  bool isPublic;
}

struct DSymbolEntry {
  DSymbolKind kind;
  string name;
  string signature;
  size_t line;
}

struct DScanOptions {
  bool includeFunctions = true;
  bool includePrivate = true;
}

struct DScanResult {
  string filePath;
  string moduleName;
  DImportEntry[] imports;
  DSymbolEntry[] symbols;
  size_t lineCount;
  size_t byteCount;
  bool hasUnitTests;
}

struct DDirectoryScanResult {
  string rootPath;
  DScanResult[] files;
  size_t fileCount;
  size_t symbolCount;
}

alias DScanResultHandler = void delegate(DScanResult result) @safe;

interface IDCodeScannerService {
  DScanResult scanSource(string source, string filePath = "", DScanOptions options = DScanOptions.init);
  DScanResult scanFile(string filePath, DScanOptions options = DScanOptions.init);
  DDirectoryScanResult scanDirectory(string rootPath, bool recursive = true, DScanOptions options = DScanOptions.init);
  bool scanSourceAsync(string source, DScanResultHandler handler, string filePath = "", DScanOptions options = DScanOptions.init);
}
