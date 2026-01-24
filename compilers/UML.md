/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

# UIM-Compiler UML Description

## Overview
The UIM-Compiler framework provides a modular compiler architecture with clear separation of concerns across the compilation pipeline. It implements the classic compiler design with lexical analysis, syntax analysis, semantic analysis, optimization, and code generation phases.

## Architecture Layers

### 1. Interface Layer (uim.compilers.interfaces)
Defines contracts for all compiler components:

```plantuml
@startuml Compiler_Interfaces

interface ICompiler {
  + compile(source: string, options: CompilerOptions): CompilationResult
  + lexer(): ILexer
  + parser(): ICompilerParser
  + analyzer(): ISemanticAnalyzer
  + optimizer(): IOptimizer
  + codeGenerator(): ICodeGenerator
  + version(): string
  + diagnostics(): Diagnostic[]
}

interface ILexer {
  + tokenize(source: string): Token[]
  + currentToken(): Token
  + nextToken(): Token
  + peekToken(offset: size_t): Token
  + hasMoreTokens(): bool
  + errors(): Diagnostic[]
}

interface ICompilerParser {
  + parse(tokens: Token[]): ASTNode
  + parseExpression(): ASTNode
  + parseStatement(): ASTNode
  + parseDeclaration(): ASTNode
  + errors(): Diagnostic[]
}

interface ISemanticAnalyzer {
  + analyze(ast: ASTNode): ASTNode
  + symbolTable(): ISymbolTable
  + errors(): Diagnostic[]
  + warnings(): Diagnostic[]
}

interface IOptimizer {
  + optimize(ast: ASTNode, level: int): ASTNode
  + applyPass(ast: ASTNode, pass: OptimizationPass): ASTNode
  + availablePasses(): OptimizationPass[]
  + statistics(): OptimizationStats
}

interface ICodeGenerator {
  + generate(ast: ASTNode, options: CodeGenOptions): CodeGenResult
  + target(): string
  + target(newTarget: string): void
  + supportedTargets(): string[]
}

interface ISymbolTable {
  + enterScope(): void
  + exitScope(): void
  + define(name: string, symbol: Symbol): bool
  + lookup(name: string): Symbol
  + resolve(name: string): Symbol
  + currentScope(): Scope
}

ICompiler --> ILexer : uses
ICompiler --> ICompilerParser : uses
ICompiler --> ISemanticAnalyzer : uses
ICompiler --> IOptimizer : uses
ICompiler --> ICodeGenerator : uses
ISemanticAnalyzer --> ISymbolTable : uses

@enduml
```

### 2. Implementation Layer (uim.compilers.classes)

