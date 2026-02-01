/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.interfaces.parser;

import uim.compilers;

@safe:

/**
 * Interface for syntax analysis (parsing).
 * 
 * The parser builds an Abstract Syntax Tree (AST) from tokens.
 */
interface ICompilerParser {
  /**
   * Parse tokens into an AST.
   * 
   * Params:
   *   tokens = Array of tokens from lexer
   * 
   * Returns:
   *   Root node of the AST
   */
  ASTNode parse(Token[] tokens);

  /**
   * Parse a single expression.
   */
  ASTNode parseExpression();

  /**
   * Parse a single statement.
   */
  ASTNode parseStatement();

  /**
   * Parse a declaration (function, class, variable, etc.).
   */
  ASTNode parseDeclaration();

  /**
   * Get parser errors.
   */
  Diagnostic[] errors();
}

/**
 * Abstract Syntax Tree node.
 */
class ASTNode {
  /// Node type
  ASTNodeType type;

  /// Source location
  Token token;

  /// Child nodes
  ASTNode[] children;

  /// Node attributes
  string[string] attributes;

  this(ASTNodeType type, Token token = Token.init) {
    this.type = type;
    this.token = token;
  }

  /// Add a child node
  void addChild(ASTNode child) {
    children ~= child;
  }

  /// Set an attribute
  void setAttribute(string key, string value) {
    attributes[key] = value;
  }

  /// Get an attribute
  string getAttribute(string key, string defaultValue = "") {
    return attributes.get(key, defaultValue);
  }
}

/**
 * AST node types.
 */
enum ASTNodeType {
  // Program structure
  Program,
  Module,
  ImportDeclaration,

  // Declarations
  FunctionDeclaration,
  ClassDeclaration,
  StructDeclaration,
  InterfaceDeclaration,
  EnumDeclaration,
  VariableDeclaration,
  ParameterDeclaration,

  // Statements
  BlockStatement,
  ExpressionStatement,
  IfStatement,
  WhileStatement,
  ForStatement,
  ReturnStatement,
  BreakStatement,
  ContinueStatement,

  // Expressions
  BinaryExpression,
  UnaryExpression,
  AssignmentExpression,
  CallExpression,
  MemberExpression,
  IndexExpression,
  LiteralExpression,
  IdentifierExpression,
  ArrayExpression,
  ObjectExpression,

  // Literals
  IntegerLiteral,
  FloatLiteral,
  StringLiteral,
  BoolLiteral,
  NullLiteral,

  // Types
  TypeAnnotation,
  ArrayType,
  FunctionType,

  // Other
  Identifier,
  Unknown
}
