# Library uim-cdm

Updated on 28. May 2026

A lightweight Common Data Model library for dlang built on vibe.d patterns. The package provides a typed document model, entity and field abstractions, JSON codec helpers, and an async HTTP transport facade for exchanging CDM payloads.

## Features

- CDM document model (`ICdmDocument`, `UIMCdmDocument`)
- Entity and field abstractions (`ICdmEntity`, `ICdmField`)
- CDM type enumeration helpers (`CdmObjectKind`, `CdmDataType`)
- CDM JSON encode/decode helpers (`cdmEncodeJson`, `cdmDecodeJson`)
- Async HTTP transport abstraction (`ICdmTransport`)
- vibe.d task dispatch and HTTP request flow

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:cdm" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.cdm;

void main() {
  auto transport = CdmTransport();
  assert(transport.connect("http://localhost:8080/cdm"));

  auto document = CdmDocument("CDM-1", "Mission Data Model", "urn:uim:cdm:mission");
  document
    .setMetadata("owner", "HQ-NORTH")
    .setMetadata("classification", "internal");

  auto entity = CdmEntity("MissionReport", "Mission report container")
    .addField(CdmField("reportId", CdmDataType.identifier, "MR-001"))
    .addField(CdmField("status", CdmDataType.string, "open"));

  document.addEntity(entity);

  auto json = cdmEncodeJson(document);
  auto decoded = cdmDecodeJson(json);

  transport.sendAsync(decoded, (ICdmDocument response) @safe {
    writeln("received CDM response for ", response.id());
    writeln("entities=", response.entities().length);
  });

  transport.disconnect();
}
```

## Modules

- `uim.cdm`: package entrypoint and re-exports
- `uim.cdm.types`: CDM enums and conversion helpers
- `uim.cdm.interfaces`: document and transport contracts
- `uim.cdm.document`: concrete document, entity, and field implementations
- `uim.cdm.codec`: JSON encode/decode helpers
- `uim.cdm.transport`: vibe.d HTTP transport facade

## Notes

The default transport uses async HTTP POST to a configured endpoint. It is intentionally lightweight so it can be adapted to a project-specific CDM backend or gateway.
