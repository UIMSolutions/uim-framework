module uim.compilers.interfaces.symboltable;

import uim.compilers;

@safe:

/**
 * Symbol table interface for tracking identifiers and their types.
 */
interface ISymbolTable {
  /**
   * Enter a new scope.
   */
  ISymbolTable enterScope();

  /**
   * Exit the current scope.
   */
  ISymbolTable exitScope();

  /**
   * Define a symbol in the current scope.
   */
  ISymbolTable define(string name, Symbol symbol);

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