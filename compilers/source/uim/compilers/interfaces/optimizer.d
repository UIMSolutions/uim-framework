/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.interfaces.optimizer;

import uim.compilers;

@safe:

/**
 * Interface for code optimization.
 * 
 * The optimizer transforms the AST or intermediate representation
 * to improve performance, reduce size, or apply other optimizations.
 */
interface IOptimizer {
  /**
   * Optimize an AST.
   * 
   * Params:
   *   ast = AST to optimize
   *   level = Optimization level (0 = none, 1 = basic, 2 = aggressive, 3 = maximum)
   * 
   * Returns:
   *   Optimized AST
   */
  ASTNode optimize(ASTNode ast, int level = 1);

  /**
   * Apply a specific optimization pass.
   */
  ASTNode applyPass(ASTNode ast, OptimizationPass pass);

  /**
   * Get available optimization passes.
   */
  OptimizationPass[] availablePasses();

  /**
   * Get statistics about optimizations performed.
   */
  OptimizationStats statistics();
}

/**
 * Optimization pass.
 */
struct OptimizationPass {
  /// Pass name
  string name;

  /// Pass description
  string description;

  /// Pass function
  ASTNode function(ASTNode) @safe transformer;

  /// Recommended optimization level for this pass
  int level;
}

/**
 * Optimization statistics.
 */
struct OptimizationStats {
  /// Number of constant folding operations
  size_t constantFolds;

  /// Number of dead code eliminations
  size_t deadCodeEliminations;

  /// Number of common subexpression eliminations
  size_t commonSubexpressions;

  /// Number of loop optimizations
  size_t loopOptimizations;

  /// Number of inlined functions
  size_t inlinedFunctions;

  /// Estimated performance improvement (percentage)
  float performanceGain;

  /// Size reduction (bytes)
  long sizeReduction;
}
