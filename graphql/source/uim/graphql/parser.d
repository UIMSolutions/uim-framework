/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphql.parser;

import std.string;
import std.array;
import std.algorithm;
import std.conv;
import std.json;

@safe:

/**
 * GraphQL parse exception
 */
class GraphQLParseException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow @safe {
        super(msg, file, line);
    }
}

/**
 * Token types
 */
enum TokenType {
    EOF,
    NAME,
    INT,
    FLOAT,
    STRING,
    LBRACE,      // {
    RBRACE,      // }
    LPAREN,      // (
    RPAREN,      // )
    LBRACKET,    // [
    RBRACKET,    // ]
    COLON,       // :
    COMMA,       // ,
    DOLLAR,      // $
    AT,          // @
    BANG,        // !
    EQUALS,      // =
    PIPE,        // |
    SPREAD       // ...
}

/**
 * Token
 */
struct Token {
    TokenType type;
    string value;
    size_t line;
    size_t column;
}

/**
 * Lexer for GraphQL
 */
class GraphQLLexer {
    private string source;
    private size_t pos;
    private size_t line = 1;
    private size_t column = 1;
    
    this(string source) pure nothrow @safe {
        this.source = source;
        this.pos = 0;
    }
    
    Token nextToken() @safe {
        skipWhitespaceAndComments();
        
        if (isEof()) {
            return Token(TokenType.EOF, "", line, column);
        }
        
        char c = peek();
        size_t startLine = line;
        size_t startColumn = column;
        
        // Single character tokens
        switch (c) {
            case '{': advance(); return Token(TokenType.LBRACE, "{", startLine, startColumn);
            case '}': advance(); return Token(TokenType.RBRACE, "}", startLine, startColumn);
            case '(': advance(); return Token(TokenType.LPAREN, "(", startLine, startColumn);
            case ')': advance(); return Token(TokenType.RPAREN, ")", startLine, startColumn);
            case '[': advance(); return Token(TokenType.LBRACKET, "[", startLine, startColumn);
            case ']': advance(); return Token(TokenType.RBRACKET, "]", startLine, startColumn);
            case ':': advance(); return Token(TokenType.COLON, ":", startLine, startColumn);
            case ',': advance(); return Token(TokenType.COMMA, ",", startLine, startColumn);
            case '$': advance(); return Token(TokenType.DOLLAR, "$", startLine, startColumn);
            case '@': advance(); return Token(TokenType.AT, "@", startLine, startColumn);
            case '!': advance(); return Token(TokenType.BANG, "!", startLine, startColumn);
            case '=': advance(); return Token(TokenType.EQUALS, "=", startLine, startColumn);
            case '|': advance(); return Token(TokenType.PIPE, "|", startLine, startColumn);
            case '.':
                if (pos + 2 < source.length && source[pos+1] == '.' && source[pos+2] == '.') {
                    advance();
                    advance();
                    advance();
                    return Token(TokenType.SPREAD, "...", startLine, startColumn);
                }
                break;
            case '"':
                return readString(startLine, startColumn);
            default:
                break;
        }
        
        // Numbers
        if (c >= '0' && c <= '9' || c == '-') {
            return readNumber(startLine, startColumn);
        }
        
        // Names
        if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c == '_') {
            return readName(startLine, startColumn);
        }
        
