/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scanner.helpers.json;

import std.array : appender;
import std.algorithm.searching : canFind;
import std.conv : to;
import std.string : replace;

import uim.scanner.interfaces.scanner;

@safe:

private string scannerJsonEscape(string value) {
  return value
    .replace("\\", "\\\\")
    .replace("\"", "\\\"")
    .replace("\b", "\\b")
    .replace("\f", "\\f")
    .replace("\n", "\\n")
    .replace("\r", "\\r")
    .replace("\t", "\\t");
}

private string scannerKindToString(DSymbolKind kind) {
  final switch (kind) {
    case DSymbolKind.unknown: return "unknown";
    case DSymbolKind.class_: return "class";
    case DSymbolKind.struct_: return "struct";
    case DSymbolKind.interface_: return "interface";
    case DSymbolKind.enum_: return "enum";
    case DSymbolKind.union_: return "union";
    case DSymbolKind.template_: return "template";
    case DSymbolKind.function_: return "function";
    case DSymbolKind.alias_: return "alias";
    case DSymbolKind.mixinTemplate: return "mixinTemplate";
  }
}

private string scannerIndent(size_t level) {
  string indentText;
  foreach (_; 0 .. level) {
    indentText ~= "  ";
  }
  return indentText;
}

string scannerPrettyPrintJson(string compactJson) {
  auto src = compactJson;
  auto buffer = appender!string();
  bool inString;
  bool escaped;
  size_t indent;

  foreach (ch; src) {
    if (inString) {
      buffer.put(ch);
      if (escaped) {
        escaped = false;
      } else if (ch == '\\') {
        escaped = true;
      } else if (ch == '"') {
        inString = false;
      }
      continue;
    }

    switch (ch) {
      case ' ': case '\t': case '\n': case '\r':
        break;
      case '"':
        inString = true;
        buffer.put(ch);
        break;
      case '{': case '[':
        buffer.put(ch);
        buffer.put('\n');
        indent++;
        buffer.put(scannerIndent(indent));
        break;
      case '}': case ']':
        buffer.put('\n');
        if (indent > 0) {
          indent--;
        }
        buffer.put(scannerIndent(indent));
        buffer.put(ch);
        break;
      case ',':
        buffer.put(ch);
        buffer.put('\n');
        buffer.put(scannerIndent(indent));
        break;
      case ':':
        buffer.put(": ");
        break;
      default:
        buffer.put(ch);
        break;
    }
  }

  return buffer.data;
}

string scannerResultToJson(DScanResult result) {
  auto buffer = appender!string();
  buffer.put("{");
  buffer.put("\"filePath\":\"");
  buffer.put(scannerJsonEscape(result.filePath));
  buffer.put("\",");
  buffer.put("\"moduleName\":\"");
  buffer.put(scannerJsonEscape(result.moduleName));
  buffer.put("\",");
  buffer.put("\"lineCount\":");
  buffer.put(result.lineCount.to!string);
  buffer.put(",");
  buffer.put("\"byteCount\":");
  buffer.put(result.byteCount.to!string);
  buffer.put(",");
  buffer.put("\"hasUnitTests\":");
  buffer.put(result.hasUnitTests ? "true" : "false");
  buffer.put(",");

  buffer.put("\"imports\":[");
  foreach (idx, imp; result.imports) {
    if (idx > 0) {
      buffer.put(",");
    }

    buffer.put("{");
    buffer.put("\"moduleName\":\"");
    buffer.put(scannerJsonEscape(imp.moduleName));
    buffer.put("\",");
    buffer.put("\"isStatic\":");
    buffer.put(imp.isStatic ? "true" : "false");
    buffer.put(",");
    buffer.put("\"isPublic\":");
    buffer.put(imp.isPublic ? "true" : "false");
    buffer.put("}");
  }
  buffer.put("],");

  buffer.put("\"symbols\":[");
  foreach (idx, symbol; result.symbols) {
    if (idx > 0) {
      buffer.put(",");
    }

    buffer.put("{");
    buffer.put("\"kind\":\"");
    buffer.put(scannerKindToString(symbol.kind));
    buffer.put("\",");
    buffer.put("\"name\":\"");
    buffer.put(scannerJsonEscape(symbol.name));
    buffer.put("\",");
    buffer.put("\"signature\":\"");
    buffer.put(scannerJsonEscape(symbol.signature));
    buffer.put("\",");
    buffer.put("\"line\":");
    buffer.put(symbol.line.to!string);
    buffer.put("}");
  }
  buffer.put("]");
  buffer.put("}");

  return buffer.data;
}

string scannerDirectoryResultToJson(DDirectoryScanResult result) {
  auto buffer = appender!string();
  buffer.put("{");
  buffer.put("\"rootPath\":\"");
  buffer.put(scannerJsonEscape(result.rootPath));
  buffer.put("\",");
  buffer.put("\"fileCount\":");
  buffer.put(result.fileCount.to!string);
  buffer.put(",");
  buffer.put("\"symbolCount\":");
  buffer.put(result.symbolCount.to!string);
  buffer.put(",");
  buffer.put("\"files\":[");

  foreach (idx, fileResult; result.files) {
    if (idx > 0) {
      buffer.put(",");
    }

    buffer.put(scannerResultToJson(fileResult));
  }

  buffer.put("]}");
  return buffer.data;
}

string scannerResultToPrettyJson(DScanResult result) {
  return scannerPrettyPrintJson(scannerResultToJson(result));
}

string scannerDirectoryResultToPrettyJson(DDirectoryScanResult result) {
  return scannerPrettyPrintJson(scannerDirectoryResultToJson(result));
}

unittest {
  DScanResult result;
  result.filePath = "demo.d";
  result.moduleName = "demo";
  result.lineCount = 3;
  result.byteCount = 42;

  DSymbolEntry s;
  s.kind = DSymbolKind.class_;
  s.name = "Demo";
  result.symbols ~= s;

  auto json = scannerResultToJson(result);
  assert(json.canFind("\"moduleName\":\"demo\""));
  assert(json.canFind("\"symbols\""));

  auto pretty = scannerResultToPrettyJson(result);
  assert(pretty.canFind("\n"));
}
