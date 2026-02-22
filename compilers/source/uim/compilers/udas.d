/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.udas;

@safe:

/// Associates a symbol with a compiler phase name (e.g. "lexer", "parser").
struct CompilerPhase {
  string name;

  this(string phaseName) {
    name = phaseName;
  }
}

/// Declares a language key (e.g. "json", "sql", "dsl") for a component.
struct Language {
  string name;

  this(string languageName) {
    name = languageName;
  }
}

/// Declares a target backend key (e.g. "llvm-ir", "c", "wasm").
struct Target {
  string name;

  this(string targetName) {
    name = targetName;
  }
}

/// Optional ordering metadata for phase handlers.
struct StageOrder {
  int value;

  this(int order) {
    value = order;
  }
}

/// Marks a symbol as a lexer implementation.
struct LexerImplementation {
  string name = "default";
}

/// Marks a symbol as a parser implementation.
struct ParserImplementation {
  string name = "default";
}

/// Marks a symbol as a semantic analyzer implementation.
struct AnalyzerImplementation {
  string name = "default";
}

/// Marks a symbol as an optimizer implementation.
struct OptimizerImplementation {
  string name = "default";
}

/// Marks a symbol as a code generator implementation.
struct CodeGeneratorImplementation {
  string name = "default";
}

/// Marks a symbol as a complete compiler implementation.
struct CompilerImplementation {
  string name = "default";
}

/// Checks whether a symbol has a `CompilerPhase` UDA.
template hasCompilerPhaseAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasCompilerPhaseAttribute = hasUDA!(symbol, CompilerPhase);
}

/// Gets `CompilerPhase` metadata for a symbol.
template getCompilerPhaseAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasCompilerPhaseAttribute!symbol) {
    alias getCompilerPhaseAttribute = getUDAs!(symbol, CompilerPhase)[0];
  }
}

/// Checks whether a symbol has a `Language` UDA.
template hasLanguageAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasLanguageAttribute = hasUDA!(symbol, Language);
}

/// Gets `Language` metadata for a symbol.
template getLanguageAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasLanguageAttribute!symbol) {
    alias getLanguageAttribute = getUDAs!(symbol, Language)[0];
  }
}

/// Checks whether a symbol has a `Target` UDA.
template hasTargetAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasTargetAttribute = hasUDA!(symbol, Target);
}

/// Gets `Target` metadata for a symbol.
template getTargetAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasTargetAttribute!symbol) {
    alias getTargetAttribute = getUDAs!(symbol, Target)[0];
  }
}

/// Checks whether a symbol has a `StageOrder` UDA.
template hasStageOrderAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasStageOrderAttribute = hasUDA!(symbol, StageOrder);
}

/// Gets `StageOrder` metadata for a symbol.
template getStageOrderAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasStageOrderAttribute!symbol) {
    alias getStageOrderAttribute = getUDAs!(symbol, StageOrder)[0];
  }
}

/// Checks whether a symbol has a `LexerImplementation` UDA.
template hasLexerImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasLexerImplementationAttribute = hasUDA!(symbol, LexerImplementation);
}

/// Checks whether a symbol has a `ParserImplementation` UDA.
template hasParserImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasParserImplementationAttribute = hasUDA!(symbol, ParserImplementation);
}

/// Checks whether a symbol has an `AnalyzerImplementation` UDA.
template hasAnalyzerImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasAnalyzerImplementationAttribute = hasUDA!(symbol, AnalyzerImplementation);
}

/// Checks whether a symbol has an `OptimizerImplementation` UDA.
template hasOptimizerImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasOptimizerImplementationAttribute = hasUDA!(symbol, OptimizerImplementation);
}

/// Checks whether a symbol has a `CodeGeneratorImplementation` UDA.
template hasCodeGeneratorImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasCodeGeneratorImplementationAttribute = hasUDA!(symbol, CodeGeneratorImplementation);
}

/// Checks whether a symbol has a `CompilerImplementation` UDA.
template hasCompilerImplementationAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasCompilerImplementationAttribute = hasUDA!(symbol, CompilerImplementation);
}

unittest {
  @CompilerPhase("lexer")
  @Language("json")
  @StageOrder(10)
  @LexerImplementation("json-lexer")
  struct JsonLexer {
  }

  @CompilerPhase("parser")
  @Language("json")
  @ParserImplementation("json-parser")
  struct JsonParser {
  }

  @CompilerPhase("generator")
  @Target("llvm-ir")
  @CodeGeneratorImplementation("llvm")
  struct LlvmGenerator {
  }

  @CompilerImplementation("json-compiler")
  struct JsonCompiler {
  }

  assert(hasCompilerPhaseAttribute!JsonLexer);
  assert(getCompilerPhaseAttribute!JsonLexer.name == "lexer");

  assert(hasLanguageAttribute!JsonParser);
  assert(getLanguageAttribute!JsonParser.name == "json");

  assert(hasStageOrderAttribute!JsonLexer);
  assert(getStageOrderAttribute!JsonLexer.value == 10);

  assert(hasLexerImplementationAttribute!JsonLexer);
  assert(hasParserImplementationAttribute!JsonParser);
  assert(hasCodeGeneratorImplementationAttribute!LlvmGenerator);
  assert(hasCompilerImplementationAttribute!JsonCompiler);

  assert(hasTargetAttribute!LlvmGenerator);
  assert(getTargetAttribute!LlvmGenerator.name == "llvm-ir");

  assert(!hasOptimizerImplementationAttribute!JsonLexer);
  assert(!hasAnalyzerImplementationAttribute!JsonParser);
}