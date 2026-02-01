/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.interfaces.codegen;

import uim.compilers;

@safe:

/**
 * Interface for code generation.
 * 
 * The code generator produces target output from the optimized AST.
 */
interface ICodeGenerator {
  /**
   * Generate code from an AST.
   * 
   * Params:
   *   ast = AST to generate code from
   *   options = Code generation options
   * 
   * Returns:
   *   Generated code
   */
  CodeGenResult generate(ASTNode ast, CodeGenOptions options = CodeGenOptions.init);

  /**
   * Get the target platform/architecture.
   */
  string target();

  /**
   * Set the target platform/architecture.
   */
  void target(string newTarget);

  /**
   * Get supported targets.
   */
  string[] supportedTargets();
}

/**
 * Code generation options.
 */
struct CodeGenOptions {
  /// Target format (e.g., "asm", "llvm-ir", "c", "bytecode")
  string format = "asm";

  /// Enable debug symbols
  bool debugSymbols = false;

  /// Emit comments in generated code
  bool comments = true;

  /// Optimization hints from optimizer
  OptimizationStats optimizationStats;
}

/**
 * Code generation result.
 */
struct CodeGenResult {
  /// Success flag
  bool success;

  /// Generated code (binary)
  ubyte[] code;

  /// Generated code (text, if applicable)
  string codeText;

  /// Debug information
  DebugInfo[] debugInfo;

  /// Generation errors
  Diagnostic[] errors;
}

/**
 * Debug information for generated code.
 */
struct DebugInfo {
  /// Source file
  string sourceFile;

  /// Source line
  size_t sourceLine;

  /// Generated code offset
  size_t codeOffset;

  /// Symbol name (if applicable)
  string symbolName;
}
