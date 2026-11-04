module uim.xml.xpath.parser;

import std.conv : to;
import uim.xml.xpath.ast;
import uim.xml.xpath.lexer;
import uim.xml.xpath.types;

class XPathParser {
    private XPathLexer lexer;

    this() {
        this(new XPathLexer);
    }

    this(XPathLexer lexer) {
        this.lexer = lexer;
    }

    // Parses an XPath location path expression into an AST
    ASTNode parse(string expression) {
        lexer.setInput(expression);
        auto path = parsePath();
        expect(TokenType.EndOfInput);
        return path;
    }

    // path: ("/" | "//")? step (("/" | "//") step)*
    private PathNode parsePath() {
        auto path = new PathNode;
        auto token = lexer.peekToken();

        if (token.type == TokenType.Slash) {
            path.absolute = true;
            lexer.nextToken();
            // "/" alone selects the context (document) node itself
            if (lexer.peekToken().type == TokenType.EndOfInput) {
                return path;
            }
            path.steps ~= parseStep(StepAxis.Child);
        } else if (token.type == TokenType.DoubleSlash) {
            path.absolute = true;
            lexer.nextToken();
            path.steps ~= parseStep(StepAxis.Descendant);
        } else {
            path.steps ~= parseStep(StepAxis.Child);
        }

        while (true) {
            token = lexer.peekToken();
            if (token.type == TokenType.Slash) {
                lexer.nextToken();
                path.steps ~= parseStep(StepAxis.Child);
            } else if (token.type == TokenType.DoubleSlash) {
                lexer.nextToken();
                path.steps ~= parseStep(StepAxis.Descendant);
            } else {
                break;
            }
        }
        return path;
    }

    // step: "." | ".." | "@" name | name | "*" ("[" predicate "]")*
    private StepNode parseStep(StepAxis axis) {
        auto token = lexer.nextToken();
        StepNode step;

        switch (token.type) {
            case TokenType.Dot:
                step = new StepNode(StepAxis.Self);
                break;
            case TokenType.DoubleDot:
                step = new StepNode(StepAxis.Parent);
                break;
            case TokenType.At:
                step = new StepNode(StepAxis.Attribute, expect(TokenType.Identifier).value);
                break;
            case TokenType.Wildcard:
                step = new StepNode(axis, "*");
                break;
            case TokenType.Identifier:
                step = new StepNode(axis, token.value);
                break;
            default:
                throw new XPathException("Unexpected token '" ~ token.value
                    ~ "' at position " ~ token.position.to!string);
        }

        while (lexer.peekToken().type == TokenType.LBracket) {
            lexer.nextToken();
            step.predicates ~= parsePredicate();
            expect(TokenType.RBracket);
        }
        return step;
    }

    // predicate: "@" name ("=" string)? | number
    private PredicateNode parsePredicate() {
        auto token = lexer.nextToken();

        if (token.type == TokenType.At) {
            string name = expect(TokenType.Identifier).value;
            if (lexer.peekToken().type == TokenType.Equals) {
                lexer.nextToken();
                string value = expect(TokenType.String).value;
                return new AttributeEqualsPredicate(name, value);
            }
            return new AttributeExistsPredicate(name);
        }

        if (token.type == TokenType.Number) {
            return new PositionPredicate(token.value.to!size_t);
        }

        throw new XPathException("Unexpected predicate token '" ~ token.value
            ~ "' at position " ~ token.position.to!string);
    }

    private XPathToken expect(TokenType type) {
        auto token = lexer.nextToken();
        if (token.type != type) {
            throw new XPathException("Expected token type " ~ type.to!string
                ~ " but got '" ~ token.value ~ "' at position " ~ token.position.to!string);
        }
        return token;
    }
}