        throw new GraphQLParseException("Unexpected character: " ~ c);
    }
    
    private Token readName(size_t startLine, size_t startColumn) @safe {
        size_t start = pos;
        while (!isEof()) {
            char c = peek();
            if (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z' || c >= '0' && c <= '9' || c == '_') {
                advance();
            } else {
                break;
            }
        }
        return Token(TokenType.NAME, source[start .. pos], startLine, startColumn);
    }
    
    private Token readNumber(size_t startLine, size_t startColumn) @safe {
        size_t start = pos;
        bool isFloat = false;
        
        if (peek() == '-') {
            advance();
        }
        
        while (!isEof() && peek() >= '0' && peek() <= '9') {
            advance();
        }
        
        if (!isEof() && peek() == '.') {
            isFloat = true;
            advance();
            while (!isEof() && peek() >= '0' && peek() <= '9') {
                advance();
            }
        }
        
        if (!isEof() && (peek() == 'e' || peek() == 'E')) {
            isFloat = true;
            advance();
            if (!isEof() && (peek() == '+' || peek() == '-')) {
                advance();
            }
            while (!isEof() && peek() >= '0' && peek() <= '9') {
                advance();
            }
        }
        
        string value = source[start .. pos];
        return Token(isFloat ? TokenType.FLOAT : TokenType.INT, value, startLine, startColumn);
    }
    
    private Token readString(size_t startLine, size_t startColumn) @safe {
        advance(); // Skip opening quote
        size_t start = pos;
        
        while (!isEof() && peek() != '"') {
            if (peek() == '\\') {
                advance();
                if (!isEof()) {
                    advance();
                }
            } else {
                advance();
            }
        }
        
        if (isEof()) {
            throw new GraphQLParseException("Unterminated string");
        }
        
        string value = source[start .. pos];
        advance(); // Skip closing quote
        
        return Token(TokenType.STRING, value, startLine, startColumn);
    }
    
    private void skipWhitespaceAndComments() pure nothrow @safe {
        while (!isEof()) {
            char c = peek();
            if (c == ' ' || c == '\t' || c == '\r') {
                advance();
            } else if (c == '\n') {
                advance();
                line++;
                column = 1;
            } else if (c == '#') {
                // Skip comment line
                while (!isEof() && peek() != '\n') {
                    advance();
                }
            } else {
                break;
            }
        }
    }
    
    private char peek() const pure nothrow @safe {
        if (isEof()) return '\0';
        return source[pos];
    }
    
    private void advance() pure nothrow @safe {
        if (!isEof()) {
            pos++;
            column++;
        }
    }
    
    private bool isEof() const pure nothrow @safe {
        return pos >= source.length;
    }
}

/**
 * AST Node types
 */
enum NodeType {
    DOCUMENT,
    OPERATION_DEFINITION,
    FIELD,
    ARGUMENT,
    VARIABLE_DEFINITION,
    SELECTION_SET,
    FRAGMENT_DEFINITION,
    FRAGMENT_SPREAD,
    INLINE_FRAGMENT
}

/**
 * Base AST Node
 */
abstract class ASTNode {
    NodeType nodeType;
    
    this(NodeType type) pure nothrow @safe {
        this.nodeType = type;
    }
}

/**
 * Document node (root)
 */
class DocumentNode : ASTNode {
    ASTNode[] definitions;
    
    this() pure nothrow @safe {
        super(NodeType.DOCUMENT);
    }
}

/**
 * Operation type
 */
enum OperationType {
    QUERY,
    MUTATION,
    SUBSCRIPTION
}

/**
 * Operation definition node
 */
class OperationDefinitionNode : ASTNode {
    OperationType operation;
    string name;
    VariableDefinitionNode[] variableDefinitions;
    SelectionSetNode selectionSet;
    
    this() pure nothrow @safe {
        super(NodeType.OPERATION_DEFINITION);
    }
}

/**
 * Selection set node
 */
class SelectionSetNode : ASTNode {
    ASTNode[] selections;
    
    this() pure nothrow @safe {
        super(NodeType.SELECTION_SET);
    }
}

/**
 * Field node
 */
class FieldNode : ASTNode {
    string aliasName;
    string name;
    ArgumentNode[] arguments;
    SelectionSetNode selectionSet;
    
    this() pure nothrow @safe {
        super(NodeType.FIELD);
    }
}

/**
 * Argument node
 */
class ArgumentNode : ASTNode {
    string name;
    JSONValue value;
    
    this() pure nothrow @safe {
        super(NodeType.ARGUMENT);
    }
}

/**
 * Variable definition node
 */
class VariableDefinitionNode : ASTNode {
    string variable;
    string type;
    JSONValue defaultValue;
    
