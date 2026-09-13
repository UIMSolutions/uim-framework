module xpath;

import std.array;
import std.string;

class XPathLexer {
    enum TokenType {
        Identifier,
        Number,
        String,
        Operator,
        Function,
        // Add more token types as needed
    }

    struct Token {
        TokenType type;
        string value;
    }

    private string input;
    private size_t position;

    this(string input) {
        this.input = input;
        this.position = 0;
    }

    Token[] tokenize() {
        Token[] tokens;
        while (position < input.length) {
            char current = input[position];

            if (isWhitespace(current)) {
                position++;
                continue;
            } else if (isIdentifierStart(current)) {
                tokens ~= readIdentifier();
            } else if (isDigit(current)) {
                tokens ~= readNumber();
            } else if (current == '"') {
                tokens ~= readString();
            } else if (isOperator(current)) {
                tokens ~= readOperator();
            } else {
                // Handle unexpected characters
                throw new Exception("Unexpected character: " ~ current);
            }
        }
        return tokens;
    }

    private bool isWhitespace(char c) {
        return c == ' ' || c == '\t' || c == '\n' || c == '\r';
    }

    private bool isIdentifierStart(char c) {
        return isAlpha(c) || c == '_';
    }

    private bool isDigit(char c) {
        return '0' <= c && c <= '9';
    }

    private bool isOperator(char c) {
        return c == '+' || c == '-' || c == '*' || c == '/';
    }

    private Token readIdentifier() {
        size_t start = position;
        while (position < input.length && (isAlpha(input[position]) || isDigit(input[position]) || input[position] == '_')) {
            position++;
        }
        return Token(TokenType.Identifier, input[start .. position]);
    }

    private Token readNumber() {
        size_t start = position;
        while (position < input.length && isDigit(input[position])) {
            position++;
        }
        return Token(TokenType.Number, input[start .. position]);
    }

    private Token readString() {
        position++; // Skip the opening quote
        size_t start = position;
        while (position < input.length && input[position] != '"') {
            position++;
        }
        if (position >= input.length) {
            throw new Exception("Unterminated string literal");
        }
        position++; // Skip the closing quote
        return Token(TokenType.String, input[start .. position - 1]);
    }

    private Token readOperator() {
        char op = input[position++];
        return Token(TokenType.Operator, op.to!string);
    }
}