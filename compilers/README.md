# UIM Compiler Library

A modular compiler toolkit for D that covers the full pipeline from lexing to code generation. It ships with interfaces, helpers, and mixins to assemble custom compilers while keeping phases decoupled.

## Features
- Interfaces for lexer, parser, semantic analyzer, optimizer, and code generator
- Ready-to-use base classes and helpers for each phase
- Diagnostics pipeline with recoverable errors
- Pluggable architecture: swap phases without changing callers
- Mixins to bootstrap compiler wiring and common behaviors
- Examples that demonstrate tokens, AST building, optimization, and templated codegen

## Installation
Add the dependency in `dub.sdl`:

```sdl
dependency "uim-framework:compilers" version="~>1.0.0"
```

Or in `dub.json`:

```json
{
  "dependencies": {
    "uim-framework:compilers": "~>1.0.0"
  }
}
```

## Quick Start
Create a minimal compiler by plugging in your components:

```d
import uim.compilers;

class MyLexer : ILexer { /* implement tokenize, currentToken, ... */ }
class MyParser : ICompilerParser { /* implement parse logic */ }
class MyAnalyzer : ISemanticAnalyzer { /* implement semantic checks */ }
class MyOptimizer : IOptimizer { /* optional optimizations */ }
class MyCodeGen : ICodeGenerator { /* emit target output */ }

class MyCompiler : Compiler {
    this() {
        lexer(new MyLexer());
        parser(new MyParser());
        analyzer(new MyAnalyzer());
        optimizer(new MyOptimizer());
        codeGenerator(new MyCodeGen());
    }
}

auto compiler = new MyCompiler();
auto result = compiler.compile("source code");
if (result.success) {
    writeln(result.output);
} else {
    foreach (diag; result.diagnostics) {
        writeln(diag.message);
    }
}
```

## Architecture
- **Interfaces** (`uim.compilers.interfaces.*`): Contracts for each compiler phase
- **Classes** (`uim.compilers.classes.*`): Base implementations and utilities
- **Helpers** (`uim.compilers.helpers.*`): Factories, common token/AST helpers
- **Mixins** (`uim.compilers.mixins.*`): Glue code to wire phases together
- **Errors** (`uim.compilers.errors.*`): Diagnostics and reporting utilities
- **Tests** (`uim.compilers.tests.*`): Test helpers for compiler components

## Examples
See `compilers/examples` for reference implementations:
- `basic_compiler.d`: End-to-end pipeline
- `lexers/` helpers in `string_mixins` and `templates.d`
- `traits.d` and `udas.d` for compile-time reflection patterns

Run an example (from repository root):

```bash
dub run compilers:example --config=basic_compiler
```

## Testing
Run the suite for this package:

```bash
cd compilers
dub test
```

## Notes
- The compiled artifact is exposed as target `uim-compiler` while the package name remains `compilers`.
- Components are @safe-ready where possible; prefer pure/nothrow on phase logic for predictability.
