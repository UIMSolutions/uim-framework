# Library uim-openapi

Updated on 29. May 2026

uim-openapi is a lightweight D library for working with OpenAPI documents using vibe.d runtime patterns. It provides document parsing, operation indexing, method/path filtering, and asynchronous parse workflows.

## Features

* Typed OpenAPI document contract (`IOpenAPIDocument`)
* OpenAPI version detection (`OpenAPIVersion`)
* Server and operation extraction from YAML/JSON-like document content
* Query helper APIs for method and path filtering
* Synchronous and asynchronous parse APIs using vibe.d `runTask`

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:openapi" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.openapi;

void main() {
  auto source = `openapi: "3.1.0"
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

  writeln("title=", document.title());
  writeln("valid=", service.validate(document));

  foreach (op; service.operationsByMethod(document, "get")) {
    writeln(op.method, " ", op.path);
  }

  service.parseAsync(source, (IOpenAPIDocument doc) @safe {
    writeln("async operations=", doc.operations().length);
  });
}
```

## Modules

* `uim.openapi`: package entrypoint and re-exports
* `uim.openapi.interfaces`: OpenAPI contracts and type declarations
* `uim.openapi.models`: concrete OpenAPI document implementation
* `uim.openapi.helpers`: lightweight parser helper functions
* `uim.openapi.service`: parse, validate, and query orchestration

## Notes

* The parser is intentionally lightweight for integration workflows and prototyping.
* For strict schema and semantic validation, combine this module with dedicated OpenAPI validators in your pipeline.
