module xpath.types;

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