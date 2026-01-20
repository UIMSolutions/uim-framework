/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.classes.analyzer;

import uim.compilers;

@safe:

/**
 * Base implementation of a semantic analyzer.
 */
class SemanticAnalyzer : UIMObject, ISemanticAnalyzer {
  mixin(ObjThis!("SemanticAnalyzer"));

  protected ISymbolTable _symbolTable;
  protected Diagnostic[] _errors;
  protected Diagnostic[] _warnings;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _symbolTable = new SymbolTable();

    return true;
  }

  ASTNode analyze(ASTNode ast) {
    _errors = [];
    _warnings = [];

    // Perform semantic analysis
    analyzeNode(ast);

    return ast;
  }

  ISymbolTable symbolTable() {
    return _symbolTable;
  }

  Diagnostic[] errors() {
    return _errors;
  }

  Diagnostic[] warnings() {
    return _warnings;
  }

  protected void analyzeNode(ASTNode node) {
    if (node is null) return;

    // Analyze based on node type
    switch (node.type) {
      case ASTNodeType.FunctionDeclaration:
        analyzeFunctionDeclaration(node);
        break;
      case ASTNodeType.VariableDeclaration:
        analyzeVariableDeclaration(node);
        break;
      case ASTNodeType.BinaryExpression:
        analyzeBinaryExpression(node);
        break;
      default:
        // Recursively analyze children
        foreach (child; node.children) {
          analyzeNode(child);
        }
        break;
    }
  }

  protected void analyzeFunctionDeclaration(ASTNode node) {
    // Define function symbol
    Symbol sym;
    sym.name = node.token.value;
    sym.kind = SymbolKind.Function;
    sym.location = node.token;

    _symbolTable.define(sym.name, sym);

    // Enter function scope
    _symbolTable.enterScope();

    // Analyze function body
    foreach (child; node.children) {
      analyzeNode(child);
    }

    _symbolTable.exitScope();
  }

  protected void analyzeVariableDeclaration(ASTNode node) {
    Symbol sym;
    sym.name = node.token.value;
    sym.kind = SymbolKind.Variable;
    sym.location = node.token;

    _symbolTable.define(sym.name, sym);

    // Analyze initializer
    foreach (child; node.children) {
      analyzeNode(child);
    }
  }

  protected void analyzeBinaryExpression(ASTNode node) {
    // Analyze operands
    foreach (child; node.children) {
      analyzeNode(child);
    }

    // Type checking would go here
  }
}

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
