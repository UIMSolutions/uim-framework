module uim.oop.patterns.interpreters.interfaces.expressions.unary;

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
  IInterpreterExpression getOperand() const;

  /**
    * Get the operator symbol.
    */
  string getOperator() const;
}
