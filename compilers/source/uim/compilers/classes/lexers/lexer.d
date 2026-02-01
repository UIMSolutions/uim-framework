/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.lexers.lexer;

import uim.compilers;

@safe:

/**
 * Base implementation of a lexer.
 */
class Lexer : UIMObject, ILexer {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _line = 1;
    _column = 1;

    return true;
  }

  protected string _source;
  protected size_t _position;
  protected size_t _line;
  protected size_t _column;
  protected Token[] _tokens;
  protected size_t _currentIndex;
  protected Diagnostic[] _errors;

  Token[] tokenize(string source) {
    _source = source;
    _position = 0;
    _line = 1;
    _column = 1;
    _tokens = [];
    _errors = [];

    while (!isAtEnd()) {
      skipWhitespace();
      if (isAtEnd()) break;

      Token token = scanToken();
      if (token.type != TokenType.Whitespace && token.type != TokenType.Comment) {
        _tokens ~= token;
      }
    }

    // Add EOF token
    Token eofToken;
    eofToken.type = TokenType.EOF;
    eofToken.line = _line;
    eofToken.column = _column;
    _tokens ~= eofToken;

    _currentIndex = 0;
    return _tokens;
  }

  Token currentToken() {
    if (_currentIndex < _tokens.length) {
      return _tokens[_currentIndex];
    }
    return _tokens[$-1]; // EOF
  }

  Token nextToken() {
    if (_currentIndex < _tokens.length - 1) {
      _currentIndex++;
    }
    return currentToken();
  }

  Token peekToken(size_t offset = 1) {
    size_t index = _currentIndex + offset;
    if (index < _tokens.length) {
      return _tokens[index];
    }
    return _tokens[$-1]; // EOF
  }

  bool hasMoreTokens() {
    return _currentIndex < _tokens.length - 1;
  }

  Diagnostic[] errors() {
    return _errors;
  }

  protected Token scanToken() {
    char c = advance();

    Token token;
    token.line = _line;
    token.column = _column - 1;

    // Single character tokens
    switch (c) {
      case '(': return makeToken(TokenType.LeftParen, "(");
      case ')': return makeToken(TokenType.RightParen, ")");
      case '{': return makeToken(TokenType.LeftBrace, "{");
      case '}': return makeToken(TokenType.RightBrace, "}");
      case '[': return makeToken(TokenType.LeftBracket, "[");
      case ']': return makeToken(TokenType.RightBracket, "]");
      case ';': return makeToken(TokenType.Semicolon, ";");
      case ',': return makeToken(TokenType.Comma, ",");
      case '.': return makeToken(TokenType.Dot, ".");
      case ':': return makeToken(TokenType.Colon, ":");
      case '+':
        if (match('+')) return makeToken(TokenType.Increment, "++");
        return makeToken(TokenType.Plus, "+");
      case '-':
        if (match('-')) return makeToken(TokenType.Decrement, "--");
        if (match('>')) return makeToken(TokenType.Arrow, "->");
        return makeToken(TokenType.Minus, "-");
      case '*': return makeToken(TokenType.Star, "*");
      case '%': return makeToken(TokenType.Percent, "%");
      case '!':
        if (match('=')) return makeToken(TokenType.NotEqual, "!=");
        return makeToken(TokenType.LogicalNot, "!");
      case '=':
        if (match('=')) return makeToken(TokenType.Equal, "==");
        if (match('>')) return makeToken(TokenType.FatArrow, "=>");
        return makeToken(TokenType.Assign, "=");
      case '<':
        if (match('=')) return makeToken(TokenType.LessEqual, "<=");
        if (match('<')) return makeToken(TokenType.LeftShift, "<<");
        return makeToken(TokenType.Less, "<");
      case '>':
        if (match('=')) return makeToken(TokenType.GreaterEqual, ">=");
        if (match('>')) return makeToken(TokenType.RightShift, ">>");
        return makeToken(TokenType.Greater, ">");
      case '&':
        if (match('&')) return makeToken(TokenType.LogicalAnd, "&&");
        return makeToken(TokenType.BitwiseAnd, "&");
      case '|':
        if (match('|')) return makeToken(TokenType.LogicalOr, "||");
        return makeToken(TokenType.BitwiseOr, "|");
      case '^': return makeToken(TokenType.BitwiseXor, "^");
      case '~': return makeToken(TokenType.BitwiseNot, "~");
      case '/':
        if (match('/')) return scanLineComment();
        if (match('*')) return scanBlockComment();
        return makeToken(TokenType.Slash, "/");
      case '"': return scanString();
      case '\'': return scanChar();
      default:
        if (isNumber(c)) return scanNumber();
        if (isAlpha(c) || c == '_') return scanIdentifier();
        return makeErrorToken("Unexpected character");
    }
  }

  protected Token scanIdentifier() {
    size_t start = _position - 1;
    while (!isAtEnd() && (isAlphaNum(peek()) || peek() == '_')) {
      advance();
    }
    string value = _source[start.._position];
    return makeToken(identifierType(value), value);
  }

  protected Token scanNumber() {
    size_t start = _position - 1;
    bool isFloat = false;

    while (!isAtEnd() && isNumber(peek())) {
      advance();
    }

    if (!isAtEnd() && peek() == '.' && _position + 1 < _source.length && isNumber(_source[_position + 1])) {
      isFloat = true;
      advance(); // consume '.'
      while (!isAtEnd() && isNumber(peek())) {
        advance();
      }
    }

    string value = _source[start.._position];
    return makeToken(isFloat ? TokenType.FloatLiteral : TokenType.IntegerLiteral, value);
  }

  protected Token scanString() {
    size_t start = _position;
    while (!isAtEnd() && peek() != '"') {
      if (peek() == '\n') _line++;
      advance();
    }

    if (isAtEnd()) {
      return makeErrorToken("Unterminated string");
    }

    string value = _source[start.._position];
    advance(); // closing "
    return makeToken(TokenType.StringLiteral, value);
  }

  protected Token scanChar() {
    size_t start = _position;
    if (!isAtEnd()) advance();
    if (isAtEnd() || peek() != '\'') {
      return makeErrorToken("Unterminated character literal");
    }
    string value = _source[start.._position];
    advance(); // closing '
    return makeToken(TokenType.CharLiteral, value);
  }

  protected Token scanLineComment() {
    while (!isAtEnd() && peek() != '\n') {
      advance();
    }
    return makeToken(TokenType.Comment, "");
  }

  protected Token scanBlockComment() {
    while (!isAtEnd()) {
      if (peek() == '*' && peekNext() == '/') {
        advance(); // *
        advance(); // /
        break;
      }
      if (peek() == '\n') _line++;
      advance();
    }
    return makeToken(TokenType.Comment, "");
  }

  protected TokenType identifierType(string text) {
    switch (text) {
      case "if": return TokenType.If;
      case "else": return TokenType.Else;
      case "while": return TokenType.While;
      case "for": return TokenType.For;
      case "break": return TokenType.Break;
      case "continue": return TokenType.Continue;
      case "return": return TokenType.Return;
      case "function": return TokenType.Function;
      case "class": return TokenType.Class;
      case "struct": return TokenType.Struct;
      case "interface": return TokenType.Interface;
      case "enum": return TokenType.Enum;
      case "import": return TokenType.Import;
      case "module": return TokenType.Module;
      case "public": return TokenType.Public;
      case "private": return TokenType.Private;
      case "protected": return TokenType.Protected;
      case "static": return TokenType.Static;
      case "const": return TokenType.Const;
      case "var": return TokenType.Var;
      case "let": return TokenType.Let;
      case "true": return TokenType.True;
      case "false": return TokenType.False;
      case "null": return TokenType.Null;
      default: return TokenType.Identifier;
    }
  }

  protected Token makeToken(TokenType type, string value) {
    Token token;
    token.type = type;
    token.value = value;
    token.line = _line;
    token.column = _column - value.length;
    token.length = value.length;
    return token;
  }

  protected Token makeErrorToken(string message) {
    Diagnostic diag;
    diag.severity = DiagnosticSeverity.Error;
    diag.message = message;
    diag.line = _line;
    diag.column = _column;
    _errors ~= diag;

    Token token;
    token.type = TokenType.Error;
    token.value = message;
    token.line = _line;
    token.column = _column;
    return token;
  }

  protected char advance() {
    _column++;
    return _source[_position++];
  }

  protected char peek() {
    if (isAtEnd()) return '\0';
    return _source[_position];
  }

  protected char peekNext() {
    if (_position + 1 >= _source.length) return '\0';
    return _source[_position + 1];
  }

  protected bool match(char expected) {
    if (isAtEnd()) return false;
    if (_source[_position] != expected) return false;
    _position++;
    _column++;
    return true;
  }

  protected void skipWhitespace() {
    while (!isAtEnd() && isWhite(peek())) {
      if (peek() == '\n') {
        _line++;
        _column = 0;
      }
      advance();
    }
  }

  protected bool isAtEnd() {
    return _position >= _source.length;
  }
}
