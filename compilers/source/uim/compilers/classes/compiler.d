/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.classes.compiler;

import uim.compilers;
import uim.oop;
import std.datetime.stopwatch : StopWatch;
import core.time : Duration;

@safe:

/**
 * Base implementation of a generic compiler.
 */
class Compiler : UIMObject, ICompiler {
  mixin(ObjThis!("Compiler"));

  protected ILexer _lexer;
  protected ICompilerParser _parser;
  protected ISemanticAnalyzer _analyzer;
  protected IOptimizer _optimizer;
  protected ICodeGenerator _codeGenerator;
  protected Diagnostic[] _diagnostics;
  protected string _version = "1.0.0";

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // Initialize default components
    _lexer = new Lexer();
    _parser = new Parser();
    _analyzer = new SemanticAnalyzer();
    _optimizer = new Optimizer();
    _codeGenerator = new CodeGenerator();

    return true;
  }

  // #region Components
  ILexer lexer() {
    return _lexer;
  }

  Compiler lexer(ILexer newLexer) {
    _lexer = newLexer;
    return this;
  }

  ICompilerParser parser() {
    return _parser;
  }

  Compiler parser(ICompilerParser newParser) {
    _parser = newParser;
    return this;
  }

  ISemanticAnalyzer analyzer() {
    return _analyzer;
  }

  Compiler analyzer(ISemanticAnalyzer newAnalyzer) {
    _analyzer = newAnalyzer;
    return this;
  }

  IOptimizer optimizer() {
    return _optimizer;
  }

  Compiler optimizer(IOptimizer newOptimizer) {
    _optimizer = newOptimizer;
    return this;
  }

  ICodeGenerator codeGenerator() {
    return _codeGenerator;
  }

  Compiler codeGenerator(ICodeGenerator newCodeGen) {
    _codeGenerator = newCodeGen;
    return this;
  }
  // #endregion Components

  // #region Diagnostics
  Diagnostic[] diagnostics() {
    return _diagnostics;
  }

  void clearDiagnostics() {
    _diagnostics = [];
  }

  bool hasErrors() {
    foreach (diag; _diagnostics) {
      if (diag.severity == DiagnosticSeverity.Error || 
          diag.severity == DiagnosticSeverity.Fatal) {
        return true;
      }
    }
    return false;
  }

  protected void addDiagnostic(Diagnostic diag) {
    _diagnostics ~= diag;
  }

  protected void addDiagnostics(Diagnostic[] diags) {
    _diagnostics ~= diags;
  }
  // #endregion Diagnostics

  // #region Version
  string version_() {
    return _version;
  }

  Compiler version_(string newVersion) {
    _version = newVersion;
    return this;
  }
  // #endregion Version

  /**
   * Main compilation method.
   */
  CompilationResult compile(string source, CompilerOptions options = CompilerOptions.init) @trusted {
    clearDiagnostics();
    StopWatch sw;
    sw.start();

    CompilationResult result;

    try {
      // Phase 1: Lexical Analysis
      auto tokens = _lexer.tokenize(source);
      addDiagnostics(_lexer.errors());
      if (hasErrors()) {
        result.success = false;
        result.diagnostics = _diagnostics;
        sw.stop();
        result.compilationTime = sw.peek().total!"msecs";
        return result;
      }

      // Phase 2: Syntax Analysis
      auto ast = _parser.parse(tokens);
      addDiagnostics(_parser.errors());
      if (hasErrors()) {
        result.success = false;
        result.diagnostics = _diagnostics;
        sw.stop();
        result.compilationTime = sw.peek().total!"msecs";
        return result;
      }

      // Phase 3: Semantic Analysis
      ast = _analyzer.analyze(ast);
      addDiagnostics(_analyzer.errors());
      addDiagnostics(_analyzer.warnings());
      if (hasErrors()) {
        result.success = false;
        result.diagnostics = _diagnostics;
        sw.stop();
        result.compilationTime = sw.peek().total!"msecs";
        return result;
      }

      // Phase 4: Optimization (if requested)
      if (options.optimizationLevel > 0) {
        ast = _optimizer.optimize(ast, options.optimizationLevel);
      }

      // Phase 5: Code Generation
      auto codeGenOpts = CodeGenOptions.init;
      codeGenOpts.debugSymbols = options.debugInfo;
      codeGenOpts.format = options.outputFormat;
      if (options.optimizationLevel > 0) {
        codeGenOpts.optimizationStats = _optimizer.statistics();
      }

      auto codeGenResult = _codeGenerator.generate(ast, codeGenOpts);
      if (!codeGenResult.success) {
        addDiagnostics(codeGenResult.errors);
        result.success = false;
        result.diagnostics = _diagnostics;
        sw.stop();
        result.compilationTime = sw.peek().total!"msecs";
        return result;
      }

      // Success!
      result.success = true;
      result.output = codeGenResult.code;
      result.outputText = codeGenResult.codeText;
      result.diagnostics = _diagnostics;
      sw.stop();
      result.compilationTime = sw.peek().total!"msecs";

    } catch (Exception e) {
      // Fatal error
      Diagnostic fatalDiag;
      fatalDiag.severity = DiagnosticSeverity.Fatal;
      fatalDiag.message = e.msg;
      addDiagnostic(fatalDiag);

      result.success = false;
      result.diagnostics = _diagnostics;
      sw.stop();
      result.compilationTime = sw.peek().total!"msecs";
    }

    return result;
  }
}

/**
 * Create a new compiler instance.
 */
Compiler createCompiler() {
  return new Compiler();
}
