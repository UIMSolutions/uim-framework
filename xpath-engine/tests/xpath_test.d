module xpath_test;

import xpath.parser;
import xpath.evaluator;
import xpath.lexer;
import xpath.ast;
import xpath.types;

import std.stdio;
import std.testing;

void testParser() {
    auto parser = new XPathParser();
    auto ast = parser.parse("/bookstore/book/title");
    // Add assertions to validate the structure of the AST
    assert(ast !is null);
}

void testEvaluator() {
    auto evaluator = new XPathEvaluator();
    auto contextNode = ...; // Define a context node for evaluation
    auto ast = ...; // Obtain an AST from a valid XPath expression
    auto result = evaluator.evaluate(ast, contextNode);
    // Add assertions to validate the evaluation result
    assert(result !is null);
}

void testLexer() {
    auto lexer = new XPathLexer();
    auto tokens = lexer.tokenize("/bookstore/book/title");
    // Add assertions to validate the tokens generated
    assert(tokens.length > 0);
}

void main() {
    testParser();
    testEvaluator();
    testLexer();
}