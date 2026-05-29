/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.openapi.helpers.parser;

import std.regex : matchAll, matchFirst;
import std.string : strip;

import uim.openapi.interfaces.document;

@safe:

OpenAPIVersion openapiDetectVersion(string source) {
  if (!matchFirst(source, `openapi\s*[:=]\s*"?3\.1`).empty) {
    return OpenAPIVersion.v31;
  }

  if (!matchFirst(source, `openapi\s*[:=]\s*"?3\.0`).empty) {
    return OpenAPIVersion.v30;
  }

  if (!matchFirst(source, `swagger\s*[:=]\s*"?2\.0`).empty) {
    return OpenAPIVersion.v20;
  }

  return OpenAPIVersion.unknown;
}

string openapiExtractTitle(string source) {
  auto m = matchFirst(source, `title\s*[:=]\s*"([^"]+)"`);
  if (!m.empty && m.captures.length >= 2) {
    return m.captures[1];
  }

  return "";
}

string openapiExtractDocumentVersion(string source) {
  auto m = matchFirst(source, `version\s*[:=]\s*"([^"]+)"`);
  if (!m.empty && m.captures.length >= 2) {
    return m.captures[1];
  }

  return "";
}

string[] openapiExtractServers(string source) {
  string[] result;

  foreach (m; matchAll(source, `url\s*[:=]\s*"([^"]+)"`)) {
    if (m.captures.length >= 2) {
      auto value = m.captures[1].strip();
      if (value.length > 0) {
        result ~= value;
      }
    }
  }

  return result;
}

OpenAPIOperation[] openapiExtractOperations(string source) {
  OpenAPIOperation[] result;

  // Lightweight extraction for YAML/JSON-like content from paths section.
  foreach (m; matchAll(source, `(/[\w\-\./\{\}]+)\s*[:\{][\s\S]{0,160}?(get|post|put|patch|delete)\b`)) {
    if (m.captures.length >= 3) {
      OpenAPIOperation op;
      op.path = m.captures[1];
      op.method = m.captures[2];
      result ~= op;
    }
  }

  return result;
}

unittest {
  auto text = `openapi: "3.1.0"
info:
  title: "Order API"
  version: "1.0.0"
servers:
  - url: "https://api.example.org"
paths:
  /orders:
    get:
      operationId: listOrders
  /orders/{id}:
    patch:
      operationId: patchOrder`;

  assert(openapiDetectVersion(text) == OpenAPIVersion.v31);
  assert(openapiExtractTitle(text) == "Order API");
  assert(openapiExtractDocumentVersion(text) == "1.0.0");
  assert(openapiExtractServers(text).length == 1);
  assert(openapiExtractOperations(text).length >= 2);
}
