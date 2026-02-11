module uim.oop.patterns.interpreters.interfaces.expressions.nonterminal;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Nonterminal expression represents composite nodes that combine
 * other expressions using operators or rules.
 */
interface INonterminalExpression : IInterpreterExpression {
    /**
     * Get the child expressions.
     */
    @safe IInterpreterExpression[] getChildren() const;
}
