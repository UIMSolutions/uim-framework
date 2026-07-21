/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scanner.helpers.codec;

import std.array : split;
import std.algorithm.searching : canFind, countUntil, endsWith, startsWith;
import std.string : strip;

import uim.scanner.interfaces.scanner;

@safe:

string scannerStripLineComment(string line) {
  auto idx = line.countUntil("//");
  if (idx >= 0) {
    return line[0 .. cast(size_t) idx].strip();
  }

  return line.strip();
}

DImportEntry scannerParseImportLine(string line) {
  DImportEntry entry;

  auto clean = scannerStripLineComment(line);
  if (clean.length == 0) {
    return entry;
  }

  if (clean.startsWith("public import ")) {
    entry.isPublic = true;
    clean = clean[7 .. $].strip();
  }

  if (clean.startsWith("static import ")) {
    entry.isStatic = true;
    clean = clean[7 .. $].strip();
  }

  if (!clean.startsWith("import ")) {
    return entry;
  }

  clean = clean[7 .. $].strip();
  if (clean.endsWith(";")) {
    clean = clean[0 .. $ - 1].strip();
  }

  auto comma = clean.countUntil(",");
  if (comma >= 0) {
    clean = clean[0 .. cast(size_t) comma].strip();
  }

  auto colon = clean.countUntil(":");
  if (colon >= 0) {
    clean = clean[0 .. cast(size_t) colon].strip();
  }

  entry.moduleName = clean;
  return entry;
}

DSymbolEntry scannerParseDeclaration(string line, size_t lineNumber) {
  DSymbolEntry symbol;
  auto clean = scannerStripLineComment(line);

  if (clean.length == 0) {
    return symbol;
  }

  if (clean.startsWith("class ")) {
    symbol.kind = DSymbolKind.class_;
    symbol.name = scannerExtractToken(clean[6 .. $]);
  } else if (clean.startsWith("struct ")) {
    symbol.kind = DSymbolKind.struct_;
    symbol.name = scannerExtractToken(clean[7 .. $]);
  } else if (clean.startsWith("interface ")) {
    symbol.kind = DSymbolKind.interface_;
    symbol.name = scannerExtractToken(clean[10 .. $]);
  } else if (clean.startsWith("enum ")) {
    symbol.kind = DSymbolKind.enum_;
    symbol.name = scannerExtractToken(clean[5 .. $]);
  } else if (clean.startsWith("union ")) {
    symbol.kind = DSymbolKind.union_;
    symbol.name = scannerExtractToken(clean[6 .. $]);
  } else if (clean.startsWith("template ")) {
    symbol.kind = DSymbolKind.template_;
    symbol.name = scannerExtractToken(clean[9 .. $]);
  } else if (clean.startsWith("alias ")) {
    symbol.kind = DSymbolKind.alias_;
    symbol.name = scannerExtractAliasName(clean);
  } else if (clean.startsWith("mixin template ")) {
    symbol.kind = DSymbolKind.mixinTemplate;
    symbol.name = scannerExtractToken(clean[15 .. $]);
  } else if (scannerLooksLikeFunction(clean)) {
    symbol.kind = DSymbolKind.function_;
    symbol.name = scannerExtractFunctionName(clean);
    symbol.signature = clean;
  }

  if (symbol.kind != DSymbolKind.unknown) {
    symbol.line = lineNumber;
  }

  return symbol;
}

bool scannerLooksLikeFunction(string line) {
  auto clean = line.strip();
  if (clean.length == 0 || !clean.canFind("(") || !clean.canFind(")")) {
    return false;
  }

  if (clean.startsWith("if ") || clean.startsWith("for ") || clean.startsWith("foreach ") || clean.startsWith("while ") || clean.startsWith("switch ")) {
    return false;
  }

  return clean.endsWith("{") || clean.endsWith(";") || clean.canFind("=>") || clean.canFind("{");
}

string scannerExtractFunctionName(string line) {
  auto open = line.countUntil("(");
  if (open <= 0) {
    return "";
  }

  auto left = line[0 .. cast(size_t) open].strip();
  auto token = scannerExtractLastToken(left);
  if (token == "this" || token == "~this" || token == "new") {
    return token;
  }

  return token;
}

string scannerExtractAliasName(string line) {
  auto clean = line;
  if (clean.endsWith(";")) {
    clean = clean[0 .. $ - 1];
  }

  auto eq = clean.countUntil("=");
  if (eq < 0) {
    return "";
  }

  auto left = clean[6 .. cast(size_t) eq].strip();
  return scannerExtractToken(left);
}

string scannerExtractToken(string value) {
  auto clean = value.strip();
  foreach (idx, ch; clean) {
    if (ch == ' ' || ch == '{' || ch == '(' || ch == ':' || ch == ';') {
      return clean[0 .. idx].strip();
    }
  }

  return clean;
}

string scannerExtractLastToken(string value) {
  auto clean = value.strip();
  if (clean.length == 0) {
    return "";
  }

  for (size_t i = clean.length; i > 0; --i) {
    immutable ch = clean[i - 1];
    if (ch == ' ' || ch == '*' || ch == '&' || ch == '!' || ch == '.') {
      return clean[i .. $].strip();
    }
  }

  return clean;
}

unittest {
  auto i = scannerParseImportLine("public import std.string : split, join;");
  assert(i.isPublic);
  assert(i.moduleName == "std.string");

  auto c = scannerParseDeclaration("class DemoService {", 12);
  assert(c.kind == DSymbolKind.class_);
  assert(c.name == "DemoService");

  auto f = scannerParseDeclaration("bool validate(string value) {", 33);
  assert(f.kind == DSymbolKind.function_);
  assert(f.name == "validate");
}
