module uim.oop.patterns.interpreters.interfaces.expressions.visitor;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Visitor for expression trees (for operations like optimization, printing).
 */
interface IInterpreterExpressionVisitor {
    /**
     * Visit a literal expression.
     */
    @safe void visitLiteral(ILiteralExpression expr);
    
    /**
     * Visit a variable expression.
     */
    @safe void visitVariable(IVariableExpression expr);
    
    /**
     * Visit a binary expression.
     */
    @safe void visitBinary(IBinaryExpression expr);
    
    /**
     * Visit a unary expression.
     */
    @safe void visitUnary(IUnaryExpression expr);
}
