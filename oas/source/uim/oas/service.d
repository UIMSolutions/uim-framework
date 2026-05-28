/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oas.service;

import std.algorithm : canFind;
import std.string : toLower;

import vibe.d : runTask;

import uim.oas;

mixin(ShowModule!());

@safe:

class UIMOASService : UIMObject, IOASService {
  IOASDocument parse(string source) {
    auto doc = OASDocument();
    doc.raw(source)
      .version_(oasDetectVersion(source))
      .title(oasExtractTitle(source))
      .documentVersion(oasExtractDocumentVersion(source))
      .endpoints(oasExtractEndpoints(source));

    return doc;
  }

  bool validate(IOASDocument document) {
    if (document is null || !document.isValid()) {
      return false;
    }

    return document.endpoints().length > 0;
  }

  OASEndpoint[] findByMethod(IOASDocument document, string method) {
    OASEndpoint[] result;
    if (document is null || method.length == 0) {
      return result;
    }

    auto methodLower = toLower(method);
    foreach (ep; document.endpoints()) {
      if (toLower(ep.method).canFind(methodLower)) {
        result ~= ep;
      }
    }

    return result;
  }

  bool parseAsync(string source, OASDocumentHandler handler) {
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

IOASService OASService() {
  return new UIMOASService();
}

unittest {
  auto source = `openapi: "3.0.3"
info:
  title: "Order API"
  version: "1.0.0"
paths:
  /orders:
    get:
      summary: list orders`;

  auto s = OASService();
  auto d = s.parse(source);

  assert(s.validate(d));
  assert(s.findByMethod(d, "GET").length >= 1);
}
