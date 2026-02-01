# Library 📚 uim-compilers

Updated on 1. February 2026

[![uim-compilers](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-compilers.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-compilers.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

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
    "uim-framework:framework:compilers": "~>1.0.0"
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
- **Factories & Registries**: Pluggable creation and lookup for each component:
  - `LexerFactory` / `LexerRegistry` – Register and retrieve lexer implementations
  - `ParserFactory` / `ParserRegistry` – Register and retrieve parser implementations
  - `SemanticAnalyzerFactory` / `SemanticAnalyzerRegistry` – Register and retrieve analyzer implementations
  - `OptimizerFactory` / `OptimizerRegistry` – Register and retrieve optimizer implementations
  - `CodeGeneratorFactory` / `CodeGeneratorRegistry` – Register and retrieve code generator implementations
  - `CompilerFactory` / `CompilerRegistry` – Register and retrieve complete compiler instances
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

## Using Factories & Registries

### Register Custom Components

```d
import uim.compilers;

// Register a custom lexer
auto lexerRegistry = new LexerRegistry();
lexerRegistry.register("my-lexer", new MyCustomLexer());

// Register a custom parser
auto parserRegistry = new ParserRegistry();
parserRegistry.register("my-parser", new MyCustomParser());

// Register a complete compiler
auto compilerRegistry = new CompilerRegistry();
compilerRegistry.register("my-compiler", new MyCompiler());
```

### Retrieve and Use Registered Components

```d
import uim.compilers;

auto lexerRegistry = new LexerRegistry();
lexerRegistry.register("json-lexer", new JsonLexer());

// Get registered lexer by name
if (lexerRegistry.has("json-lexer")) {
    auto lexer = lexerRegistry.get("json-lexer");
    auto tokens = lexer.tokenize(sourceCode);
}

// Safely get with fallback
auto lexer = lexerRegistry.get("json-lexer", new DefaultLexer());
```

### Build Compiler with Registry

```d
import uim.compilers;

class CustomCompiler : Compiler {
    this() {
        super();
      
        auto lexerRegistry = new LexerRegistry();
        auto parserRegistry = new ParserRegistry();
        auto analyzerRegistry = new SemanticAnalyzerRegistry();
        auto optimizerRegistry = new OptimizerRegistry();
        auto codegenRegistry = new CodeGeneratorRegistry();
      
        // Register implementations
        lexerRegistry.register("default", new Lexer());
        parserRegistry.register("default", new Parser());
        analyzerRegistry.register("default", new SemanticAnalyzer());
        optimizerRegistry.register("default", new Optimizer());
        codegenRegistry.register("default", new CodeGenerator());
      
        // Wire them together
        lexer(lexerRegistry.get("default"));
        parser(parserRegistry.get("default"));
        analyzer(analyzerRegistry.get("default"));
        optimizer(optimizerRegistry.get("default"));
        codeGenerator(codegenRegistry.get("default"));
    }
}

auto compiler = new CustomCompiler();
auto result = compiler.compile(sourceCode);
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
- **Factories** allow lazy or conditional creation of components with custom logic.
- **Registries** enable runtime lookup of implementations by string key, useful for plugin systems and configuration-driven composition.
- Both factory and registry classes extend `UIMFactory` and `UIMRegistry` from the `uim.oop` package for consistency across the framework.
