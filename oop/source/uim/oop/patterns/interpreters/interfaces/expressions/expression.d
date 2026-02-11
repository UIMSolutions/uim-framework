module uim.oop.patterns.interpreters.expressions.expression;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * AbstractExpression declares an interpret operation that all nodes
 * in the abstract syntax tree must implement.
 */
interface IExpression {
    /**
     * Interpret the expression in the given context.
     */
    Variant interpret(IContext context);
    
    /**
     * Get a string representation of the expression.
     */
    string toString() const;
}