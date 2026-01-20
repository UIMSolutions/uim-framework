/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.interpreters.interfaces;

import std.variant;

/**
 * Context holds information that is global to the interpreter.
 * It typically stores variables and their values.
 */
interface IContext {
    /**
     * Set a variable value in the context.
     */
    void setVariable(string name, Variant value);
    
    /**
     * Get a variable value from the context.
     */
    Variant getVariable(string name) const;
    
    /**
     * Check if a variable exists in the context.
     */
    @safe bool hasVariable(string name) const;
    
    /**
     * Clear all variables from the context.
     */
    @safe void clear();
    
    /**
     * Get all variable names.
     */
    @safe string[] getVariableNames() const;
}

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
    @safe string toString() const;
}

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

/**
 * Nonterminal expression represents composite nodes that combine
 * other expressions using operators or rules.
 */
interface INonterminalExpression : IExpression {
    /**
     * Get the child expressions.
     */
    @safe IExpression[] getChildren() const;
}

/**
 * Binary expression has two operands (left and right).
 */
interface IBinaryExpression : INonterminalExpression {
    /**
     * Get the left operand.
     */
    @safe IExpression getLeft() const;
    
    /**
     * Get the right operand.
     */
    @safe IExpression getRight() const;
    
    /**
     * Get the operator symbol.
     */
    @safe string getOperator() const;
}

/**
 * Unary expression has one operand.
 */
interface IUnaryExpression : INonterminalExpression {
    /**
     * Get the operand.
     */
    @safe IExpression getOperand() const;
    
    /**
     * Get the operator symbol.
     */
    @safe string getOperator() const;
}

/**
 * Variable expression represents a variable reference.
 */
interface IVariableExpression : ITerminalExpression {
    /**
     * Get the variable name.
     */
    @safe string getName() const;
}

/**
 * Literal expression represents a constant value.
 */
interface ILiteralExpression : ITerminalExpression {
    // Inherits getValue() from ITerminalExpression
}

/**
 * Parser builds an abstract syntax tree from input text.
 */
interface IParser {
    /**
     * Parse input string into an expression tree.
     */
    @safe IExpression parse(string input);
    
    /**
     * Check if the input is valid without parsing.
     */
    @safe bool validate(string input) const;
}

/**
 * Expression factory creates specific types of expressions.
 */
interface IExpressionFactory {
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
    @safe IBinaryExpression createBinary(string operator, IExpression left, IExpression right);
    
    /**
     * Create a unary expression.
     */
    @safe IUnaryExpression createUnary(string operator, IExpression operand);
}

/**
 * Interpreter evaluates expressions in a specific language.
 */
interface IInterpreter {
    /**
     * Evaluate an expression with the given context.
     */
    @safe Variant evaluate(IExpression expression, IContext context);
    
    /**
     * Parse and evaluate input string.
     */
    @safe Variant evaluate(string input, IContext context);
    
    /**
     * Get the parser used by this interpreter.
     */
    @safe IParser getParser();
}

/**
 * Visitor for expression trees (for operations like optimization, printing).
 */
interface IExpressionVisitor {
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

/**
 * Expression optimizer transforms expressions into more efficient forms.
 */
interface IExpressionOptimizer {
    /**
     * Optimize an expression tree.
     */
    @safe IExpression optimize(IExpression expression);
    
    /**
     * Check if optimization is possible.
     */
    @safe bool canOptimize(IExpression expression) const;
}

/**
 * Grammar defines the language rules.
 */
interface IGrammar {
    /**
     * Get all valid operators.
     */
    @safe string[] getOperators() const;
    
    /**
     * Get operator precedence (higher value = higher precedence).
     */
    @safe int getPrecedence(string operator) const;
    
    /**
     * Check if operator is valid.
     */
    @safe bool isValidOperator(string operator) const;
    
    /**
     * Check if operator is binary.
     */
    @safe bool isBinaryOperator(string operator) const;
    
    /**
     * Check if operator is unary.
     */
    @safe bool isUnaryOperator(string operator) const;
}
