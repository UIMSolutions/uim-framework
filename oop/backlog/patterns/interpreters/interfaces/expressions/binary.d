module uim.oop.patterns.interpreters.interfaces.expressions.binary;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Binary expression has two operands (left and right).
 */
interface IBinaryExpression : INonterminalExpression {
  /**
    * Get the left operand.
    */
  IInterpreterExpression getLeft() const;

  /**
    * Get the right operand.
    */
  IInterpreterExpression getRight() const;

  /**
    * Get the operator symbol.
    */
  string getOperator() const;
}
