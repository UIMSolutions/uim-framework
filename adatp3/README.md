# Library uim-adatp3

Updated on 28. May 2026

A lightweight NATO ADatP-3 messaging library for dlang using vibe.d patterns. The package provides a typed message model, JSON codec, and async transport abstraction for integrating ADatP-3 style message exchanges in distributed systems.

## Features

- ADatP-3 message model (`IADatP3Message`, `UIMADatP3Message`)
- Message type and precedence enums (`ADatP3MessageType`, `ADatP3Priority`)
- ADatP-3 JSON codec (`adatp3EncodeJson`, `adatp3DecodeJson`)
- Async transport abstraction (`IADatP3Transport`)
- HTTP POST/ACK transport flow using vibe-http `requestHTTP`
- vibe.d-based task dispatch in transport implementation (`runTask`)

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:adatp3" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.adatp3;

void main() {
  auto transport = ADatP3Transport();
  assert(transport.connect("http://localhost:8080/adatp3"));

  auto message = ADatP3Message(
    ADatP3MessageType.sitrep,
    "MSG-1001",
    "HQ-NORTH",
    "BDE-7",
    ADatP3Priority.priority
  );

  message
    .setField("location", "32TLP12345678")
    .setField("summary", "Route RED secured");

  auto json = adatp3EncodeJson(message);
  auto decoded = adatp3DecodeJson(json);

  transport.sendAsync(decoded, (IADatP3Message response) @safe {
    writeln("received ADatP-3 ack for ", response.messageId());
    writeln("transport=", response.field("transport"));
  });

  transport.disconnect();
}
```

## Modules

- `uim.adatp3`: package entrypoint and re-exports
- `uim.adatp3.types`: ADatP-3 enums and conversion helpers
- `uim.adatp3.interfaces`: message and transport contracts
- `uim.adatp3.message`: concrete ADatP-3 message implementation
- `uim.adatp3.codec`: ADatP-3 JSON encode/decode helpers
- `uim.adatp3.transport`: vibe.d task-based async transport shim

## Notes

The default transport implementation uses async HTTP POST to the configured endpoint and expects a JSON ADatP-3 response body for ACK/response processing. The same interface can still be implemented for alternate transports.
