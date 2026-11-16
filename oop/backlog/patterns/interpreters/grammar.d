module uim.oop.patterns.interpreters.grammar;

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