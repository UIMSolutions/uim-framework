# Library uim-oas

Updated on 28. May 2026

uim-oas is a lightweight D library for working with OpenAPI Specification (OAS) documents using vibe.d runtime patterns. It provides OAS document parsing, validation, endpoint extraction, and asynchronous processing helpers.

## Features

* Typed OAS document contract (`IOASDocument`)
* OpenAPI version detection (`OASVersion`)
* Endpoint extraction (`OASEndpoint` list)
* Synchronous and asynchronous parse workflows
* Query helper to filter endpoints by HTTP method

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:oas" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.oas;

void main() {
  auto source = `openapi: "3.0.3"
info:
  title: "Order API"
  version: "1.0.0"
paths:
  /orders:
    get:
      summary: list orders`;

  auto service = OASService();
  auto document = service.parse(source);

  writeln("title=", document.title());
  writeln("valid=", service.validate(document));

  foreach (ep; service.findByMethod(document, "get")) {
    writeln(ep.method, " ", ep.path);
  }
}
```

## Modules

* `uim.oas`: package entrypoint and re-exports
* `uim.oas.interfaces`: OAS document and service contracts
* `uim.oas.models`: concrete OAS document implementation
* `uim.oas.helpers`: lightweight OAS parser helpers
* `uim.oas.service`: parse/validate/query orchestration

## Notes

* The parser helpers are intentionally lightweight for integration scenarios.
* For strict production schema validation, integrate dedicated OpenAPI schema validation tools alongside this module.
