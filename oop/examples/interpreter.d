/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.interpreter;

import uim.oop;
import std.stdio;
import std.variant;

void main() {
    writeln("\n=== Interpreter Pattern Examples ===\n");
    
    example1_BasicArithmetic();
    example2_VariablesAndContext();
    example3_ComplexExpressions();
    example4_BooleanLogic();
    example5_RomanNumerals();
    example6_QueryInterpreter();
    example7_ComparisonOperators();
    example8_NestedExpressions();
}

/**
 * Example 1: Basic arithmetic expressions
 */
void example1_BasicArithmetic() {
    writeln("Example 1: Basic Arithmetic Expressions");
    writeln("----------------------------------------");
    
    auto context = new Context();
    
    // 10 + 5 = 15
    auto add = new AddExpression(
        new LiteralExpression(Variant(10)),
        new LiteralExpression(Variant(5))
    );
    writeln("Expression: 10 + 5");
    writeln("Result: ", add.interpret(context).get!int);
    writeln("String representation: ", add.toString());
    
    // 20 - 8 = 12
    auto sub = new SubtractExpression(
        new LiteralExpression(Variant(20)),
        new LiteralExpression(Variant(8))
    );
    writeln("\nExpression: 20 - 8");
    writeln("Result: ", sub.interpret(context).get!int);
    
    // 6 * 7 = 42
    auto mul = new MultiplyExpression(
        new LiteralExpression(Variant(6)),
        new LiteralExpression(Variant(7))
    );
    writeln("\nExpression: 6 * 7");
    writeln("Result: ", mul.interpret(context).get!int);
    
    // 100 / 4 = 25
    auto div = new DivideExpression(
        new LiteralExpression(Variant(100)),
        new LiteralExpression(Variant(4))
    );
    writeln("\nExpression: 100 / 4");
    writeln("Result: ", div.interpret(context).get!int);
    writeln();
}

/**
 * Example 2: Using variables and context
 */
void example2_VariablesAndContext() {
    writeln("Example 2: Variables and Context");
    writeln("---------------------------------");
    
    auto context = new Context();
    context.setVariable("price", Variant(100));
    context.setVariable("discount", Variant(15));
    context.setVariable("tax", Variant(8));
    
    writeln("Variables:");
    writeln("  price = 100");
    writeln("  discount = 15");
    writeln("  tax = 8");
    
    // Calculate: (price - discount) + tax
    auto price = new VariableExpression("price");
    auto discount = new VariableExpression("discount");
    auto tax = new VariableExpression("tax");
    
    auto afterDiscount = new SubtractExpression(price, discount);
    auto finalPrice = new AddExpression(afterDiscount, tax);
    
    writeln("\nExpression: (price - discount) + tax");
    writeln("String representation: ", finalPrice.toString());
    writeln("Result: ", finalPrice.interpret(context).get!int);
    writeln();
}

/**
 * Example 3: Complex nested expressions
 */
void example3_ComplexExpressions() {
    writeln("Example 3: Complex Nested Expressions");
    writeln("---------------------------------------");
    
    auto context = new Context();
    
    // ((10 + 5) * 2) - (8 / 4) = 30 - 2 = 28
    auto expr = new SubtractExpression(
        new MultiplyExpression(
            new AddExpression(
                new LiteralExpression(Variant(10)),
                new LiteralExpression(Variant(5))
            ),
            new LiteralExpression(Variant(2))
        ),
        new DivideExpression(
            new LiteralExpression(Variant(8)),
            new LiteralExpression(Variant(4))
        )
    );
    
    writeln("Expression: ((10 + 5) * 2) - (8 / 4)");
    writeln("String representation: ", expr.toString());
    writeln("Result: ", expr.interpret(context).get!int);
    
    // Step-by-step evaluation:
    writeln("\nStep-by-step:");
    writeln("  10 + 5 = 15");
    writeln("  15 * 2 = 30");
    writeln("  8 / 4 = 2");
    writeln("  30 - 2 = 28");
    writeln();
}

/**
 * Example 4: Boolean logic expressions
 */
void example4_BooleanLogic() {
    writeln("Example 4: Boolean Logic");
    writeln("-------------------------");
    
    auto context = new Context();
    context.setVariable("isActive", Variant(true));
    context.setVariable("isVerified", Variant(true));
    context.setVariable("isBlocked", Variant(false));
    
    writeln("Variables:");
    writeln("  isActive = true");
    writeln("  isVerified = true");
    writeln("  isBlocked = false");
    
    // isActive AND isVerified
    auto active = new VariableExpression("isActive");
    auto verified = new VariableExpression("isVerified");
    auto canAccess = new AndExpression(active, verified);
    
    writeln("\nExpression: isActive AND isVerified");
    writeln("Result: ", canAccess.interpret(context).get!bool);
    
    // NOT isBlocked
    auto blocked = new VariableExpression("isBlocked");
    auto notBlocked = new NotExpression(blocked);
    
    writeln("\nExpression: NOT isBlocked");
    writeln("Result: ", notBlocked.interpret(context).get!bool);
    
    // (isActive AND isVerified) AND (NOT isBlocked)
    auto finalAccess = new AndExpression(canAccess, notBlocked);
    
    writeln("\nExpression: (isActive AND isVerified) AND (NOT isBlocked)");
    writeln("String representation: ", finalAccess.toString());
    writeln("Result: ", finalAccess.interpret(context).get!bool);
    writeln();
}

