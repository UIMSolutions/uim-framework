/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.openapi.service;

import std.algorithm : canFind;
import std.string : toLower;

import vibe.d : runTask;

import uim.openapi;

mixin(ShowModule!());

@safe:

class UIMOpenAPIService : UIMObject, IOpenAPIService {
  IOpenAPIDocument parse(string source) {
    auto document = OpenAPIDocument();

    document.raw(source)
      .version_(openapiDetectVersion(source))
      .title(openapiExtractTitle(source))
      .documentVersion(openapiExtractDocumentVersion(source))
      .servers(openapiExtractServers(source))
      .operations(openapiExtractOperations(source));

    return document;
  }

  bool validate(IOpenAPIDocument document) {
    if (document is null || !document.isValid()) {
      return false;
    }

    return document.operations().length > 0;
  }

  OpenAPIOperation[] operationsByMethod(IOpenAPIDocument document, string method) {
    OpenAPIOperation[] result;
    if (document is null || method.length == 0) {
      return result;
    }

    auto methodLower = toLower(method);
    foreach (op; document.operations()) {
      if (toLower(op.method).canFind(methodLower)) {
        result ~= op;
      }
    }

    return result;
  }

  OpenAPIOperation[] operationsByPath(IOpenAPIDocument document, string path) {
    OpenAPIOperation[] result;
    if (document is null || path.length == 0) {
      return result;
    }

    foreach (op; document.operations()) {
      if (op.path == path) {
        result ~= op;
      }
    }

    return result;
  }

  bool parseAsync(string source, OpenAPIDocumentHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localHandler = handler;
    auto localSource = source;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(parse(localSource));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

IOpenAPIService OpenAPIService() {
  return new UIMOpenAPIService();
}

unittest {
  auto source = `openapi: "3.0.3"
info:
  title: "Order API"
  version: "1.0.0"
servers:
  - url: "https://api.openlogisticsfoundation.org"
paths:
  /orders:
    get:
      summary: list orders`;

  auto service = OpenAPIService();
  auto document = service.parse(source);

  assert(service.validate(document));
  assert(service.operationsByMethod(document, "GET").length >= 1);
  assert(service.operationsByPath(document, "/orders").length >= 1);
}
