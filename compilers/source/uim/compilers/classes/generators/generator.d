/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.generators.generator;

import uim.compilers;

@safe:

/**
 * Base implementation of a code generator.
 */
class CodeGenerator : UIMObject, ICodeGenerator {
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

    _supportedTargets = ["generic", "asm", "llvm-ir", "c"];

    return true;
  }

  protected string _target = "generic";
  protected string[] _supportedTargets;

  CodeGenResult generate(ASTNode ast, CodeGenOptions options = CodeGenOptions.init) {
    CodeGenResult result;

    try {
      // Generate code based on format
      final switch (options.format) {
        case "asm":
          result.codeText = generateAssembly(ast, options);
          break;
        case "llvm-ir":
          result.codeText = generateLLVMIR(ast, options);
          break;
        case "c":
          result.codeText = generateC(ast, options);
          break;
        case "executable":
        case "library":
        case "object":
          result.codeText = generateGeneric(ast, options);
          break;
      }

      result.success = true;
      result.code = cast(ubyte[])result.codeText.dup;

    } catch (Exception e) {
      Diagnostic diag;
      diag.severity = DiagnosticSeverity.Error;
      diag.message = "Code generation failed: " ~ e.msg;
      result.errors ~= diag;
      result.success = false;
    }

    return result;
  }

  string target() {
    return _target;
  }

  void target(string newTarget) {
    _target = newTarget;
  }

  string[] supportedTargets() {
    return _supportedTargets;
  }

  protected string generateGeneric(ASTNode ast, CodeGenOptions options) {
    string code = "; Generated code\n\n";

    code ~= generateNode(ast, 0, options);

    return code;
  }

  protected string generateAssembly(ASTNode ast, CodeGenOptions options) {
    string code = "; Assembly code\n";
    code ~= ".section .text\n";
    code ~= ".global _start\n\n";
    code ~= "_start:\n";

    code ~= generateNode(ast, 1, options);

    code ~= "  ; Exit\n";
    code ~= "  mov rax, 60\n";
    code ~= "  xor rdi, rdi\n";
    code ~= "  syscall\n";

    return code;
  }

  protected string generateLLVMIR(ASTNode ast, CodeGenOptions options) {
    string code = "; ModuleID = 'main'\n\n";
    code ~= generateNode(ast, 0, options);
    return code;
  }

  protected string generateC(ASTNode ast, CodeGenOptions options) {
    string code = "#include <stdio.h>\n\n";

    code ~= generateNode(ast, 0, options);

    return code;
  }

  protected string generateNode(ASTNode node, int indent, CodeGenOptions options) {
    if (node is null) return "";

    string indentStr = "";
    for (int i = 0; i < indent; i++) {
      indentStr ~= "  ";
    }

    string code = "";

    switch (node.type) {
      case ASTNodeType.Program:
        if (options.comments) code ~= indentStr ~ "// Program\n";
        foreach (child; node.children) {
          code ~= generateNode(child, indent, options);
        }
        break;

      case ASTNodeType.FunctionDeclaration:
        if (options.comments) code ~= indentStr ~ "// Function: " ~ node.token.value ~ "\n";
        code ~= indentStr ~ "function " ~ node.token.value ~ "() {\n";
        foreach (child; node.children) {
          code ~= generateNode(child, indent + 1, options);
        }
        code ~= indentStr ~ "}\n\n";
        break;

      case ASTNodeType.VariableDeclaration:
        code ~= indentStr ~ "var " ~ node.token.value;
        if (node.children.length > 0) {
          code ~= " = ";
          code ~= generateNode(node.children[0], 0, options);
        }
        code ~= ";\n";
        break;

      case ASTNodeType.ReturnStatement:
        code ~= indentStr ~ "return";
        if (node.children.length > 0) {
          code ~= " " ~ generateNode(node.children[0], 0, options);
        }
        code ~= ";\n";
        break;

      case ASTNodeType.BinaryExpression:
        if (node.children.length == 2) {
          code ~= "(" ~ generateNode(node.children[0], 0, options) ~ 
                 " " ~ node.token.value ~ " " ~ 
                 generateNode(node.children[1], 0, options) ~ ")";
        }
        break;

      case ASTNodeType.IntegerLiteral:
      case ASTNodeType.FloatLiteral:
      case ASTNodeType.StringLiteral:
      case ASTNodeType.IdentifierExpression:
        code ~= node.token.value;
        break;

      default:
        foreach (child; node.children) {
          code ~= generateNode(child, indent, options);
        }
        break;
    }

    return code;
  }
}
