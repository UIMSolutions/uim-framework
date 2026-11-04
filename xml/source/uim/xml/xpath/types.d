module uim.xml.xpath.types;

enum TokenType {
    // Represents different types of tokens in XPath expressions
    Identifier,
    Number,
    String,
    Operator,
    Function,
    Axis,
    NodeTest,
    Wildcard,
    Slash,
    DoubleSlash,
    At,
    Dot,
    DoubleDot,
    LBracket,
    RBracket,
    LParen,
    RParen,
    Equals,
    Comma,
    EndOfInput,
    Error
}

enum ErrorCode {
    // Represents various error codes for XPath evaluation
    NoError,
    SyntaxError,
    UndefinedVariable,
    TypeError,
    EvaluationError
}

struct XPathToken {
    TokenType type;
    string value;
    size_t position;
}

struct XPathError {
    ErrorCode code;
    string message;
    size_t position;
}

class XPathException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}