```plantuml
@startuml Compiler_Classes

class Compiler {
  - _lexer: ILexer
  - _parser: ICompilerParser
  - _analyzer: ISemanticAnalyzer
  - _optimizer: IOptimizer
  - _codeGenerator: ICodeGenerator
  - _diagnostics: Diagnostic[]
  - _version: string
  
  + initialize(initData: Json[string]): bool
  + compile(source: string, options: CompilerOptions): CompilationResult
  + lexer(): ILexer
  + parser(): ICompilerParser
  + analyzer(): ISemanticAnalyzer
  + optimizer(): IOptimizer
  + codeGenerator(): ICodeGenerator
  + clearDiagnostics(): void
  + hasErrors(): bool
  + hasWarnings(): bool
}

class Lexer {
  - _source: string
  - _position: size_t
  - _line: size_t
  - _column: size_t
  - _tokens: Token[]
  - _currentIndex: size_t
  - _errors: Diagnostic[]
  
  + tokenize(source: string): Token[]
  + currentToken(): Token
  + nextToken(): Token
  + peekToken(offset: size_t): Token
  + hasMoreTokens(): bool
  # scanToken(): Token
  # advance(): char
  # peek(): char
  # isAtEnd(): bool
  # skipWhitespace(): void
  # scanIdentifier(): Token
  # scanNumber(): Token
  # scanString(): Token
}

class Parser {
  - _tokens: Token[]
  - _currentIndex: size_t
  - _errors: Diagnostic[]
  - _ast: ASTNode
  
  + parse(tokens: Token[]): ASTNode
  + parseExpression(): ASTNode
  + parseStatement(): ASTNode
  + parseDeclaration(): ASTNode
  # match(types: TokenType[]): bool
  # consume(type: TokenType, message: string): Token
  # synchronize(): void
  # error(token: Token, message: string): void
}

class SemanticAnalyzer {
  - _symbolTable: ISymbolTable
  - _errors: Diagnostic[]
  - _warnings: Diagnostic[]
  - _currentScope: Scope
  
  + analyze(ast: ASTNode): ASTNode
  + symbolTable(): ISymbolTable
  # visit(node: ASTNode): ASTNode
  # checkTypes(left: Type, right: Type): bool
  # resolveSymbol(name: string): Symbol
  # defineSymbol(name: string, symbol: Symbol): bool
}

class Optimizer {
  - _passes: OptimizationPass[]
  - _stats: OptimizationStats
  - _level: int
  
  + optimize(ast: ASTNode, level: int): ASTNode
  + applyPass(ast: ASTNode, pass: OptimizationPass): ASTNode
  + availablePasses(): OptimizationPass[]
  # constantFolding(node: ASTNode): ASTNode
  # deadCodeElimination(node: ASTNode): ASTNode
  # commonSubexpressionElimination(node: ASTNode): ASTNode
}

class CodeGenerator {
  - _target: string
  - _output: string
  - _emitter: IEmitter
  
  + generate(ast: ASTNode, options: CodeGenOptions): CodeGenResult
  + target(): string
  + supportedTargets(): string[]
  # emit(instruction: string): void
  # visit(node: ASTNode): void
  # generateExpression(node: ASTNode): void
  # generateStatement(node: ASTNode): void
}

Compiler ..|> ICompiler
Lexer ..|> ILexer
Parser ..|> ICompilerParser
SemanticAnalyzer ..|> ISemanticAnalyzer
Optimizer ..|> IOptimizer
CodeGenerator ..|> ICodeGenerator

Compiler o-- Lexer
Compiler o-- Parser
Compiler o-- SemanticAnalyzer
Compiler o-- Optimizer
Compiler o-- CodeGenerator

@enduml
```

### 3. Data Structures

