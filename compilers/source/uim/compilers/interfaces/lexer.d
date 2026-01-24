/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.interfaces.lexer;

import uim.compilers;

@safe:

/**
 * Interface for lexical analysis (tokenization).
 * 
 * The lexer breaks source code into tokens.
 */
interface ILexer {
  /**
   * Tokenize source code.
   * 
   * Params:
   *   source = Source code to tokenize
   * 
   * Returns:
   *   Array of tokens
   */
  Token[] tokenize(string source);

  /**
   * Get the current token.
   */
  Token currentToken();

  /**
   * Advance to the next token.
   */
  Token nextToken();

  /**
   * Peek at the next token without advancing.
   */
  Token peekToken(size_t offset = 1);

  /**
   * Check if there are more tokens.
   */
  bool hasMoreTokens();

  /**
   * Get lexer errors.
   */
  Diagnostic[] errors();
}

/**
 * A token from lexical analysis.
 */
struct Token {
  /// Token type
  TokenType type;

  /// Token value/lexeme
  string value;

  /// Source file
  string file;

  /// Line number (1-based)
  size_t line;

  /// Column number (1-based)
  size_t column;

  /// Token length
  size_t length;
}

/**
 * Token types for a generic language.
 */
enum TokenType {
  // End of file
  EOF,

  // Identifiers and literals
  Identifier,
  IntegerLiteral,
  FloatLiteral,
  StringLiteral,
  CharLiteral,
  BoolLiteral,

  // Keywords
  Keyword,
  If,
  Else,
  While,
  For,
  Break,
  Continue,
  Return,
  Function,
  Class,
  Struct,
  Interface,
  Enum,
  Import,
  Module,
  Public,
  Private,
  Protected,
  Static,
  Const,
  Var,
  Let,
  True,
  False,
  Null,

  // Operators
  Plus,           // +
  Minus,          // -
  Star,           // *
  Slash,          // /
  Percent,        // %
  Assign,         // =
  Equal,          // ==
  NotEqual,       // !=
  Less,           // <
  LessEqual,      // <=
  Greater,        // >
  GreaterEqual,   // >=
  LogicalAnd,     // &&
  LogicalOr,      // ||
  LogicalNot,     // !
  BitwiseAnd,     // &
  BitwiseOr,      // |
  BitwiseXor,     // ^
  BitwiseNot,     // ~
  LeftShift,      // <<
  RightShift,     // >>
  Increment,      // ++
  Decrement,      // --

  // Delimiters
  LeftParen,      // (
  RightParen,     // )
  LeftBrace,      // {
  RightBrace,     // }
  LeftBracket,    // [
  RightBracket,   // ]
  Semicolon,      // ;
  Comma,          // ,
  Dot,            // .
  Colon,          // :
  Arrow,          // ->
  FatArrow,       // =>

  // Special
  Comment,
  Whitespace,
  Unknown,
  Error
}
