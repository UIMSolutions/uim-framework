/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.interpreters;

import uim.oop;
import std.variant;
import std.conv;

// Test 1: Basic literal expression
@safe unittest {
    auto literal = new LiteralExpression(Variant(100));
    auto context = new Context();
    auto result = literal.interpret(context);
    assert(result.get!int == 100);
    assert(literal.toString() == "100");
}

// Test 2: Variable expression with context
@safe unittest {
    auto context = new Context();
    context.setVariable("age", Variant(25));
    
    auto variable = new VariableExpression("age");
    auto result = variable.interpret(context);
    assert(result.get!int == 25);
    assert(variable.getName() == "age");
}

// Test 3: Multiple variables in context
@safe unittest {
    auto context = new Context();
    context.setVariable("x", Variant(10));
    context.setVariable("y", Variant(20));
    context.setVariable("z", Variant(30));
    
    assert(context.hasVariable("x"));
    assert(context.hasVariable("y"));
    assert(context.hasVariable("z"));
    assert(!context.hasVariable("w"));
    
    auto names = context.getVariableNames();
    assert(names.length == 3);
}

// Test 4: Addition expression
@safe unittest {
    auto left = new LiteralExpression(Variant(15));
    auto right = new LiteralExpression(Variant(25));
    auto add = new AddExpression(left, right);
    
    auto context = new Context();
    auto result = add.interpret(context);
    assert(result.get!int == 40);
    assert(add.getOperator() == "+");
}

// Test 5: Subtraction expression
@safe unittest {
    auto left = new LiteralExpression(Variant(50));
    auto right = new LiteralExpression(Variant(18));
    auto sub = new SubtractExpression(left, right);
    
    auto context = new Context();
    auto result = sub.interpret(context);
    assert(result.get!int == 32);
    assert(sub.getOperator() == "-");
}

// Test 6: Multiplication expression
@safe unittest {
    auto left = new LiteralExpression(Variant(8));
    auto right = new LiteralExpression(Variant(9));
    auto mul = new MultiplyExpression(left, right);
    
    auto context = new Context();
    auto result = mul.interpret(context);
    assert(result.get!int == 72);
    assert(mul.getOperator() == "*");
}

// Test 7: Division expression
@safe unittest {
    auto left = new LiteralExpression(Variant(100));
    auto right = new LiteralExpression(Variant(5));
    auto div = new DivideExpression(left, right);
    
    auto context = new Context();
    auto result = div.interpret(context);
    assert(result.get!int == 20);
    assert(div.getOperator() == "/");
}

// Test 8: Complex arithmetic: (5 + 3) * 2
@safe unittest {
    auto five = new LiteralExpression(Variant(5));
    auto three = new LiteralExpression(Variant(3));
    auto two = new LiteralExpression(Variant(2));
    
    auto add = new AddExpression(five, three);
    auto mul = new MultiplyExpression(add, two);
    
    auto context = new Context();
    auto result = mul.interpret(context);
    assert(result.get!int == 16);
}

// Test 9: Complex arithmetic: (20 - 5) / 3
@safe unittest {
    auto twenty = new LiteralExpression(Variant(20));
    auto five = new LiteralExpression(Variant(5));
    auto three = new LiteralExpression(Variant(3));
    
    auto sub = new SubtractExpression(twenty, five);
    auto div = new DivideExpression(sub, three);
    
    auto context = new Context();
    auto result = div.interpret(context);
    assert(result.get!int == 5);
}

// Test 10: Arithmetic with variables
@safe unittest {
    auto context = new Context();
    context.setVariable("x", Variant(10));
    context.setVariable("y", Variant(20));
    
    auto varX = new VariableExpression("x");
    auto varY = new VariableExpression("y");
    auto add = new AddExpression(varX, varY);
    
    auto result = add.interpret(context);
    assert(result.get!int == 30);
}

// Test 11: Mixed literals and variables
@safe unittest {
    auto context = new Context();
    context.setVariable("price", Variant(100));
    
    auto price = new VariableExpression("price");
    auto discount = new LiteralExpression(Variant(15));
    auto sub = new SubtractExpression(price, discount);
    
    auto result = sub.interpret(context);
    assert(result.get!int == 85);
}

// Test 12: Double precision arithmetic
@safe unittest {
    auto left = new LiteralExpression(Variant(10.5));
    auto right = new LiteralExpression(Variant(2.5));
    auto add = new AddExpression(left, right);
    
    auto context = new Context();
    auto result = add.interpret(context);
    assert(result.get!double == 13.0);
}

// Test 13: Boolean AND expression
@safe unittest {
    auto trueExpr1 = new LiteralExpression(Variant(true));
    auto trueExpr2 = new LiteralExpression(Variant(true));
    auto andExpr = new AndExpression(trueExpr1, trueExpr2);
    
    auto context = new Context();
    auto result = andExpr.interpret(context);
    assert(result.get!bool == true);
    assert(andExpr.getOperator() == "AND");
}

