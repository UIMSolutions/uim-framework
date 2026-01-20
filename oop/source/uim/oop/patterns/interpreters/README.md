# Interpreter Pattern

## Purpose
The Interpreter Pattern is a behavioral design pattern that defines a grammatical representation for a language and provides an interpreter to evaluate sentences in that language. It represents each grammar rule as a class and builds an abstract syntax tree (AST) to interpret expressions. This pattern is ideal for implementing domain-specific languages, expression evaluators, and rule engines.

## Problem It Solves
- **Language Implementation**: When you need to interpret or evaluate expressions in a custom language
- **Complex Rules**: When business rules or expressions need to be evaluated dynamically
- **Expression Parsing**: When you need to parse and evaluate mathematical, logical, or domain-specific expressions
- **Grammar Representation**: When grammar rules should be represented as a class hierarchy
- **Extensibility**: When new grammar rules should be easy to add without modifying existing code

## UML Class Diagram
```
┌─────────────────┐
│   IExpression   │
├─────────────────┤
│ + interpret()   │
│ + toString()    │
└────────▲────────┘
         │
         │ implements
    ┌────┴─────┐
    │          │
┌───┴────────┐ │
│ Terminal   │ │
│ Expression │ │
├────────────┤ │
│ - value    │ │
└────────────┘ │
               │
        ┌──────┴──────────┐
        │  Nonterminal    │
        │  Expression     │
        ├─────────────────┤
        │ - left          │
        │ - right         │
        │ + getChildren() │
        └─────────────────┘

┌─────────────┐         ┌─────────────┐
│  IContext   │◄────────│ IExpression │
├─────────────┤         └─────────────┘
│ - variables │
│ + get()     │
│ + set()     │
└─────────────┘

Client ──► builds ──► Abstract Syntax Tree ──► interprets ──► Result
```

## Components

### 1. IContext
Stores global information needed during interpretation.
```d
interface IContext {
    void setVariable(string name, Variant value);
    Variant getVariable(string name) const;
    bool hasVariable(string name) const;
}
```

### 2. IExpression
The abstract expression interface.
```d
interface IExpression {
    Variant interpret(IContext context);
    string toString() const;
}
```

### 3. Terminal Expression
Leaf nodes that represent basic elements (literals, variables).
```d
class LiteralExpression : IExpression {
    private Variant _value;
    
    Variant interpret(IContext context) {
        return _value;
    }
}

class VariableExpression : IExpression {
    private string _name;
    
    Variant interpret(IContext context) {
        return context.getVariable(_name);
    }
}
```

### 4. Nonterminal Expression
Composite nodes that combine other expressions.
```d
class AddExpression : BinaryExpression {
    Variant interpret(IContext context) {
        auto left = _left.interpret(context);
        auto right = _right.interpret(context);
        return Variant(left.get!int + right.get!int);
    }
}
```

## Real-World Examples

### Example 1: Arithmetic Expression Evaluator
Mathematical expression interpreter with operator precedence:
```d
auto context = new Context();
context.setVariable("x", Variant(10));
context.setVariable("y", Variant(5));

// Build expression tree: (x + y) * 2
auto x = new VariableExpression("x");
auto y = new VariableExpression("y");
auto two = new LiteralExpression(Variant(2));

auto add = new AddExpression(x, y);
auto multiply = new MultiplyExpression(add, two);

auto result = multiply.interpret(context);
// Result: (10 + 5) * 2 = 30
```

**Key Features:**
- Variable substitution
- Operator composition
- Type handling (int, double)
- Expression tree building

### Example 2: Boolean Logic Evaluator
Rule engine for access control and decision making:
```d
auto context = new Context();
context.setVariable("isActive", Variant(true));
context.setVariable("isVerified", Variant(true));
context.setVariable("isBlocked", Variant(false));

// Build rule: (isActive AND isVerified) AND (NOT isBlocked)
auto active = new VariableExpression("isActive");
auto verified = new VariableExpression("isVerified");
auto blocked = new VariableExpression("isBlocked");

auto hasAccess = new AndExpression(
    new AndExpression(active, verified),
    new NotExpression(blocked)
);

auto canAccess = hasAccess.interpret(context).get!bool;
// Result: true
```

