/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.analyzers.analyzer;

import uim.compilers;

@safe:

/**
 * Base implementation of a semantic analyzer.
 */
class SemanticAnalyzer : UIMObject, ISemanticAnalyzer {
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

    _symbolTable = new SymbolTable();
    return true;
  }

  /**
  * Analyzes the given AST and returns the analyzed AST.
  * During analysis, it collects semantic errors and warnings.
  * The symbol table is updated with information about variables, functions, and other symbols.
  *
  * Params:
  *   ast = The abstract syntax tree to analyze.
  * Returns: 
  *   The analyzed abstract syntax tree.
  */
  ASTNode analyze(ASTNode ast) {
    _errors = [];
    _warnings = [];

    // Perform semantic analysis
    analyzeNode(ast);
    return ast;
  }

  // #region symbolTable
  protected ISymbolTable _symbolTable;
  ISymbolTable symbolTable() {
    return _symbolTable;
  }
  // #endregion symbolTable

  // #region errors
  protected Diagnostic[] _errors;
  Diagnostic[] errors() {
    return _errors;
  }
  // #endregion errors

  // #region warnings
  protected Diagnostic[] _warnings;
  Diagnostic[] warnings() {
    return _warnings;
  }
  // #endregion warnings

  // Core analysis method
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
        node.children.each!(child => analyzeNode(child));
        break;
    }
  }

  // Specific analysis methods
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
    node.children.each!(child => analyzeNode(child));

    _symbolTable.exitScope();
  }

  // Analyze variable declaration
  protected void analyzeVariableDeclaration(ASTNode node) {
    Symbol sym;
    sym.name = node.token.value;
    sym.kind = SymbolKind.Variable;
    sym.location = node.token;

    _symbolTable.define(sym.name, sym);

    // Analyze initializer
    node.children.each!(child => analyzeNode(child));
  }

  protected void analyzeBinaryExpression(ASTNode node) {
    // Analyze operands
    node.children.each!(child => analyzeNode(child));

    // Type checking would go here
  }
}
///
unittest {
  mixin(ShowTest!"Testing SemanticAnalyzer");
  
  auto analyzer = new SemanticAnalyzer();
  assert(analyzer !is null);
}
