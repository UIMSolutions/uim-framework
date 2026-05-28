# Library uim-jc3iedm

Updated on 28. May 2026

uim-jc3iedm is a lightweight library for working with JC3IEDM (Joint Consultation, Command and Control Information Exchange Data Model) structures using D and vibe.d patterns.

## Features

* Typed JC3IEDM entity model (`IJC3IEDMEntity`)
* Domain enums for type and affiliation (`JC3IEDMEntityType`, `JC3IEDMAffiliation`)
* Position and attribute support for command-and-control data records
* In-memory JC3IEDM service abstraction with query operations
* Async entity stream callbacks using vibe.d `runTask`

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:jc3iedm" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.jc3iedm;

void main() {
  auto service = JC3IEDMService();
  service.connect("memory://jc3iedm");

  auto unit = JC3IEDMEntity("u-42", "Task Force Alpha", JC3IEDMEntityType.unit)
    .affiliation(JC3IEDMAffiliation.friendly)
    .position(JC3IEDMPosition(50.73, 7.10, 120.0))
    .setAttribute("nation", "DEU")
    .setAttribute("mission", "ISR");

  service.upsertEntity(unit);

  foreach (e; service.queryByType(JC3IEDMEntityType.unit)) {
    writeln(e.id(), " ", e.name());
  }

  service.disconnect();
}
```

## Modules

* `uim.jc3iedm`: package entrypoint and re-exports
* `uim.jc3iedm.interfaces`: JC3IEDM contracts and enums
* `uim.jc3iedm.models`: concrete JC3IEDM entity implementation
* `uim.jc3iedm.helpers`: text and identifier helpers
* `uim.jc3iedm.service`: storage, query, and stream orchestration

## Notes

* This module provides a practical application-layer representation for JC3IEDM-aligned workflows.
* The service interface can be adapted to persistent backends or federation gateways.