/**
 * Example 5: Roman numeral interpreter
 */
void example5_RomanNumerals() {
    writeln("Example 5: Roman Numeral Interpreter");
    writeln("-------------------------------------");
    
    auto interpreter = new RomanNumeralInterpreter();
    
    string[] romanNumerals = [
        "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
        "XL", "L", "XC", "C", "CD", "D", "CM", "M",
        "XLII", "XCIX", "CDXLIV", "MCMXCIV", "MMXXVI"
    ];
    
    writeln("Roman Numeral Conversions:");
    foreach (roman; romanNumerals) {
        writeln("  ", roman, " = ", interpreter.interpret(roman));
    }
    writeln();
}

/**
 * Example 6: Simple query interpreter
 */
void example6_QueryInterpreter() {
    writeln("Example 6: Query Interpreter");
    writeln("-----------------------------");
    
    auto context = new QueryContext();
    
    // Add sample data
    context.addTable("users", [
        "id=1,name=Alice,age=30",
        "id=2,name=Bob,age=25",
        "id=3,name=Charlie,age=35",
        "id=4,name=Alice,age=28"
    ]);
    
    writeln("Table: users");
    writeln("  id=1,name=Alice,age=30");
    writeln("  id=2,name=Bob,age=25");
    writeln("  id=3,name=Charlie,age=35");
    writeln("  id=4,name=Alice,age=28");
    
    // SELECT * FROM users
    auto selectAll = new SelectExpression("users");
    auto allRows = selectAll.interpret(context);
    
    writeln("\nQuery: SELECT * FROM users");
    writeln("Results: ", allRows.length, " rows");
    
    // SELECT * FROM users WHERE name contains 'Alice'
    auto selectAlice = new SelectExpression("users", "Alice");
    auto aliceRows = selectAlice.interpret(context);
    
    writeln("\nQuery: SELECT * FROM users WHERE name LIKE '%Alice%'");
    writeln("Results: ", aliceRows.length, " rows");
    foreach (row; aliceRows) {
        writeln("  ", row);
    }
    writeln();
}

/**
 * Example 7: Comparison operators
 */
void example7_ComparisonOperators() {
    writeln("Example 7: Comparison Operators");
    writeln("--------------------------------");
    
    auto context = new Context();
    context.setVariable("score", Variant(85));
    context.setVariable("passingScore", Variant(60));
    
    writeln("Variables:");
    writeln("  score = 85");
    writeln("  passingScore = 60");
    
    // score > passingScore
    auto score = new VariableExpression("score");
    auto passing = new VariableExpression("passingScore");
    auto isPassing = new GreaterThanExpression(score, passing);
    
    writeln("\nExpression: score > passingScore");
    writeln("Result: ", isPassing.interpret(context).get!bool);
    
    // score == 85
    auto scoreCheck = new EqualsExpression(
        new VariableExpression("score"),
        new LiteralExpression(Variant(85))
    );
    
    writeln("\nExpression: score == 85");
    writeln("Result: ", scoreCheck.interpret(context).get!bool);
    
    // passingScore < 100
    auto maxCheck = new LessThanExpression(
        new VariableExpression("passingScore"),
        new LiteralExpression(Variant(100))
    );
    
    writeln("\nExpression: passingScore < 100");
    writeln("Result: ", maxCheck.interpret(context).get!bool);
    writeln();
}

/**
 * Example 8: Building expression trees programmatically
 */
void example8_NestedExpressions() {
    writeln("Example 8: Building Expression Trees");
    writeln("--------------------------------------");
    
    auto context = new Context();
    context.setVariable("a", Variant(10));
    context.setVariable("b", Variant(20));
    context.setVariable("c", Variant(30));
    context.setVariable("d", Variant(5));
    
    writeln("Variables: a=10, b=20, c=30, d=5");
    
    // Formula: ((a + b) * c) / d = ((10 + 20) * 30) / 5 = 900 / 5 = 180
    auto a = new VariableExpression("a");
    auto b = new VariableExpression("b");
    auto c = new VariableExpression("c");
    auto d = new VariableExpression("d");
    
    auto step1 = new AddExpression(a, b);
    auto step2 = new MultiplyExpression(step1, c);
    auto step3 = new DivideExpression(step2, d);
    
    writeln("\nExpression: ((a + b) * c) / d");
    writeln("String representation: ", step3.toString());
    writeln("\nEvaluation steps:");
    writeln("  a + b = ", step1.interpret(context).get!int);
    
    context.setVariable("temp1", step1.interpret(context));
    auto temp1 = new VariableExpression("temp1");
    auto step2Alt = new MultiplyExpression(temp1, c);
    writeln("  (a + b) * c = ", step2Alt.interpret(context).get!int);
    
    writeln("  ((a + b) * c) / d = ", step3.interpret(context).get!int);
    
    // Navigate the expression tree
    writeln("\nExpression tree structure:");
    writeln("  Root operator: ", step3.getOperator());
    writeln("  Left child: ", step3.getLeft().toString());
    writeln("  Right child: ", step3.getRight().toString());
    writeln("  Number of children: ", step3.getChildren().length);
    writeln();
}
