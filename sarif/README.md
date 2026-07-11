# Library uim-sarif

Updated on 10 July 2026

uim-sarif is a D library for reading, validating, and emitting SARIF 2.1.0 logs with vibe.d-friendly service helpers. It focuses on a practical core model for logs, runs, tools, rules, results, and locations, with JSON round-tripping built in.

## Features

* SARIF 2.1.0 version handling
* Core log, run, tool, rule, result, message, and location types
* JSON encode and decode helpers
* Validation helper for basic log sanity checks
* vibe.d async parsing callback helper

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:sarif" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.sarif;

void main() {
  auto service = SarifService();
  auto log = SarifLog(
    SarifVersion.v2_1_0,
    [
      SarifRun(
        SarifTool(SarifToolComponent("sarif-tool", "1.0.0")),
        [SarifResult("RULE001", "warning", "fail", SarifMessage("Example finding"), [])]
      )
    ]
  );

  auto payload = service.stringify(log);
  auto decoded = service.parse(payload);

  writeln(decoded.sarifVersion);
  writeln(decoded.runs.length);
}
```

## Modules

* `uim.sarif`: package entrypoint and reexports
* `uim.sarif.model`: SARIF data model and JSON round-trip helpers
* `uim.sarif.service`: parse, validate, stringify, and async orchestration

## Notes

* The library currently implements a practical core subset of the SARIF 2.1.0 schema.
* Additional schema branches can be added module by module without breaking the public entrypoint.
