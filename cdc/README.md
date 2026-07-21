# UIM-CDC

uim-cdc is a D/vibe.d library to work with **Virtual COM Port / USB CDC** communication patterns.

## Scope

The library provides a lightweight CDC abstraction with practical integration features:

- Port configuration model for baud, parity, stop bits, and framing behavior.
- Open/close lifecycle for CDC endpoints.
- Text and byte payload write APIs.
- Frame read API with newline-delimited or raw mode.
- Async write and polling callbacks via vibe.d.
- Built-in loopback mode for testing without physical hardware.

## Typical Device Paths

- Linux: `/dev/ttyACM0`, `/dev/ttyUSB0`
- Loopback test mode: `loopback`, `loop://vcp0`, `mock://cdc`

## Installation

From this monorepo, `cdc` is available as a subpackage.

Standalone dependency declaration:

```sdl
dependency "uim-framework:cdc" version="*"
```

## Quick Start

```d
import uim.cdc;

void main() {
  CDCPortConfig cfg;
  cfg.devicePath = "loop://vcp0";
  cfg.baudRate = 115_200;
  cfg.newlineDelimited = true;

  auto cdc = CDCService();
  assert(cdc.open(cfg));

  auto sent = cdc.writeText("AT+GMR\n");
  assert(sent.success);

  CDCFrame frame;
  if (cdc.readFrame(frame)) {
    // frame.text contains the received CDC line
  }

  cdc.close();
}
```

## Public API

- `ICDCService.open`
- `ICDCService.close`
- `ICDCService.writeText`
- `ICDCService.writeBytes`
- `ICDCService.readFrame`
- `ICDCService.writeTextAsync`
- `ICDCService.writeBytesAsync`
- `ICDCService.pollAsync`

## Notes and Limitations

- This release focuses on application-level CDC workflow abstraction.
- OS-level USB descriptor handling and kernel driver interactions are out of scope.
- Real hardware reliability depends on device/driver permissions and endpoint behavior.

## Testing

Run from package directory:

```bash
dub test
```

Run full framework tests from repository root:

```bash
dub test
```