// Test 14: Boolean OR expression
@safe unittest {
    auto trueExpr = new LiteralExpression(Variant(true));
    auto falseExpr = new LiteralExpression(Variant(false));
    auto orExpr = new OrExpression(trueExpr, falseExpr);
    
    auto context = new Context();
    auto result = orExpr.interpret(context);
    assert(result.get!bool == true);
    assert(orExpr.getOperator() == "OR");
}

// Test 15: Boolean NOT expression
@safe unittest {
    auto falseExpr = new LiteralExpression(Variant(false));
    auto notExpr = new NotExpression(falseExpr);
    
    auto context = new Context();
    auto result = notExpr.interpret(context);
    assert(result.get!bool == true);
    assert(notExpr.getOperator() == "NOT");
}

// Test 16: Complex boolean: (true AND false) OR true
@safe unittest {
    auto trueExpr1 = new LiteralExpression(Variant(true));
    auto falseExpr = new LiteralExpression(Variant(false));
    auto trueExpr2 = new LiteralExpression(Variant(true));
    
    auto andExpr = new AndExpression(trueExpr1, falseExpr);
    auto orExpr = new OrExpression(andExpr, trueExpr2);
    
    auto context = new Context();
    auto result = orExpr.interpret(context);
    assert(result.get!bool == true);
}

// Test 17: Boolean with variables
@safe unittest {
    auto context = new Context();
    context.setVariable("isActive", Variant(true));
    context.setVariable("isVerified", Variant(true));
    
    auto active = new VariableExpression("isActive");
    auto verified = new VariableExpression("isVerified");
    auto andExpr = new AndExpression(active, verified);
    
    auto result = andExpr.interpret(context);
    assert(result.get!bool == true);
}

// Test 18: Negation expression
@safe unittest {
    auto five = new LiteralExpression(Variant(5));
    auto negate = new NegateExpression(five);
    
    auto context = new Context();
    auto result = negate.interpret(context);
    assert(result.get!int == -5);
    assert(negate.getOperator() == "-");
}

// Test 19: Equals expression
@safe unittest {
    auto left = new LiteralExpression(Variant(42));
    auto right = new LiteralExpression(Variant(42));
    auto equals = new EqualsExpression(left, right);
    
    auto context = new Context();
    auto result = equals.interpret(context);
    assert(result.get!bool == true);
    assert(equals.getOperator() == "==");
}

// Test 20: Greater than expression
@safe unittest {
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(5));
    auto gt = new GreaterThanExpression(left, right);
    
    auto context = new Context();
    auto result = gt.interpret(context);
    assert(result.get!bool == true);
    assert(gt.getOperator() == ">");
}

// Test 21: Less than expression
@safe unittest {
    auto left = new LiteralExpression(Variant(3));
    auto right = new LiteralExpression(Variant(7));
    auto lt = new LessThanExpression(left, right);
    
    auto context = new Context();
    auto result = lt.interpret(context);
    assert(result.get!bool == true);
    assert(lt.getOperator() == "<");
}

// Test 22: Expression tree navigation
@safe unittest {
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(20));
    auto add = new AddExpression(left, right);
    
    auto children = add.getChildren();
    assert(children.length == 2);
    assert(add.getLeft() !is null);
    assert(add.getRight() !is null);
}

// Test 23: Unary expression navigation
@safe unittest {
    auto operand = new LiteralExpression(Variant(true));
    auto notExpr = new NotExpression(operand);
    
    auto children = notExpr.getChildren();
    assert(children.length == 1);
    assert(notExpr.getOperand() !is null);
}

// Test 24: Context clear
@safe unittest {
    auto context = new Context();
    context.setVariable("a", Variant(1));
    context.setVariable("b", Variant(2));
    
    assert(context.getVariableNames().length == 2);
    
    context.clear();
    assert(context.getVariableNames().length == 0);
}

// Test 25: Roman numeral - single digits
@trusted unittest {
    auto interpreter = new RomanNumeralInterpreter();
    assert(interpreter.interpret("I") == 1);
    assert(interpreter.interpret("V") == 5);
    assert(interpreter.interpret("X") == 10);
    assert(interpreter.interpret("L") == 50);
    assert(interpreter.interpret("C") == 100);
    assert(interpreter.interpret("D") == 500);
    assert(interpreter.interpret("M") == 1000);
}

// Test 26: Roman numeral - additive
@trusted unittest {
    auto interpreter = new RomanNumeralInterpreter();
    assert(interpreter.interpret("II") == 2);
    assert(interpreter.interpret("III") == 3);
    assert(interpreter.interpret("VI") == 6);
    assert(interpreter.interpret("VII") == 7);
    assert(interpreter.interpret("VIII") == 8);
}

