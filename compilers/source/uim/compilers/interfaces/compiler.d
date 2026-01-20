/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.interfaces.compiler;

import uim.compilers;

@safe:

/**
 * Interface for a generic compiler.
 * 
 * A compiler transforms source code through multiple phases:
 * 1. Lexical analysis (tokenization)
 * 2. Syntax analysis (parsing)
 * 3. Semantic analysis
 * 4. Optimization
 * 5. Code generation
 */
interface ICompiler {
  /**
   * Compile source code to target output.
   * 
   * Params:
   *   source = Source code to compile
   *   options = Compilation options
   * 
   * Returns:
   *   Compilation result with output and diagnostics
   */
  CompilationResult compile(string source, CompilerOptions options = CompilerOptions.init);

  /**
   * Get the lexer used by this compiler.
   */
  ILexer lexer();

  /**
   * Get the parser used by this compiler.
   */
  IParser parser();

  /**
   * Get the semantic analyzer used by this compiler.
   */
  ISemanticAnalyzer analyzer();

  /**
   * Get the optimizer used by this compiler.
   */
  IOptimizer optimizer();

  /**
   * Get the code generator used by this compiler.
   */
  ICodeGenerator codeGenerator();

  /**
   * Get compiler diagnostics (errors, warnings, info).
   */
  Diagnostic[] diagnostics();

  /**
   * Clear all diagnostics.
   */
  void clearDiagnostics();

  /**
   * Check if compilation had errors.
   */
  bool hasErrors();

  /**
   * Get the compiler name/version.
   */
  string version_();
}

/**
 * Compiler options for controlling compilation behavior.
 */
struct CompilerOptions {
  /// Optimization level (0 = none, 1 = basic, 2 = aggressive, 3 = maximum)
  int optimizationLevel = 0;

  /// Enable debug information
  bool debugInfo = false;

  /// Enable warnings
  bool warnings = true;

  /// Treat warnings as errors
  bool warningsAsErrors = false;

  /// Enable verbose output
  bool verbose = false;

  /// Target platform/architecture
  string target = "default";

  /// Output format (e.g., "executable", "library", "object", "asm")
  string outputFormat = "executable";

  /// Additional include paths
  string[] includePaths;

  /// Defined macros/symbols
  string[string] defines;
}

/**
 * Compilation result containing output and diagnostics.
 */
struct CompilationResult {
  /// Compilation succeeded
  bool success;

  /// Generated output (code, bytecode, etc.)
  ubyte[] output;

  /// Output as string (for text-based targets)
  string outputText;

  /// Diagnostics (errors, warnings, info)
  Diagnostic[] diagnostics;

  /// Compilation time in milliseconds
  long compilationTime;
}

/**
 * Diagnostic message (error, warning, info).
 */
struct Diagnostic {
  /// Diagnostic severity
  DiagnosticSeverity severity;

  /// Error/warning code
  string code;

  /// Diagnostic message
  string message;

  /// Source file
  string file;

  /// Line number (1-based)
  size_t line;

  /// Column number (1-based)
  size_t column;

  /// Length of the problematic text
  size_t length;
}

/**
 * Diagnostic severity levels.
 */
enum DiagnosticSeverity {
  Info,
  Warning,
  Error,
  Fatal
}
