/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.interfaces.analyzer;

import uim.compilers;

@safe:

/**
 * Interface for semantic analysis.
 * 
 * The analyzer performs type checking, symbol resolution, and other semantic validation.
 */
interface ISemanticAnalyzer {
  /**
   * Analyze an AST for semantic correctness.
   * 
   * Params:
   *   ast = Root node of the AST
   * 
   * Returns:
   *   Analyzed and annotated AST
   */
  ASTNode analyze(ASTNode ast);

  /**
   * Get the symbol table.
   */
  ISymbolTable symbolTable();

  /**
   * Get analyzer errors.
   */
  Diagnostic[] errors();

  /**
   * Get analyzer warnings.
   */
  Diagnostic[] warnings();
}

/**
 * Symbol table interface for tracking identifiers and their types.
 */
interface ISymbolTable {
  /**
   * Enter a new scope.
   */
  void enterScope();

  /**
   * Exit the current scope.
   */
  void exitScope();

  /**
   * Define a symbol in the current scope.
   */
  void define(string name, Symbol symbol);

  /**
   * Resolve a symbol (search current and parent scopes).
   */
  Symbol resolve(string name);

  /**
   * Check if a symbol exists in the current scope.
   */
  bool exists(string name);

  /**
   * Get all symbols in the current scope.
   */
  Symbol[string] symbols();
}

/**
 * Symbol representing an identifier in the program.
 */
struct Symbol {
  /// Symbol name
  string name;

  /// Symbol kind
  SymbolKind kind;

  /// Symbol type
  TypeInfo type;

  /// Is the symbol constant?
  bool isConst;

  /// Is the symbol public?
  bool isPublic;

  /// Defining location
  Token location;

  /// Additional attributes
  string[string] attributes;
}

/**
 * Symbol kinds.
 */
enum SymbolKind {
  Variable,
  Parameter,
  Function,
  Class,
  Struct,
  Interface,
  Enum,
  Module,
  Type
}

/**
 * Type information for semantic analysis.
 */
struct TypeInfo {
  /// Type name
  string name;

  /// Type kind
  TypeKind kind;

  /// For array types: element type
  TypeInfo* elementType;

  /// For function types: parameter types
  TypeInfo[] parameterTypes;

  /// For function types: return type
  TypeInfo* returnType;

  /// Size in bytes (0 if unknown)
  size_t size;

  /// Is nullable?
  bool nullable;
}

/**
 * Type kinds.
 */
enum TypeKind {
  Void,
  Bool,
  Int,
  Float,
  String,
  Array,
  Function,
  Class,
  Struct,
  Interface,
  Enum,
  Unknown
}
