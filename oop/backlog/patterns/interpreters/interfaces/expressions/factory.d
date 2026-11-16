module uim.oop.patterns.interpreters.interfaces.expressions.factory;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Expression factory creates specific types of expressions.
 */
interface IInterpreterExpressionFactory {
  /**
    * Create a literal expression.
    */
  @safe ILiteralExpression createLiteral(Variant value);

  /**
    * Create a variable expression.
    */
  @safe IVariableExpression createVariable(string name);

  /**
     * Create a binary expression.
     */
  @safe IBinaryExpression createBinary(string operator, IInterpreterExpression left, IInterpreterExpression right);

  /**
     * Create a unary expression.
     */
  @safe IUnaryExpression createUnary(string operator, IInterpreterExpression operand);
}
