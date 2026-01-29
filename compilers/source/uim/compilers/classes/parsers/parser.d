/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.classes.parsers.parser;

import uim.compilers;

@safe:

/**
 * Base implementation of a parser.
 */
class Parser : UIMObject, ICompilerParser {
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

    return true;
  }
  protected Token[] _tokens;
  protected size_t _current;
  protected Diagnostic[] _errors;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _current = 0;

    return true;
  }

  ASTNode parse(Token[] tokens) {
    _tokens = tokens;
    _current = 0;
    _errors = [];

    auto program = new ASTNode(ASTNodeType.Program);

    while (!isAtEnd()) {
      try {
        auto decl = parseDeclaration();
        if (decl !is null) {
          program.addChild(decl);
        }
      } catch (Exception e) {
        synchronize();
      }
    }

    return program;
  }

  ASTNode parseExpression() {
    return parseAssignment();
  }

  ASTNode parseStatement() {
    if (match(TokenType.If)) return parseIfStatement();
    if (match(TokenType.While)) return parseWhileStatement();
    if (match(TokenType.For)) return parseForStatement();
    if (match(TokenType.Return)) return parseReturnStatement();
    if (match(TokenType.Break)) return parseBreakStatement();
    if (match(TokenType.Continue)) return parseContinueStatement();
    if (match(TokenType.LeftBrace)) return parseBlockStatement();

    return parseExpressionStatement();
  }

  ASTNode parseDeclaration() {
    if (match(TokenType.Function)) return parseFunctionDeclaration();
    if (match(TokenType.Class)) return parseClassDeclaration();
    if (match(TokenType.Var) || match(TokenType.Let) || match(TokenType.Const)) {
      return parseVariableDeclaration();
    }

    return parseStatement();
  }

  Diagnostic[] errors() {
    return _errors;
  }

  // Helper methods for parsing
  protected ASTNode parseAssignment() {
    auto expr = parseLogicalOr();

    if (match(TokenType.Assign)) {
      auto assignToken = previous();
      auto value = parseAssignment();

      auto node = new ASTNode(ASTNodeType.AssignmentExpression, assignToken);
      node.addChild(expr);
      node.addChild(value);
      return node;
    }

    return expr;
  }

  protected ASTNode parseLogicalOr() {
    auto expr = parseLogicalAnd();

    while (match(TokenType.LogicalOr)) {
      auto operatorToken = previous();
      auto right = parseLogicalAnd();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseLogicalAnd() {
    auto expr = parseEquality();

    while (match(TokenType.LogicalAnd)) {
      auto operatorToken = previous();
      auto right = parseEquality();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseEquality() {
    auto expr = parseComparison();

    while (match(TokenType.Equal) || match(TokenType.NotEqual)) {
      auto operatorToken = previous();
      auto right = parseComparison();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseComparison() {
    auto expr = parseTerm();

    while (match(TokenType.Less) || match(TokenType.LessEqual) || 
           match(TokenType.Greater) || match(TokenType.GreaterEqual)) {
      auto operatorToken = previous();
      auto right = parseTerm();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseTerm() {
    auto expr = parseFactor();

    while (match(TokenType.Plus) || match(TokenType.Minus)) {
      auto operatorToken = previous();
      auto right = parseFactor();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseFactor() {
    auto expr = parseUnary();

    while (match(TokenType.Star) || match(TokenType.Slash) || match(TokenType.Percent)) {
      auto operatorToken = previous();
      auto right = parseUnary();

      auto node = new ASTNode(ASTNodeType.BinaryExpression, operatorToken);
      node.addChild(expr);
      node.addChild(right);
      expr = node;
    }

    return expr;
  }

  protected ASTNode parseUnary() {
    if (match(TokenType.LogicalNot) || match(TokenType.Minus)) {
      auto operatorToken = previous();
      auto right = parseUnary();

      auto node = new ASTNode(ASTNodeType.UnaryExpression, operatorToken);
      node.addChild(right);
      return node;
    }

    return parsePostfix();
  }

  protected ASTNode parsePostfix() {
    auto expr = parsePrimary();

    while (true) {
      if (match(TokenType.LeftParen)) {
        expr = parseCallExpression(expr);
      } else if (match(TokenType.Dot)) {
        expr = parseMemberExpression(expr);
      } else if (match(TokenType.LeftBracket)) {
        expr = parseIndexExpression(expr);
      } else {
        break;
      }
    }

    return expr;
  }

  protected ASTNode parsePrimary() {
    if (match(TokenType.True) || match(TokenType.False)) {
      return new ASTNode(ASTNodeType.BoolLiteral, previous());
    }
    if (match(TokenType.Null)) {
      return new ASTNode(ASTNodeType.NullLiteral, previous());
    }
    if (match(TokenType.IntegerLiteral)) {
      return new ASTNode(ASTNodeType.IntegerLiteral, previous());
    }
    if (match(TokenType.FloatLiteral)) {
      return new ASTNode(ASTNodeType.FloatLiteral, previous());
    }
    if (match(TokenType.StringLiteral)) {
      return new ASTNode(ASTNodeType.StringLiteral, previous());
    }
    if (match(TokenType.Identifier)) {
      return new ASTNode(ASTNodeType.IdentifierExpression, previous());
    }
    if (match(TokenType.LeftParen)) {
      auto expr = parseExpression();
      consume(TokenType.RightParen, "Expected ')' after expression");
      return expr;
    }

    error("Expected expression");
    return new ASTNode(ASTNodeType.Unknown);
  }

  protected ASTNode parseCallExpression(ASTNode callee) {
    auto node = new ASTNode(ASTNodeType.CallExpression);
    node.addChild(callee);

    if (!check(TokenType.RightParen)) {
      do {
        node.addChild(parseExpression());
      } while (match(TokenType.Comma));
    }

    consume(TokenType.RightParen, "Expected ')' after arguments");
    return node;
  }

  protected ASTNode parseMemberExpression(ASTNode object) {
    auto memberToken = consume(TokenType.Identifier, "Expected property name");
    auto node = new ASTNode(ASTNodeType.MemberExpression, memberToken);
    node.addChild(object);
    return node;
  }

  protected ASTNode parseIndexExpression(ASTNode array) {
    auto node = new ASTNode(ASTNodeType.IndexExpression);
    node.addChild(array);
    node.addChild(parseExpression());
    consume(TokenType.RightBracket, "Expected ']' after index");
    return node;
  }

  protected ASTNode parseBlockStatement() {
    auto node = new ASTNode(ASTNodeType.BlockStatement);

    while (!check(TokenType.RightBrace) && !isAtEnd()) {
      node.addChild(parseDeclaration());
    }

    consume(TokenType.RightBrace, "Expected '}' after block");
    return node;
  }

  protected ASTNode parseIfStatement() {
    consume(TokenType.LeftParen, "Expected '(' after 'if'");
    auto condition = parseExpression();
    consume(TokenType.RightParen, "Expected ')' after condition");

    auto thenBranch = parseStatement();
    ASTNode elseBranch = null;

    if (match(TokenType.Else)) {
      elseBranch = parseStatement();
    }

    auto node = new ASTNode(ASTNodeType.IfStatement);
    node.addChild(condition);
    node.addChild(thenBranch);
    if (elseBranch !is null) {
      node.addChild(elseBranch);
    }

    return node;
  }

  protected ASTNode parseWhileStatement() {
    consume(TokenType.LeftParen, "Expected '(' after 'while'");
    auto condition = parseExpression();
    consume(TokenType.RightParen, "Expected ')' after condition");
    auto body = parseStatement();

    auto node = new ASTNode(ASTNodeType.WhileStatement);
    node.addChild(condition);
    node.addChild(body);
    return node;
  }

  protected ASTNode parseForStatement() {
    consume(TokenType.LeftParen, "Expected '(' after 'for'");
    
    // Simplified for loop (for now)
    auto node = new ASTNode(ASTNodeType.ForStatement);
    
    // Initialization
    if (!match(TokenType.Semicolon)) {
      node.addChild(parseExpression());
      consume(TokenType.Semicolon, "Expected ';' after initializer");
    }

    // Condition
    if (!check(TokenType.Semicolon)) {
      node.addChild(parseExpression());
    }
    consume(TokenType.Semicolon, "Expected ';' after condition");

    // Increment
    if (!check(TokenType.RightParen)) {
      node.addChild(parseExpression());
    }
    consume(TokenType.RightParen, "Expected ')' after for clauses");

    // Body
    node.addChild(parseStatement());

    return node;
  }

  protected ASTNode parseReturnStatement() {
    auto node = new ASTNode(ASTNodeType.ReturnStatement, previous());

    if (!check(TokenType.Semicolon)) {
      node.addChild(parseExpression());
    }

    consume(TokenType.Semicolon, "Expected ';' after return value");
    return node;
  }

  protected ASTNode parseBreakStatement() {
    auto node = new ASTNode(ASTNodeType.BreakStatement, previous());
    consume(TokenType.Semicolon, "Expected ';' after 'break'");
    return node;
  }

  protected ASTNode parseContinueStatement() {
    auto node = new ASTNode(ASTNodeType.ContinueStatement, previous());
    consume(TokenType.Semicolon, "Expected ';' after 'continue'");
    return node;
  }

  protected ASTNode parseExpressionStatement() {
    auto expr = parseExpression();
    consume(TokenType.Semicolon, "Expected ';' after expression");

    auto node = new ASTNode(ASTNodeType.ExpressionStatement);
    node.addChild(expr);
    return node;
  }

  protected ASTNode parseFunctionDeclaration() {
    auto nameToken = consume(TokenType.Identifier, "Expected function name");
    auto node = new ASTNode(ASTNodeType.FunctionDeclaration, nameToken);

    consume(TokenType.LeftParen, "Expected '(' after function name");
    // Parse parameters (simplified)
    if (!check(TokenType.RightParen)) {
      do {
        auto param = consume(TokenType.Identifier, "Expected parameter name");
        node.addChild(new ASTNode(ASTNodeType.ParameterDeclaration, param));
      } while (match(TokenType.Comma));
    }
    consume(TokenType.RightParen, "Expected ')' after parameters");

    consume(TokenType.LeftBrace, "Expected '{' before function body");
    node.addChild(parseBlockStatement());

    return node;
  }

  protected ASTNode parseClassDeclaration() {
    auto nameToken = consume(TokenType.Identifier, "Expected class name");
    auto node = new ASTNode(ASTNodeType.ClassDeclaration, nameToken);

    consume(TokenType.LeftBrace, "Expected '{' before class body");

    while (!check(TokenType.RightBrace) && !isAtEnd()) {
      node.addChild(parseDeclaration());
    }

    consume(TokenType.RightBrace, "Expected '}' after class body");
    return node;
  }

  protected ASTNode parseVariableDeclaration() {
    auto nameToken = consume(TokenType.Identifier, "Expected variable name");
    auto node = new ASTNode(ASTNodeType.VariableDeclaration, nameToken);

    if (match(TokenType.Assign)) {
      node.addChild(parseExpression());
    }

    consume(TokenType.Semicolon, "Expected ';' after variable declaration");
    return node;
  }

  // Token manipulation helpers
  protected bool match(TokenType[] types...) {
    foreach (type; types) {
      if (check(type)) {
        advance();
        return true;
      }
    }
    return false;
  }

  protected bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  protected Token advance() {
    if (!isAtEnd()) _current++;
    return previous();
  }

  protected bool isAtEnd() {
    return peek().type == TokenType.EOF;
  }

  protected Token peek() {
    return _tokens[_current];
  }

  protected Token previous() {
    return _tokens[_current - 1];
  }

  protected Token consume(TokenType type, string message) {
    if (check(type)) return advance();
    error(message);
    return peek();
  }

  protected void error(string message) {
    Diagnostic diag;
    diag.severity = DiagnosticSeverity.Error;
    diag.message = message;
    auto token = peek();
    diag.line = token.line;
    diag.column = token.column;
    _errors ~= diag;

    throw new Exception(message);
  }

  protected void synchronize() {
    advance();

    while (!isAtEnd()) {
      if (previous().type == TokenType.Semicolon) return;

      switch (peek().type) {
        case TokenType.Class:
        case TokenType.Function:
        case TokenType.Var:
        case TokenType.For:
        case TokenType.If:
        case TokenType.While:
        case TokenType.Return:
          return;
        default:
          break;
      }

      advance();
    }
  }
}
