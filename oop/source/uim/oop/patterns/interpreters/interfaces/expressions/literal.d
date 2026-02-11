module uim.oop.patterns.interpreters.expressions.literal;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Literal expression represents a constant value.
 */
interface ILiteralExpression : ITerminalExpression {
    // Inherits getValue() from ITerminalExpression
}