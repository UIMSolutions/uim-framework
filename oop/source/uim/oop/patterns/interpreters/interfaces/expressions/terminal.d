module uim.oop.patterns.interpreters.expressions.terminal;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Terminal expression represents leaf nodes in the abstract syntax tree.
 * These are the basic building blocks that cannot be broken down further.
 */
interface ITerminalExpression : IExpression {
    /**
     * Get the value of this terminal expression.
     */
    Variant getValue() const;
}