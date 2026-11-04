module uim.xml.xpath.lexer;

import std.ascii : isAlpha, isDigit;
import std.conv : to;
import uim.xml.xpath.types;

class XPathLexer {
    private string input;
    private XPathToken[] tokens;
    private size_t tokenIndex;

    this(string input = null) {
        setInput(input);
    }

    // Sets a new expression and lexes it eagerly
    void setInput(string expression) {
        input = expression;
        tokens = lexAll(expression);
        tokenIndex = 0;
    }

    // Returns all tokens of the current expression (terminated by EndOfInput)
    XPathToken[] tokenize() {
        return tokens.dup;
    }

    // Lexes a new expression and returns its tokens
    XPathToken[] tokenize(string expression) {
        setInput(expression);
        return tokenize();
    }

    // Returns the current token without consuming it
    XPathToken peekToken() {
        return tokenIndex < tokens.length
            ? tokens[tokenIndex]
            : XPathToken(TokenType.EndOfInput, null, input.length);
    }

    // Returns the current token and advances
    XPathToken nextToken() {
        auto token = peekToken();
        if (tokenIndex < tokens.length) {
            tokenIndex++;
        }
        return token;
    }

    private XPathToken[] lexAll(string expression) {
        XPathToken[] result;
        size_t position;

        while (position < expression.length) {
            char current = expression[position];

            if (isWhitespace(current)) {
                position++;
            } else if (current == '/') {
                if (position + 1 < expression.length && expression[position + 1] == '/') {
                    result ~= XPathToken(TokenType.DoubleSlash, "//", position);
                    position += 2;
                } else {
                    result ~= XPathToken(TokenType.Slash, "/", position);
                    position++;
                }
            } else if (current == '@') {
                result ~= XPathToken(TokenType.At, "@", position);
                position++;
            } else if (current == '.') {
                if (position + 1 < expression.length && expression[position + 1] == '.') {
                    result ~= XPathToken(TokenType.DoubleDot, "..", position);
                    position += 2;
                } else {
                    result ~= XPathToken(TokenType.Dot, ".", position);
                    position++;
                }
            } else if (current == '[') {
                result ~= XPathToken(TokenType.LBracket, "[", position);
                position++;
            } else if (current == ']') {
                result ~= XPathToken(TokenType.RBracket, "]", position);
                position++;
            } else if (current == '(') {
                result ~= XPathToken(TokenType.LParen, "(", position);
                position++;
            } else if (current == ')') {
                result ~= XPathToken(TokenType.RParen, ")", position);
                position++;
            } else if (current == '=') {
                result ~= XPathToken(TokenType.Equals, "=", position);
                position++;
            } else if (current == ',') {
                result ~= XPathToken(TokenType.Comma, ",", position);
                position++;
            } else if (current == '*') {
                result ~= XPathToken(TokenType.Wildcard, "*", position);
                position++;
            } else if (current == '+' || current == '-') {
                result ~= XPathToken(TokenType.Operator, current.to!string, position);
                position++;
            } else if (current == '"' || current == '\'') {
                result ~= readString(expression, position);
            } else if (isDigit(current)) {
                result ~= readNumber(expression, position);
            } else if (isIdentifierStart(current)) {
                result ~= readIdentifier(expression, position);
            } else {
                throw new XPathException("Unexpected character '" ~ current.to!string
                    ~ "' at position " ~ position.to!string);
            }
        }

        result ~= XPathToken(TokenType.EndOfInput, null, expression.length);
        return result;
    }

    private XPathToken readIdentifier(string expression, ref size_t position) {
        size_t start = position;
        while (position < expression.length && isIdentifierChar(expression[position])) {
            position++;
        }
        string value = expression[start .. position];
        // an identifier directly followed by '(' is a function call
        bool isFunction = position < expression.length && expression[position] == '(';
        return XPathToken(isFunction ? TokenType.Function : TokenType.Identifier, value, start);
    }

    private XPathToken readNumber(string expression, ref size_t position) {
        size_t start = position;
        while (position < expression.length && isDigit(expression[position])) {
            position++;
        }
        if (position + 1 < expression.length
            && expression[position] == '.' && isDigit(expression[position + 1])) {
            position++;
            while (position < expression.length && isDigit(expression[position])) {
                position++;
            }
        }
        return XPathToken(TokenType.Number, expression[start .. position], start);
    }

    private XPathToken readString(string expression, ref size_t position) {
        char quote = expression[position];
        size_t start = position;
        position++; // skip the opening quote
        size_t contentStart = position;
        while (position < expression.length && expression[position] != quote) {
            position++;
        }
        if (position >= expression.length) {
            throw new XPathException("Unterminated string literal at position " ~ start.to!string);
        }
        string value = expression[contentStart .. position];
        position++; // skip the closing quote
        return XPathToken(TokenType.String, value, start);
    }

    private bool isWhitespace(char c) {
        return c == ' ' || c == '\t' || c == '\n' || c == '\r';
    }

    private bool isIdentifierStart(char c) {
        return isAlpha(c) || c == '_';
    }

    private bool isIdentifierChar(char c) {
        return isAlpha(c) || isDigit(c) || c == '_' || c == '-' || c == ':';
    }
}
