# Library uim-snmp

Updated on 30. May 2026

uim-snmp is a lightweight D library to work with SNMP workflows using vibe.d runtime patterns. It provides typed configuration, OID value parsing, get/walk/set orchestration, and asynchronous operation helpers.

## Features

- Typed SNMP contracts (`ISNMPService`)
- SNMP configuration model for v1/v2c/v3 profiles
- OID line parsing helper for simple textual SNMP responses
- Synchronous APIs for `get`, `walk`, and `set`
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real UDP SNMP transport later

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:snmp" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.snmp;

void main() {
  auto service = SNMPService();

  SNMPConfig cfg;
  cfg.host = "192.168.1.10";
  cfg.port = 161;
  cfg.snmpVersion = SNMPVersion.v2c;
  cfg.community = "public";

  assert(service.configure(cfg));

  auto sysName = service.get("1.3.6.1.2.1.1.5.0");
  writeln(sysName.oid, " = ", sysName.value);

  auto tree = service.walk("1.3.6.1.2.1.1", 10);
  writeln("walk values=", tree.length);

  auto writeResult = service.set("1.3.6.1.2.1.1.5.0", "switch-01", "STRING");
  writeln(writeResult.statusCode, " ", writeResult.message);

  service.getAsync("1.3.6.1.2.1.1.1.0", (SNMPOidValue value) @safe {
    writeln("async=", value.value);
  });
}
```

## Modules

- `uim.snmp`: package entrypoint and re-exports
- `uim.snmp.interfaces`: contracts, enums, config, and DTO structs
- `uim.snmp.models`: result and empty-value helper constructors
- `uim.snmp.helpers`: OID-line parsing helper functions
- `uim.snmp.service`: get/walk/set orchestration and async APIs

## Notes

- Default behavior uses in-memory providers to enable integration without external SNMP infrastructure.
- For production usage, inject transport logic via `setGetProvider`, `setWalkProvider`, and `setSetProvider`.
