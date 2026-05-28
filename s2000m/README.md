# Library uim-s2000m

Updated on 28. May 2026

`uim-s2000m` is a D language library (vibe.d-based runtime) to work with S2000M exchange payloads and reference artifacts.

S2000M is described by the S-Series as an international specification for material management. The official downloads for Issue 8.0 (April 2025) state that this release is part of the 2025 block update, adds provisioning and codification XML exchanges, and includes enhanced Chapter 3 material supply examples/templates. The issue also aligns with the latest Common Data Model (CDM) and XSD schemas.

## Features

- Typed S2000M document contract (`IS2000MDocument`)
- Chapter and issue enums (`S2000MChapter`, `S2000MIssue`)
- XML metadata extraction helpers (root element, transaction code, issue detection)
- S2000M service API with sync and async parsing (`UIMS2000MService`)
- Built-in catalog of official S2000M 8.0 download artifacts (PDF, XSD, EAP, XMI)

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:s2000m" version="*"
```

## Quick Start

```d
import uim.s2000m;
import std.stdio : writeln;

void main() {
  auto service = S2000MService();

  auto xml = `<?xml version="1.0"?>
    <MaterialRequest issue="8.0" transactionCode="MATREQ">
      <item partNumber="123-ABC" quantity="2"/>
    </MaterialRequest>`;

  auto doc = service.parseXml(xml);

  writeln("Root: ", doc.rootElement());
  writeln("Transaction: ", doc.transactionCode());
  writeln("Issue: ", doc.issue());
  writeln("Valid for 8.0: ", service.validateAgainstIssue(doc, S2000MIssue.issue80));

  foreach (artifact; service.recommendedDownloads()) {
    writeln(artifact.title, " => ", artifact.url);
  }
}
```

## Modules

- `uim.s2000m`: package entrypoint and re-exports
- `uim.s2000m.interfaces`: contracts and enums
- `uim.s2000m.models`: concrete S2000M document model
- `uim.s2000m.helpers`: XML extraction and chapter/issue inference
- `uim.s2000m.service`: primary parsing/validation service
- `uim.s2000m.catalog`: official S2000M download artifact metadata

## Scope Notes

- This package focuses on practical payload handling and integration helpers.
- Full schema-level validation against official XSD files can be layered on top using your XML validation pipeline.
- S2000M usage remains subject to official S2000M terms and conditions published by the S-Series.