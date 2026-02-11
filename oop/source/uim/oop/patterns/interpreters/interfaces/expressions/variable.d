module uim.oop.patterns.interpreters.expressions.variable;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Variable expression represents a variable reference.
 */
interface IVariableExpression : ITerminalExpression {
    /**
     * Get the variable name.
     */
    string getName() const;
}