```plantuml
@startuml Compiler_DataStructures

enum TokenType {
  Identifier
  Keyword
  Operator
  Literal
  Number
  String
  Comment
  Whitespace
  LeftParen
  RightParen
  LeftBrace
  RightBrace
  Semicolon
  Comma
  Dot
  EOF
  Error
}

class Token {
  + type: TokenType
  + lexeme: string
  + value: Variant
  + line: size_t
  + column: size_t
  + position: size_t
}

enum ASTNodeType {
  Program
  FunctionDecl
  VariableDecl
  ClassDecl
  BlockStatement
  ExpressionStatement
  IfStatement
  WhileStatement
  ForStatement
  ReturnStatement
  BinaryExpression
  UnaryExpression
  CallExpression
  MemberExpression
  Identifier
  Literal
}

class ASTNode {
  + nodeType: ASTNodeType
  + children: ASTNode[]
  + token: Token
  + attributes: Json[string]
  + parent: ASTNode
  
  + accept(visitor: IASTVisitor): void
  + addChild(child: ASTNode): void
  + getAttribute(key: string): Json
  + setAttribute(key: string, value: Json): void
}

class Symbol {
  + name: string
  + type: SymbolType
  + dataType: Type
  + scope: Scope
  + defined: bool
  + used: bool
  + line: size_t
  + column: size_t
}

enum SymbolType {
  Variable
  Function
  Class
  Parameter
  Field
  Method
}

class Scope {
  + name: string
  + parent: Scope
  + symbols: Symbol[string]
  + children: Scope[]
  
  + define(name: string, symbol: Symbol): bool
  + lookup(name: string): Symbol
  + resolve(name: string): Symbol
}

class Diagnostic {
  + severity: DiagnosticSeverity
  + message: string
  + line: size_t
  + column: size_t
  + source: string
  + code: string
}

enum DiagnosticSeverity {
  Error
  Warning
  Info
  Hint
}

struct CompilerOptions {
  + optimizationLevel: int
  + target: string
  + debugInfo: bool
  + warnings: bool
  + verbose: bool
}

struct CompilationResult {
  + success: bool
  + output: string
  + diagnostics: Diagnostic[]
  + ast: ASTNode
  + duration: Duration
}

struct CodeGenOptions {
  + format: string
  + prettyPrint: bool
  + comments: bool
  + lineNumbers: bool
}

struct CodeGenResult {
  + code: string
  + success: bool
  + diagnostics: Diagnostic[]
}

struct OptimizationPass {
  + name: string
  + description: string
  + level: int
  + enabled: bool
}

struct OptimizationStats {
  + passesApplied: int
  + nodesOptimized: int
  + duration: Duration
}

ASTNode *-- Token
ASTNode o-- ASTNode : children
Symbol --> SymbolType
Symbol --> Scope
Scope o-- Scope : parent/children
Scope *-- Symbol : symbols
Token --> TokenType
Diagnostic --> DiagnosticSeverity

@enduml
```

### 4. Compilation Pipeline

```plantuml
@startuml Compilation_Pipeline

actor User
participant Compiler
participant Lexer
participant Parser
participant SemanticAnalyzer
participant Optimizer
participant CodeGenerator
database SymbolTable

User -> Compiler: compile(source, options)
activate Compiler

Compiler -> Lexer: tokenize(source)
activate Lexer
Lexer --> Lexer: scanToken()
Lexer --> Lexer: advance()
Lexer --> Compiler: Token[]
deactivate Lexer

Compiler -> Parser: parse(tokens)
activate Parser
Parser --> Parser: parseExpression()
Parser --> Parser: parseStatement()
Parser --> Parser: parseDeclaration()
Parser --> Compiler: ASTNode (root)
deactivate Parser

Compiler -> SemanticAnalyzer: analyze(ast)
activate SemanticAnalyzer
SemanticAnalyzer -> SymbolTable: define(symbol)
SemanticAnalyzer -> SymbolTable: lookup(name)
SemanticAnalyzer -> SymbolTable: resolve(name)
SemanticAnalyzer --> SemanticAnalyzer: checkTypes()
SemanticAnalyzer --> Compiler: ASTNode (annotated)
deactivate SemanticAnalyzer

alt optimization enabled
  Compiler -> Optimizer: optimize(ast, level)
  activate Optimizer
  Optimizer --> Optimizer: constantFolding()
  Optimizer --> Optimizer: deadCodeElimination()
  Optimizer --> Optimizer: commonSubexpressionElimination()
  Optimizer --> Compiler: ASTNode (optimized)
  deactivate Optimizer
end

Compiler -> CodeGenerator: generate(ast, options)
activate CodeGenerator
CodeGenerator --> CodeGenerator: visit(node)
CodeGenerator --> CodeGenerator: emit(instruction)
CodeGenerator --> Compiler: CodeGenResult
deactivate CodeGenerator

Compiler --> User: CompilationResult
deactivate Compiler

@enduml
```

### 5. Visitor Pattern for AST Traversal

