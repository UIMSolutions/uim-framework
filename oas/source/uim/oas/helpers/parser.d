/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oas.helpers.parser;

import std.regex : matchAll, matchFirst;

import uim.oas.interfaces.document;

@safe:

OASVersion oasDetectVersion(string source) {
  if (!matchFirst(source, `openapi\s*[:=]\s*"?3\.1`).empty) {
    return OASVersion.v31;
  }

  if (!matchFirst(source, `openapi\s*[:=]\s*"?3\.0`).empty) {
    return OASVersion.v30;
  }

  if (!matchFirst(source, `swagger\s*[:=]\s*"?2\.0`).empty) {
    return OASVersion.v20;
  }

  return OASVersion.unknown;
}

string oasExtractTitle(string source) {
  auto m = matchFirst(source, `title\s*[:=]\s*"([^"]+)"`);
  if (!m.empty && m.captures.length >= 2) {
    return m.captures[1];
  }

  return "";
}

string oasExtractDocumentVersion(string source) {
  auto m = matchFirst(source, `version\s*[:=]\s*"([^"]+)"`);
  if (!m.empty && m.captures.length >= 2) {
    return m.captures[1];
  }

  return "";
}

OASEndpoint[] oasExtractEndpoints(string source) {
  OASEndpoint[] result;

  // Very lightweight extraction for path/method pairs from YAML/JSON-like text.
  foreach (m; matchAll(source, `(/[^\s"\{\}]+)\s*[:\{][\s\S]{0,120}?(get|post|put|patch|delete)\b`)) {
    if (m.captures.length >= 3) {
      OASEndpoint endpoint;
      endpoint.path = m.captures[1];
      endpoint.method = m.captures[2];
      endpoint.summary = "";
      result ~= endpoint;
    }
  }

  return result;
}

unittest {
  auto text = `openapi: "3.0.3"
info:
  title: "Demo API"
  version: "1.2.0"
paths:
  /orders:
    get:
      summary: list orders
  /orders/{id}:
    post:
      summary: create order`;

  assert(oasDetectVersion(text) == OASVersion.v30);
  assert(oasExtractTitle(text) == "Demo API");
  assert(oasExtractDocumentVersion(text) == "1.2.0");
  assert(oasExtractEndpoints(text).length >= 2);
}