// Test 27: Roman numeral - subtractive
@trusted unittest {
    auto interpreter = new RomanNumeralInterpreter();
    assert(interpreter.interpret("IV") == 4);
    assert(interpreter.interpret("IX") == 9);
    assert(interpreter.interpret("XL") == 40);
    assert(interpreter.interpret("XC") == 90);
    assert(interpreter.interpret("CD") == 400);
    assert(interpreter.interpret("CM") == 900);
}

// Test 28: Roman numeral - complex
@trusted unittest {
    auto interpreter = new RomanNumeralInterpreter();
    assert(interpreter.interpret("XLII") == 42);
    assert(interpreter.interpret("XCIX") == 99);
    assert(interpreter.interpret("CDXLIV") == 444);
    assert(interpreter.interpret("MCMXCIV") == 1994);
    assert(interpreter.interpret("MMXXVI") == 2026);
}

// Test 29: Query context - table operations
@safe unittest {
    auto context = new QueryContext();
    context.addTable("users", ["id=1,name=Alice", "id=2,name=Bob"]);
    
    assert(context.hasTable("users"));
    assert(!context.hasTable("products"));
    
    auto rows = context.getTable("users");
    assert(rows.length == 2);
}

// Test 30: SELECT query - all rows
@trusted unittest {
    auto context = new QueryContext();
    context.addTable("users", ["id=1,name=Alice", "id=2,name=Bob", "id=3,name=Charlie"]);
    
    auto select = new SelectExpression("users");
    auto result = select.interpret(context);
    assert(result.length == 3);
}

// Test 31: SELECT query - with condition
@trusted unittest {
    auto context = new QueryContext();
    context.addTable("users", ["id=1,name=Alice", "id=2,name=Bob", "id=3,name=Alice"]);
    
    auto select = new SelectExpression("users", "Alice");
    auto result = select.interpret(context);
    assert(result.length == 2);
}

// Test 32: WHERE clause matching
@safe unittest {
    auto where = new WhereExpression("name", "=", "Alice");
    assert(where.matches("id=1,name=Alice"));
    assert(!where.matches("id=2,name=Bob"));
}

// Test 33: Regex context - basic navigation
@safe unittest {
    auto context = new RegexContext("hello");
    assert(context.hasMore());
    assert(context.current() == 'h');
    assert(context.getPosition() == 0);
    
    context.setPosition(1);
    assert(context.current() == 'e');
}

// Test 34: Literal pattern matching
@safe unittest {
    auto pattern = new LiteralPattern('a');
    auto context = new RegexContext("abc");
    
    assert(pattern.matches(context));
    assert(context.getPosition() == 1);
}

// Test 35: Wildcard pattern matching
@safe unittest {
    auto pattern = new WildcardPattern();
    auto context = new RegexContext("xyz");
    
    assert(pattern.matches(context));
    assert(context.getPosition() == 1);
}

// Test 36: Expression toString for debugging
@safe unittest {
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(20));
    auto add = new AddExpression(left, right);
    
    auto str = add.toString();
    assert(str.length > 0);
    assert(str.indexOf("+") >= 0);
}

// Test 37: Variable not found error
@safe unittest {
    auto context = new Context();
    auto variable = new VariableExpression("unknown");
    
    bool caught = false;
    try {
        variable.interpret(context);
    } catch (Exception e) {
        caught = true;
    }
    assert(caught);
}

// Test 38: Division by zero error
@safe unittest {
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(0));
    auto div = new DivideExpression(left, right);
    
    auto context = new Context();
    bool caught = false;
    try {
        div.interpret(context);
    } catch (Exception e) {
        caught = true;
    }
    assert(caught);
}

// Test 39: Complex expression tree
@safe unittest {
    // ((10 + 5) * 2) - (8 / 4)
    auto ten = new LiteralExpression(Variant(10));
    auto five = new LiteralExpression(Variant(5));
    auto two = new LiteralExpression(Variant(2));
    auto eight = new LiteralExpression(Variant(8));
    auto four = new LiteralExpression(Variant(4));
    
    auto add = new AddExpression(ten, five);
    auto mul = new MultiplyExpression(add, two);
    auto div = new DivideExpression(eight, four);
    auto sub = new SubtractExpression(mul, div);
    
    auto context = new Context();
    auto result = sub.interpret(context);
    assert(result.get!int == 28);
}

// Test 40: Expression with all variable types
@safe unittest {
    auto context = new Context();
    context.setVariable("intVal", Variant(100));
    context.setVariable("doubleVal", Variant(3.14));
    context.setVariable("boolVal", Variant(true));
    context.setVariable("stringVal", Variant("test"));
    
    assert(context.getVariable("intVal").get!int == 100);
    assert(context.getVariable("boolVal").get!bool == true);
}