```plantuml
@startuml AST_Visitor_Pattern

interface IASTVisitor {
  + visitProgram(node: ASTNode): void
  + visitFunctionDecl(node: ASTNode): void
  + visitVariableDecl(node: ASTNode): void
  + visitBinaryExpression(node: ASTNode): void
  + visitUnaryExpression(node: ASTNode): void
  + visitLiteral(node: ASTNode): void
  + visitIdentifier(node: ASTNode): void
}

abstract class ASTVisitor {
  + visit(node: ASTNode): void
  # visitChildren(node: ASTNode): void
}

class SemanticAnalysisVisitor {
  - _symbolTable: ISymbolTable
  - _errors: Diagnostic[]
  
  + visitVariableDecl(node: ASTNode): void
  + visitFunctionDecl(node: ASTNode): void
  + visitBinaryExpression(node: ASTNode): void
  # checkTypes(left: Type, right: Type): bool
}

class OptimizationVisitor {
  - _stats: OptimizationStats
  
  + visitBinaryExpression(node: ASTNode): void
  + visitUnaryExpression(node: ASTNode): void
  # constantFold(node: ASTNode): ASTNode
  # simplifyExpression(node: ASTNode): ASTNode
}

class CodeGenVisitor {
  - _output: string[]
  - _indent: int
  
  + visitProgram(node: ASTNode): void
  + visitFunctionDecl(node: ASTNode): void
  + visitBinaryExpression(node: ASTNode): void
  # emit(code: string): void
  # emitIndent(): void
}

IASTVisitor <|.. ASTVisitor
ASTVisitor <|-- SemanticAnalysisVisitor
ASTVisitor <|-- OptimizationVisitor
ASTVisitor <|-- CodeGenVisitor

ASTNode --> IASTVisitor : accept()

@enduml
```

### 6. Factory and Registry Pattern for Component Creation and Lookup

```plantuml
@startuml Compiler_Factories_Registries

class LexerFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): ILexer
}

class LexerRegistry {
  - _items: ILexer[string]
  + register(key: string, lexer: ILexer): void
  + get(key: string): ILexer
  + has(key: string): bool
  + unregister(key: string): void
}

class ParserFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): ICompilerParser
}

class ParserRegistry {
  - _items: ICompilerParser[string]
  + register(key: string, parser: ICompilerParser): void
  + get(key: string): ICompilerParser
  + has(key: string): bool
  + unregister(key: string): void
}

class SemanticAnalyzerFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): ISemanticAnalyzer
}

class SemanticAnalyzerRegistry {
  - _items: ISemanticAnalyzer[string]
  + register(key: string, analyzer: ISemanticAnalyzer): void
  + get(key: string): ISemanticAnalyzer
  + has(key: string): bool
  + unregister(key: string): void
}

class OptimizerFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): IOptimizer
}

class OptimizerRegistry {
  - _items: IOptimizer[string]
  + register(key: string, optimizer: IOptimizer): void
  + get(key: string): IOptimizer
  + has(key: string): bool
  + unregister(key: string): void
}

class CodeGeneratorFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): ICodeGenerator
}

class CodeGeneratorRegistry {
  - _items: ICodeGenerator[string]
  + register(key: string, codegen: ICodeGenerator): void
  + get(key: string): ICodeGenerator
  + has(key: string): bool
  + unregister(key: string): void
}

class CompilerFactory {
  + register(key: string, creator: function): void
  + create(key: string, ...args): ICompiler
}

class CompilerRegistry {
  - _items: ICompiler[string]
  + register(key: string, compiler: ICompiler): void
  + get(key: string): ICompiler
  + has(key: string): bool
  + unregister(key: string): void
}

LexerFactory ..> ILexer : creates
LexerRegistry o-- ILexer : stores
ParserFactory ..> ICompilerParser : creates
ParserRegistry o-- ICompilerParser : stores
SemanticAnalyzerFactory ..> ISemanticAnalyzer : creates
SemanticAnalyzerRegistry o-- ISemanticAnalyzer : stores
OptimizerFactory ..> IOptimizer : creates
OptimizerRegistry o-- IOptimizer : stores
CodeGeneratorFactory ..> ICodeGenerator : creates
CodeGeneratorRegistry o-- ICodeGenerator : stores
CompilerFactory ..> ICompiler : creates
CompilerRegistry o-- ICompiler : stores

@enduml
```