**Key Features:**
- Boolean operations (AND, OR, NOT)
- Complex rule composition
- Access control logic
- Dynamic rule evaluation

### Example 3: Roman Numeral Interpreter
Language interpreter for Roman numeral system:
```d
auto interpreter = new RomanNumeralInterpreter();

// Define grammar rules
interpreter.addRule("M", 1000);
interpreter.addRule("CM", 900);
interpreter.addRule("D", 500);
interpreter.addRule("CD", 400);
// ... more rules

auto value = interpreter.interpret("MCMXCIV");
// Result: 1994
```

**Key Features:**
- Custom grammar definition
- Sequential rule application
- Subtractive notation handling
- Context-based interpretation

### Example 4: SQL-like Query Interpreter
Simple query language for data filtering:
```d
auto context = new QueryContext();
context.addTable("users", [
    "id=1,name=Alice,age=30",
    "id=2,name=Bob,age=25"
]);

auto query = new SelectExpression("users", "Alice");
auto results = query.interpret(context);
// Results: rows containing "Alice"
```

**Key Features:**
- Table management
- Row filtering
- Pattern matching
- Query composition

## Benefits

1. **Extensibility**: Easy to add new grammar rules by adding new classes
2. **Grammar Representation**: Grammar is explicitly represented in the class hierarchy
3. **Composability**: Complex expressions built from simple ones
4. **Type Safety**: Compile-time checking of expression structure
5. **Testability**: Each expression type can be tested independently
6. **Reusability**: Expression objects can be reused in different contexts

## When to Use

- When you need to interpret sentences in a language
- When the grammar is simple and can be represented as a tree
- When efficiency is not critical (interpretation can be slow)
- When you need to build abstract syntax trees (AST)
- When implementing domain-specific languages (DSL)
- When creating configuration languages or rule engines
- When building expression evaluators or formula calculators

## When Not to Use

- When the grammar is complex (consider parser generators instead)
- When performance is critical (interpretation has overhead)
- When the grammar changes frequently (maintenance burden)
- When you need to parse arbitrary text (use dedicated parsers)
- When the language is well-established (use existing interpreters)

## Implementation Considerations

### 1. Expression Tree Building
Build the abstract syntax tree programmatically:
```d
// Manual tree building
auto expr = new AddExpression(
    new LiteralExpression(Variant(10)),
    new LiteralExpression(Variant(20))
);

// Or use a parser
auto parser = new ExpressionParser();
auto expr = parser.parse("10 + 20");
```

### 2. Context Management
Store and retrieve variables:
```d
class Context : IContext {
    private Variant[string] _variables;
    
    void setVariable(string name, Variant value) {
        _variables[name] = value;
    }
    
    Variant getVariable(string name) const {
        return _variables[name];
    }
}
```

### 3. Type Handling
Handle different value types:
```d
Variant interpret(IContext context) {
    auto left = _left.interpret(context);
    auto right = _right.interpret(context);
    
    if (left.type == typeid(int) && right.type == typeid(int)) {
        return Variant(left.get!int + right.get!int);
    } else if (left.type == typeid(double) || right.type == typeid(double)) {
        double l = left.convertsTo!double ? left.get!double : left.get!int;
        double r = right.convertsTo!double ? right.get!double : right.get!int;
        return Variant(l + r);
    }
    throw new Exception("Invalid types");
}
```

### 4. Error Handling
Provide meaningful error messages:
```d
Variant interpret(IContext context) {
    if (!context.hasVariable(_name)) {
        throw new Exception("Variable not found: " ~ _name);
    }
    return context.getVariable(_name);
}
```

## Advanced Features

### 1. Expression Optimization
Optimize constant expressions:
```d
class ExpressionOptimizer {
    IExpression optimize(IExpression expr) {
        // Fold constant expressions
        if (auto binExpr = cast(BinaryExpression)expr) {
            if (isConstant(binExpr.getLeft()) && isConstant(binExpr.getRight())) {
                auto result = binExpr.interpret(new Context());
                return new LiteralExpression(result);
            }
        }
        return expr;
    }
}
```

