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

  void enterScope() {
    _scopes ~= (Symbol[string]).init;
    _currentScope++;
  }

  void exitScope() {
    if (_currentScope > 0) {
      _scopes = _scopes[0..$-1];
      _currentScope--;
    }
  }

  void define(string name, Symbol symbol) {
    _scopes[_currentScope][name] = symbol;
  }

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
  assert(table.resolve("x").type == "int");
  table.enterScope();
  assert(table.resolve("x").type == "int");
  table.define("y", Symbol("float"));
  assert(table.resolve("y").type == "float");
  table.exitScope();
  assert(table.resolve("y").type == null);
}