### 7. Error Handling

```plantuml
@startuml Error_Handling

class DiagnosticManager {
  - _diagnostics: Diagnostic[]
  - _errorCount: int
  - _warningCount: int
  
  + addError(message: string, line: size_t, column: size_t): void
  + addWarning(message: string, line: size_t, column: size_t): void
  + addInfo(message: string, line: size_t, column: size_t): void
  + hasErrors(): bool
  + hasWarnings(): bool
  + clear(): void
  + getDiagnostics(): Diagnostic[]
  + getErrors(): Diagnostic[]
  + getWarnings(): Diagnostic[]
}

class CompilerException {
  + message: string
  + diagnostic: Diagnostic
  + this(message: string, diagnostic: Diagnostic)
}

class LexerException {
  + position: size_t
  + this(message: string, position: size_t)
}

class ParserException {
  + token: Token
  + this(message: string, token: Token)
}

class SemanticException {
  + node: ASTNode
  + this(message: string, node: ASTNode)
}

Exception <|-- CompilerException
CompilerException <|-- LexerException
CompilerException <|-- ParserException
CompilerException <|-- SemanticException

Compiler --> DiagnosticManager
Lexer --> DiagnosticManager
Parser --> DiagnosticManager
SemanticAnalyzer --> DiagnosticManager

@enduml
```

### 8. Complete System Overview

```plantuml
@startuml Complete_System_Overview

package "uim.compilers.interfaces" {
  interface ICompiler
  interface ILexer
  interface ICompilerParser
  interface ISemanticAnalyzer
  interface IOptimizer
  interface ICodeGenerator
  interface ISymbolTable
  interface IASTVisitor
}

package "uim.compilers.classes" {
  package "compilers" {
    class Compiler
    class CompilerFactory
    class CompilerRegistry
  }
  
  package "lexers" {
    class Lexer
    class LexerFactory
    class LexerRegistry
  }
  
  package "parsers" {
    class Parser
    class ParserFactory
    class ParserRegistry
  }
  
  package "analyzers" {
    class SemanticAnalyzer
    class SemanticAnalyzerFactory
    class SemanticAnalyzerRegistry
    class SemanticAnalysisVisitor
  }
  
  package "optimizers" {
    class Optimizer
    class OptimizerFactory
    class OptimizerRegistry
    class OptimizationVisitor
  }
  
  package "generators" {
    class CodeGenerator
    class CodeGeneratorFactory
    class CodeGeneratorRegistry
    class CodeGenVisitor
  }
}

package "uim.compilers.helpers" {
  class DiagnosticManager
  class SymbolTable
  class Scope
}

package "uim.compilers.errors" {
  class CompilerException
  class LexerException
  class ParserException
  class SemanticException
}

Compiler ..|> ICompiler
Lexer ..|> ILexer
Parser ..|> ICompilerParser
SemanticAnalyzer ..|> ISemanticAnalyzer
Optimizer ..|> IOptimizer
CodeGenerator ..|> ICodeGenerator
SymbolTable ..|> ISymbolTable

Compiler --> Lexer
Compiler --> Parser
Compiler --> SemanticAnalyzer
Compiler --> Optimizer
Compiler --> CodeGenerator

SemanticAnalyzer --> SymbolTable
SemanticAnalyzer --> SemanticAnalysisVisitor
Optimizer --> OptimizationVisitor
CodeGenerator --> CodeGenVisitor

Compiler --> DiagnosticManager
Lexer --> DiagnosticManager
Parser --> DiagnosticManager

@enduml
```

## Component Descriptions

### ICompiler / Compiler
**Purpose**: Orchestrates the entire compilation process
**Responsibilities**:
- Coordinate all compilation phases
- Manage compiler components (lexer, parser, analyzer, optimizer, code generator)
- Collect and report diagnostics
- Provide compilation results

