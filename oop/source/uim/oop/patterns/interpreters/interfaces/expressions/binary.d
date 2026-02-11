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
  IExpression getLeft() const;

  /**
    * Get the right operand.
    */
  IExpression getRight() const;

  /**
    * Get the operator symbol.
    */
  string getOperator() const;
}
