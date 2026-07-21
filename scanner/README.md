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
- `IDCodeScannerService.scanSourceAsync`

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
