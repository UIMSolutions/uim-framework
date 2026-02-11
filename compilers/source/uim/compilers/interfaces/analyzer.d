/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.interfaces.analyzer;

import uim.compilers;

@safe:

/**
 * Interface for semantic analysis.
 * 
 * The analyzer performs type checking, symbol resolution, and other semantic validation.
 */
interface ISemanticAnalyzer {
  /**
   * Analyze an AST for semantic correctness.
   * 
   * Params:
   *   ast = Root node of the AST
   * 
   * Returns:
   *   Analyzed and annotated AST
   */
  ASTNode analyze(ASTNode ast);

  /**
   * Get the symbol table.
   */
  ISymbolTable symbolTable();

  /**
   * Get analyzer errors.
   */
  Diagnostic[] errors();

  /**
   * Get analyzer warnings.
   */
  Diagnostic[] warnings();
}









