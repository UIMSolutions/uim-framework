/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module compilers.examples.basic_compiler;

import uim.compilers;
import std.stdio;

void main() {
  writeln("=== Generic Compiler Example ===\n");

  // Create a compiler instance
  auto compiler = createCompiler();
  compiler.version_("1.0.0");

  // Simple source code to compile
  string source = `
    function add(x, y) {
      return x + y;
    }

    function main() {
      var result = add(10, 20);
      return result;
    }
  `;

  writeln("Source code:");
  writeln(source);
  writeln("\n--- Compiling ---\n");

  // Configure compilation options
  CompilerOptions options;
  options.optimizationLevel = 1;
  options.debugInfo = true;
  options.warnings = true;
  options.outputFormat = "asm";

  // Compile the source
  auto result = compiler.compile(source, options);

  // Display results
  if (result.success) {
    writeln("✓ Compilation successful!");
    writeln("\nCompilation time: ", result.compilationTime, " ms");
    
    if (result.diagnostics.length > 0) {
      writeln("\nDiagnostics:");
      foreach (diag; result.diagnostics) {
        writeln("  [", diag.severity, "] ", diag.message);
      }
    }

    writeln("\n--- Generated Code ---\n");
    writeln(result.outputText);

  } else {
    writeln("✗ Compilation failed!");
    writeln("\nErrors:");
    foreach (diag; result.diagnostics) {
      if (diag.severity == DiagnosticSeverity.Error || 
          diag.severity == DiagnosticSeverity.Fatal) {
        writeln("  Line ", diag.line, ":", diag.column, " - ", diag.message);
      }
    }
  }

  writeln("\n--- Compiler Components ---\n");
  writeln("Lexer: ", typeid(compiler.lexer()));
  writeln("Parser: ", typeid(compiler.parser()));
  writeln("Analyzer: ", typeid(compiler.analyzer()));
  writeln("Optimizer: ", typeid(compiler.optimizer()));
  writeln("Code Generator: ", typeid(compiler.codeGenerator()));

  // Test optimizer passes
  writeln("\n--- Available Optimization Passes ---\n");
  auto passes = compiler.optimizer().availablePasses();
  foreach (pass; passes) {
    writeln("  ", pass.name, " (level ", pass.level, "): ", pass.description);
  }

  // Test code generator targets
  writeln("\n--- Supported Targets ---\n");
  auto targets = compiler.codeGenerator().supportedTargets();
  foreach (target; targets) {
    writeln("  - ", target);
  }

  writeln("\n=== Example Complete ===");
}
