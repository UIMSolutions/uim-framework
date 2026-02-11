module uim.oop.patterns.interpreters.expressions.unary;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Unary expression has one operand.
 */
interface IUnaryExpression : INonterminalExpression {
  /**
    * Get the operand.
    */
  IExpression getOperand() const;

  /**
    * Get the operator symbol.
    */
  string getOperator() const;
}
