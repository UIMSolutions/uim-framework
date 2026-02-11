module uim.oop.patterns.interpreters.interfaces.expressions.optimizer;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Expression optimizer transforms expressions into more efficient forms.
 */
interface IExpressionOptimizer {
  /**
    * Optimize an expression tree.
    * This method takes an expression and returns an optimized version of it.
    * For example, it can simplify constant expressions or apply algebraic identities.
    *
    * Params:
    *   expression - The expression to optimize.
    *
    * Returns:
    *   An optimized expression.
    */
  Expression optimize(IExpression expression);

  /**
    * Check if optimization is possible.
    */
  bool canOptimize(IExpression expression) const;
}
