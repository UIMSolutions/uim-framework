# UIM-SCANNER

uim-scanner is a D/vibe.d library to scan and read D language source code.

## Features

- Parse module declaration from source text.
- Parse import declarations including `public import` and `static import`.
- Detect top-level symbols:
  - class
  - struct
  - interface
  - enum
  - union
  - template
  - alias
  - mixin template
  - function-like declarations
- Scan single source text, a `.d` file, or a full directory tree.
- Async source scanning via vibe.d `runTask` callback.
- Strict mode for multi-line declaration parsing and signature reconstruction.
- JSON export helpers for source, file, and directory scans.

## Install

In monorepo projects this package is available as subpackage `scanner`.

Standalone declaration:

```sdl
dependency "uim-framework:scanner" version="*"
```

## Quick Start

```d
import uim.scanner;

void main() {
  auto scanner = DCodeScannerService();

  auto code = q{
    module demo.app;
    import std.string;
    class Greeter {}
    bool validate(string value) { return value.length > 0; }
  };

  auto result = scanner.scanSource(code, "demo.d");
  assert(result.moduleName == "demo.app");
  assert(result.imports.length == 1);
  assert(result.symbols.length >= 2);
}
```

## Public API

- `IDCodeScannerService.scanSource`
- `IDCodeScannerService.scanFile`
- `IDCodeScannerService.scanDirectory`
- `IDCodeScannerService.scanSourceAsJson`
- `IDCodeScannerService.scanFileAsJson`
- `IDCodeScannerService.scanDirectoryAsJson`
- `IDCodeScannerService.scanSourceAsPrettyJson`
- `IDCodeScannerService.scanFileAsPrettyJson`
- `IDCodeScannerService.scanDirectoryAsPrettyJson`
- `IDCodeScannerService.scanSourceAsync`

## Strict Mode

Enable strict parsing when declarations span multiple lines.

```d
DScanOptions options;
options.strictMode = true;

auto result = scanner.scanSource(sourceCode, "source.d", options);
```

## CLI Example

Run folder scan example with pretty JSON output:

```bash
dub run --config=example_scan_folder -- /path/to/folder
```

Optional flags:

- `--strict` enable strict multi-line declaration parsing
- `--shallow` disable recursive directory scan
- `--compact` output compact JSON instead of pretty-printed JSON

## Limitations

- The scanner is intentionally lightweight and line-oriented.
- It does not perform full D grammar parsing or semantic analysis.
- Multi-line declarations are detected only when key tokens appear on a single line.

## Testing

From package directory:

```bash
dub test
```

From monorepo root:

```bash
dub test
```
