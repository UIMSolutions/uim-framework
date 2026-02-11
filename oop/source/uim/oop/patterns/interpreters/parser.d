module uim.oop.patterns.interpreters.parser;

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