### ILexer / Lexer
**Purpose**: Perform lexical analysis (tokenization)
**Responsibilities**:
- Break source code into tokens
- Track line and column numbers
- Handle whitespace and comments
- Report lexical errors

### ICompilerParser / Parser
**Purpose**: Perform syntax analysis
**Responsibilities**:
- Build Abstract Syntax Tree (AST) from tokens
- Validate syntactic structure
- Report syntax errors
- Handle error recovery

### ISemanticAnalyzer / SemanticAnalyzer
**Purpose**: Perform semantic analysis
**Responsibilities**:
- Type checking
- Symbol resolution
- Scope management
- Semantic validation
- Report semantic errors and warnings

### IOptimizer / Optimizer
**Purpose**: Optimize code representation
**Responsibilities**:
- Apply optimization passes
- Constant folding
- Dead code elimination
- Common subexpression elimination
- Track optimization statistics

### ICodeGenerator / CodeGenerator
**Purpose**: Generate target code
**Responsibilities**:
- Traverse optimized AST
- Emit target code
- Support multiple target formats
- Apply code generation options

### ISymbolTable / SymbolTable
**Purpose**: Manage symbols and scopes
**Responsibilities**:
- Track symbol definitions
- Resolve symbol references
- Manage scope hierarchy
- Support nested scopes

## Design Patterns Used

1. **Strategy Pattern**: Different algorithms for optimization passes
2. **Factory Pattern**: Component creation and configuration via dedicated factory classes
3. **Registry Pattern**: Runtime lookup and retrieval of registered component instances
4. **Visitor Pattern**: AST traversal and transformation
5. **Chain of Responsibility**: Error recovery and diagnostic reporting
6. **Composite Pattern**: AST node structure
7. **Template Method**: Base compilation pipeline with customizable steps

## Key Features

- **Modular Architecture**: Each compiler phase is independently replaceable
- **Pluggable Components**: Factory and registry patterns enable dynamic composition
- **Extensible**: New optimizations, code generators, and language features can be added
- **Error Recovery**: Robust error handling with detailed diagnostics
- **Multi-target**: Support for multiple output formats
- **Performance Tracking**: Built-in profiling and statistics
- **Type Safety**: Strong typing throughout the compilation pipeline
- **Runtime Configuration**: Use registries to select implementations at runtime

## Usage Examples

```d
// Basic compilation
auto compiler = new Compiler();
auto result = compiler.compile(sourceCode);

// Using registries for runtime configuration
auto lexerRegistry = new LexerRegistry();
lexerRegistry.register("json", new JsonLexer());
lexerRegistry.register("xml", new XmlLexer());

auto parserRegistry = new ParserRegistry();
parserRegistry.register("json", new JsonParser());
parserRegistry.register("xml", new XmlParser());

// Select implementation at runtime
auto format = "json"; // Could come from config
auto compiler = new Compiler();
compiler.lexer(lexerRegistry.get(format));
compiler.parser(parserRegistry.get(format));
auto result = compiler.compile(sourceCode);

// Custom configuration with factory
auto compiler = new Compiler();
compiler.lexer(new CustomLexer());
compiler.optimizer(new AggressiveOptimizer());
auto result = compiler.compile(sourceCode, 
  CompilerOptions(optimizationLevel: 3, target: "llvm-ir"));

// Use compiler registry for complete instances
auto compilerRegistry = new CompilerRegistry();
compilerRegistry.register("javascript", new JavaScriptCompiler());
compilerRegistry.register("typescript", new TypeScriptCompiler());

auto compiler = compilerRegistry.get("javascript");
auto result = compiler.compile(jsCode);
```

This UML description provides a comprehensive view of the uim-compiler framework architecture,
showing the relationships between components, data flow, and design patterns employed.
