module uim.oop.patterns.interpreters.interfaces.parser;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Parser builds an abstract syntax tree from input text.
 */
interface IParser {
    /**
     * Parse input string into an expression tree.
     */
    IInterpreterExpression parse(string input);
    
    /**
     * Check if the input is valid without parsing.
     */
    bool validate(string input) const;
}