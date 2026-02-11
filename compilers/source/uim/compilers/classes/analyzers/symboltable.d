module uim.compilers.classes.analyzers.symboltable;

import uim.compilers;

@safe:
/**
 * Symbol table implementation.
 */
class SymbolTable : ISymbolTable {
  protected Symbol[string][] _scopes;
  protected size_t _currentScope;

  this() {
    _scopes = [null];
    _currentScope = 0;
    _scopes[0] = (Symbol[string]).init;
  }

  /**
    * Enters a new scope level. Symbols defined after this call will be in the new scope.
    */
  ISymbolTable enterScope() {
    _scopes ~= (Symbol[string]).init;
    _currentScope++;
    return this;
  }

  /**
    * Exits the current scope and returns to the previous one.
    * Symbols defined in the exited scope will no longer be accessible.
    */
  ISymbolTable exitScope() {
    if (_currentScope > 0) {
      _scopes = _scopes[0 .. $ - 1];
      _currentScope--;
    }
    return this;
  }

  /**
    * Defines a symbol in the current scope.
    * 
    * Params:
    *   name The name of the symbol     
    *   symbol The symbol information to store.
    */
  ISymbolTable define(string name, Symbol symbol) {
    _scopes[_currentScope][name] = symbol;
    return this;
  }
  ///
  unittest {
    auto table = new SymbolTable();
    table.define("x", Symbol("int"));
    // TODO: assert(table.resolve("x").type == "int");
    // TODO: table.enterScope();
    // TODO: assert(table.resolve("x").type == "int");
    // TODO: table.define("y", Symbol("float"));
    // TODO: assert(table.resolve("y").type == "float");
    // TODO: table.exitScope();
    // TODO: assert(table.resolve("y").type == null);
  }

  /** 
   * Resolves a symbol by name, searching from the current scope up to the global scope.
   *
   * Params:
   *   name = The name of the symbol to resolve.
   *
   * Returns:
   *   The resolved symbol if found, or a null symbol if not found. 
   */
  Symbol resolve(string name) {
    // Search from current scope to global scope
    for (long i = _currentScope; i >= 0; i--) {
      if (name in _scopes[i]) {
        return _scopes[i][name];
      }
    }

    Symbol notFound;
    return notFound;
  }

  /**
    * Checks if a symbol with the given name exists in the current scope.
    * Returns true if it exists, false otherwise.
    */
  bool exists(string name) {
    return (name in _scopes[_currentScope]) !is null;
  }

  Symbol[string] symbols() {
    return _scopes[_currentScope];
  }
}
///
unittest {
  auto table = new SymbolTable();
  table.define("x", Symbol("int"));
  // TODO: assert(table.resolve("x").type == "int");
  // TODO: table.enterScope();
  // TODO: assert(table.resolve("x").type == "int");
  // TODO: table.define("y", Symbol("float"));
  // TODO: assert(table.resolve("y").type == "float");
  // TODO: table.exitScope();
  // TODO: assert(table.resolve("y").type == null);
}