    this() pure nothrow @safe {
        super(NodeType.VARIABLE_DEFINITION);
    }
}

/**
 * Fragment definition node
 */
class FragmentDefinitionNode : ASTNode {
    string name;
    string typeCondition;
    SelectionSetNode selectionSet;
    
    this() pure nothrow @safe {
        super(NodeType.FRAGMENT_DEFINITION);
    }
}

/**
 * GraphQL Parser
 */
class GraphQLParser {
    private GraphQLLexer lexer;
    private Token currentToken;
    
    this(string source) @safe {
        lexer = new GraphQLLexer(source);
        advance();
    }
    
    DocumentNode parse() @safe {
        auto doc = new DocumentNode();
        
        while (currentToken.type != TokenType.EOF) {
            if (currentToken.type == TokenType.NAME) {
                if (currentToken.value == "query" || currentToken.value == "mutation" || currentToken.value == "subscription") {
                    doc.definitions ~= parseOperationDefinition();
                } else if (currentToken.value == "fragment") {
                    doc.definitions ~= parseFragmentDefinition();
                } else {
                    // Shorthand query
                    auto op = new OperationDefinitionNode();
                    op.operation = OperationType.QUERY;
                    op.selectionSet = parseSelectionSet();
                    doc.definitions ~= op;
                }
            } else if (currentToken.type == TokenType.LBRACE) {
                // Shorthand query
                auto op = new OperationDefinitionNode();
                op.operation = OperationType.QUERY;
                op.selectionSet = parseSelectionSet();
                doc.definitions ~= op;
            } else {
                throw new GraphQLParseException("Unexpected token: " ~ currentToken.value);
            }
        }
        
        return doc;
    }
    
    private OperationDefinitionNode parseOperationDefinition() @safe {
        auto op = new OperationDefinitionNode();
        
        // Operation type
        if (currentToken.value == "query") {
            op.operation = OperationType.QUERY;
        } else if (currentToken.value == "mutation") {
            op.operation = OperationType.MUTATION;
        } else if (currentToken.value == "subscription") {
            op.operation = OperationType.SUBSCRIPTION;
        }
        advance();
        
        // Optional name
        if (currentToken.type == TokenType.NAME) {
            op.name = currentToken.value;
            advance();
        }
        
        // Optional variable definitions
        if (currentToken.type == TokenType.LPAREN) {
            advance();
            while (currentToken.type != TokenType.RPAREN) {
                op.variableDefinitions ~= parseVariableDefinition();
                if (currentToken.type == TokenType.COMMA) {
                    advance();
                }
            }
            expect(TokenType.RPAREN);
        }
        
        // Selection set
        op.selectionSet = parseSelectionSet();
        
        return op;
    }
    
    private SelectionSetNode parseSelectionSet() @safe {
        auto set = new SelectionSetNode();
        
        expect(TokenType.LBRACE);
        
        while (currentToken.type != TokenType.RBRACE) {
            set.selections ~= parseField();
        }
        
        expect(TokenType.RBRACE);
        
        return set;
    }
    
    private FieldNode parseField() @safe {
        auto field = new FieldNode();
        
        // Check for alias
        if (currentToken.type == TokenType.NAME) {
            string firstName = currentToken.value;
            advance();
            
            if (currentToken.type == TokenType.COLON) {
                advance();
                field.aliasName = firstName;
                field.name = currentToken.value;
                advance();
            } else {
                field.name = firstName;
            }
        }
        
        // Arguments
        if (currentToken.type == TokenType.LPAREN) {
            advance();
            while (currentToken.type != TokenType.RPAREN) {
                field.arguments ~= parseArgument();
                if (currentToken.type == TokenType.COMMA) {
                    advance();
                }
            }
            expect(TokenType.RPAREN);
        }
        
        // Selection set
        if (currentToken.type == TokenType.LBRACE) {
            field.selectionSet = parseSelectionSet();
        }
        
        return field;
    }
    