### 2. Expression Visitors
Traverse expression trees:
```d
interface IExpressionVisitor {
    void visitLiteral(ILiteralExpression expr);
    void visitVariable(IVariableExpression expr);
    void visitBinary(IBinaryExpression expr);
}

class PrintVisitor : IExpressionVisitor {
    void visitBinary(IBinaryExpression expr) {
        writeln("Binary: ", expr.getOperator());
        expr.getLeft().accept(this);
        expr.getRight().accept(this);
    }
}
```

### 3. Parser Integration
Parse text into expression trees:
```d
interface IParser {
    IExpression parse(string input);
}

class ArithmeticParser : IParser {
    IExpression parse(string input) {
        // Tokenize and parse input
        auto tokens = tokenize(input);
        return buildTree(tokens);
    }
}
```

### 4. Grammar Definition
Define grammar rules:
```d
interface IGrammar {
    string[] getOperators() const;
    int getPrecedence(string operator) const;
    bool isValidOperator(string operator) const;
}
```

## Comparison with Other Patterns

### Interpreter vs Strategy
- **Interpreter**: Represents grammar as class hierarchy, builds AST
- **Strategy**: Encapsulates algorithms, no grammar representation

### Interpreter vs Composite
- **Interpreter**: Tree structure for language expressions
- **Composite**: Tree structure for object hierarchies
- **Note**: Interpreter often uses Composite pattern

### Interpreter vs Visitor
- **Interpreter**: Each node knows how to interpret itself
- **Visitor**: Operations separated from structure
- **Note**: Visitor can be used with Interpreter for tree traversal

## Best Practices

1. **Keep Grammar Simple**: Complex grammars are hard to maintain
2. **Use Variant Types**: Handle multiple value types flexibly
3. **Implement toString()**: For debugging and visualization
4. **Cache Results**: Avoid re-evaluating constant expressions
5. **Error Messages**: Provide clear error messages with context
6. **Document Grammar**: Clearly document the language grammar
7. **Test Each Rule**: Test terminal and nonterminal expressions separately
8. **Consider Performance**: Interpretation can be slow for complex expressions

## Common Pitfalls

1. **Over-Engineering**: Too many expression types for simple needs
2. **Performance**: Interpretation overhead for frequently-evaluated expressions
3. **Type Safety**: Not handling type mismatches properly
4. **Grammar Complexity**: Complex grammars become unmaintainable
5. **Memory Management**: Large expression trees can consume memory
6. **Error Recovery**: Poor error handling makes debugging difficult

## Testing Strategy

1. **Terminal Expressions**: Test literals and variables
2. **Binary Operations**: Test each operator independently
3. **Unary Operations**: Test negation, NOT, etc.
4. **Complex Trees**: Test nested expression evaluation
5. **Context Management**: Test variable storage and retrieval
6. **Error Cases**: Test invalid operations and missing variables
7. **Type Handling**: Test mixed type operations

## Performance Considerations

### Time Complexity
- **Interpretation**: O(n) where n is number of nodes in expression tree
- **Tree Building**: O(n) for n expression nodes
- **Context Lookup**: O(1) with hash map, O(log n) with tree

### Space Complexity
- **Expression Tree**: O(n) for n nodes
- **Context Storage**: O(v) for v variables
- **Recursion Stack**: O(h) where h is tree height

### Optimization Tips
- Cache constant expression results
- Use iterative evaluation instead of recursive when possible
- Optimize expression trees before interpretation
- Consider compiling expressions for repeated evaluation
- Use efficient data structures for context storage

## Related Patterns

- **Composite**: Interpreter uses Composite for expression tree structure
- **Visitor**: Can traverse and operate on expression trees
- **Flyweight**: Share common terminal expressions
- **Iterator**: Traverse expression trees
- **Strategy**: Alternative for simpler expression evaluation

## See Also
- [Composite Pattern](../composites/README.md)
- [Visitor Pattern](../visitors/README.md)
- [Strategy Pattern](../strategies/README.md)
- [Command Pattern](../commands/README.md)
