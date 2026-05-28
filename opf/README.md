# Library uim-opf

Updated on 28. May 2026

uim-opf is a lightweight D library for integrating with Open Logistics Foundation APIs using vibe.d runtime patterns. It provides typed resource models, synchronous and asynchronous request abstractions, and service-level query helpers.

## Features

* Typed OPF resource model (`IOPFResource`)
* API method and resource enums (`OPFHttpMethod`, `OPFResourceType`)
* URL/path helper utilities for API request composition
* In-memory resource registry with filtering by resource type
* Sync and async request APIs with vibe.d `runTask`

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:opf" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.opf;

void main() {
  auto service = OPFService();
  service.connect("https://api.openlogisticsfoundation.org");

  auto order = OPFResource("ord-42", OPFResourceType.order, "OPEN")
    .payload("{\"reference\":\"PO-42\",\"priority\":\"HIGH\"}")
    .setMetadata("tenant", "demo");

  service.upsertResource(order);

  auto response = service.request(OPFHttpMethod.get, "/orders/ord-42");
  writeln("status=", response.statusCode);
  writeln("url=", response.headers["X-OPF-Url"]);

  service.requestAsync(OPFHttpMethod.post, "/orders", (OPFApiResponse r) @safe {
    writeln("async status=", r.statusCode);
  }, order.payload());

  service.disconnect();
}
```

## Modules

* `uim.opf`: package entrypoint and re-exports
* `uim.opf.interfaces`: contracts for resources and service operations
* `uim.opf.models`: concrete OPF resource implementation
* `uim.opf.helpers`: API method and URL/path helpers
* `uim.opf.service`: request orchestration and resource queries

## Notes

* The default service implementation provides an integration-friendly abstraction layer and can be replaced with direct HTTP client calls to concrete OLF API endpoints.
* For production integration, map resource payloads to OLF API schemas and authentication policies.