    private ArgumentNode parseArgument() @safe {
        auto arg = new ArgumentNode();
        
        arg.name = currentToken.value;
        expect(TokenType.NAME);
        expect(TokenType.COLON);
        arg.value = parseValue();
        
        return arg;
    }
    
    private VariableDefinitionNode parseVariableDefinition() @safe {
        auto varDef = new VariableDefinitionNode();
        
        expect(TokenType.DOLLAR);
        varDef.variable = currentToken.value;
        expect(TokenType.NAME);
        expect(TokenType.COLON);
        varDef.type = parseType();
        
        if (currentToken.type == TokenType.EQUALS) {
            advance();
            varDef.defaultValue = parseValue();
        }
        
        return varDef;
    }
    
    private FragmentDefinitionNode parseFragmentDefinition() @safe {
        auto frag = new FragmentDefinitionNode();
        
        expect(TokenType.NAME); // "fragment"
        frag.name = currentToken.value;
        expect(TokenType.NAME);
        
        // "on"
        if (currentToken.type == TokenType.NAME && currentToken.value == "on") {
            advance();
        }
        
        frag.typeCondition = currentToken.value;
        expect(TokenType.NAME);
        
        frag.selectionSet = parseSelectionSet();
        
        return frag;
    }
    
    private string parseType() @safe {
        string typeName;
        
        if (currentToken.type == TokenType.LBRACKET) {
            advance();
            typeName = "[" ~ parseType() ~ "]";
            expect(TokenType.RBRACKET);
        } else {
            typeName = currentToken.value;
            expect(TokenType.NAME);
        }
        
        if (currentToken.type == TokenType.BANG) {
            advance();
            typeName ~= "!";
        }
        
        return typeName;
    }
    
    private JSONValue parseValue() @safe {
        switch (currentToken.type) {
            case TokenType.INT:
                long val = to!long(currentToken.value);
                advance();
                return JSONValue(val);
            case TokenType.FLOAT:
                double val = to!double(currentToken.value);
                advance();
                return JSONValue(val);
            case TokenType.STRING:
                string val = currentToken.value;
                advance();
                return JSONValue(val);
            case TokenType.NAME:
                string val = currentToken.value;
                advance();
                if (val == "true") return JSONValue(true);
                if (val == "false") return JSONValue(false);
                if (val == "null") return JSONValue(null);
                return JSONValue(val);
            case TokenType.LBRACKET:
                return parseListValue();
            case TokenType.LBRACE:
                return parseObjectValue();
            case TokenType.DOLLAR:
                advance();
                string varName = currentToken.value;
                advance();
                return JSONValue("$" ~ varName);
            default:
                throw new GraphQLParseException("Expected value");
        }
    }
    
    private JSONValue parseListValue() @safe {
        JSONValue[] values;
        expect(TokenType.LBRACKET);
        
        while (currentToken.type != TokenType.RBRACKET) {
            values ~= parseValue();
            if (currentToken.type == TokenType.COMMA) {
                advance();
            }
        }
        
        expect(TokenType.RBRACKET);
        return JSONValue(values);
    }
    
    private JSONValue parseObjectValue() @safe {
        JSONValue[string] obj;
        expect(TokenType.LBRACE);
        
        while (currentToken.type != TokenType.RBRACE) {
            string key = currentToken.value;
            expect(TokenType.NAME);
            expect(TokenType.COLON);
            obj[key] = parseValue();
            
            if (currentToken.type == TokenType.COMMA) {
                advance();
            }
        }
        
        expect(TokenType.RBRACE);
        return JSONValue(obj);
    }
    
    private void advance() @safe {
        currentToken = lexer.nextToken();
    }
    
    private void expect(TokenType type) @safe {
        if (currentToken.type != type) {
            throw new GraphQLParseException("Expected " ~ to!string(type) ~ " but got " ~ to!string(currentToken.type));
        }
        advance();
    }
}

/**
 * Parse a GraphQL query string
 */
DocumentNode parseGraphQL(string query) @safe {
    auto parser = new GraphQLParser(query);
    return parser.parse();
}
