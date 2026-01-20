/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.interpreters.interpreter;

import uim.oop.patterns.interpreters.interfaces;
import std.variant;
import std.conv;
import std.algorithm;
import std.array;
import std.string;
import std.exception;

/**
 * Context implementation that stores variables.
 */
class Context : IContext {
    private Variant[string] _variables;
    
    @trusted void setVariable(string name, Variant value) {
        _variables[name] = value;
    }
    
    @trusted Variant getVariable(string name) const {
        if (name in _variables) {
            return _variables[name];
        }
        throw new Exception("Variable not found: " ~ name);
    }
    
    @safe bool hasVariable(string name) const {
        return (name in _variables) !is null;
    }
    
    @safe void clear() {
        _variables.clear();
    }
    
    @safe string[] getVariableNames() const {
        return _variables.keys.dup;
    }
}

/**
 * Abstract base expression.
 */
abstract class Expression : IExpression {
    abstract Variant interpret(IContext context);
    abstract override @safe string toString() const;
}

/**
 * Literal expression represents a constant value.
 */
class LiteralExpression : Expression, ILiteralExpression {
    private Variant _value;
    
    this(Variant value) @trusted {
        _value = value;
    }
    
    override @trusted Variant interpret(IContext context) {
        return _value;
    }
    
    @trusted Variant getValue() const {
        return _value;
    }
    
    override @trusted string toString() const {
        if (_value.type == typeid(int)) {
            return to!string(_value.get!int);
        } else if (_value.type == typeid(double)) {
            return to!string(_value.get!double);
        } else if (_value.type == typeid(bool)) {
            return _value.get!bool ? "true" : "false";
        } else if (_value.type == typeid(string)) {
            return "\"" ~ _value.get!string ~ "\"";
        }
        return "";
    }
}

/**
 * Variable expression represents a variable reference.
 */
class VariableExpression : Expression, IVariableExpression {
    private string _name;
    
    this(string name) @safe {
        _name = name;
    }
    
    override @trusted Variant interpret(IContext context) {
        return context.getVariable(_name);
    }
    
    @safe string getName() const {
        return _name;
    }
    
    @trusted Variant getValue() const {
        return Variant(_name);
    }
    
    override @safe string toString() const {
        return _name;
    }
}

/**
 * Abstract binary expression.
 */
abstract class BinaryExpression : Expression, IBinaryExpression {
    protected IExpression _left;
    protected IExpression _right;
    protected string _operator;
    
    this(IExpression left, IExpression right, string operator) @safe {
        _left = left;
        _right = right;
        _operator = operator;
    }
    
    @trusted IExpression getLeft() const {
        return cast(IExpression)_left;
    }
    
    @trusted IExpression getRight() const {
        return cast(IExpression)_right;
    }
    
    @safe string getOperator() const {
        return _operator;
    }
    
    @trusted IExpression[] getChildren() const {
        return [cast(IExpression)_left, cast(IExpression)_right];
    }
    
    override @safe string toString() const {
        return "(" ~ _left.toString() ~ " " ~ _operator ~ " " ~ _right.toString() ~ ")";
    }
}

// Arithmetic Expressions

/**
 * Addition expression.
 */
class AddExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "+");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            return Variant(leftVal.get!int + rightVal.get!int);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            return Variant(left + right);
        }
        throw new Exception("Invalid types for addition");
    }
}

/**
 * Subtraction expression.
 */
class SubtractExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "-");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            return Variant(leftVal.get!int - rightVal.get!int);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            return Variant(left - right);
        }
        throw new Exception("Invalid types for subtraction");
    }
}

/**
 * Multiplication expression.
 */
class MultiplyExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "*");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            return Variant(leftVal.get!int * rightVal.get!int);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            return Variant(left * right);
        }
        throw new Exception("Invalid types for multiplication");
    }
}

/**
 * Division expression.
 */
class DivideExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "/");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            auto divisor = rightVal.get!int;
            if (divisor == 0) throw new Exception("Division by zero");
            return Variant(leftVal.get!int / divisor);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            if (right == 0.0) throw new Exception("Division by zero");
            return Variant(left / right);
        }
        throw new Exception("Invalid types for division");
    }
}

// Boolean Logic Expressions

/**
 * AND expression.
 */
class AndExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "AND");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(bool) && rightVal.type == typeid(bool)) {
            return Variant(leftVal.get!bool && rightVal.get!bool);
        }
        throw new Exception("Invalid types for AND operation");
    }
}

/**
 * OR expression.
 */
class OrExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "OR");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(bool) && rightVal.type == typeid(bool)) {
            return Variant(leftVal.get!bool || rightVal.get!bool);
        }
        throw new Exception("Invalid types for OR operation");
    }
}

/**
 * Abstract unary expression.
 */
abstract class UnaryExpression : Expression, IUnaryExpression {
    protected IExpression _operand;
    protected string _operator;
    
    this(IExpression operand, string operator) @safe {
        _operand = operand;
        _operator = operator;
    }
    
    @trusted IExpression getOperand() const {
        return cast(IExpression)_operand;
    }
    
    @safe string getOperator() const {
        return _operator;
    }
    
    @trusted IExpression[] getChildren() const {
        return [cast(IExpression)_operand];
    }
    
    override @safe string toString() const {
        return _operator ~ "(" ~ _operand.toString() ~ ")";
    }
}

/**
 * NOT expression.
 */
class NotExpression : UnaryExpression {
    this(IExpression operand) @safe {
        super(operand, "NOT");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto value = _operand.interpret(context);
        
        if (value.type == typeid(bool)) {
            return Variant(!value.get!bool);
        }
        throw new Exception("Invalid type for NOT operation");
    }
}

/**
 * Negation expression.
 */
class NegateExpression : UnaryExpression {
    this(IExpression operand) @safe {
        super(operand, "-");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto value = _operand.interpret(context);
        
        if (value.type == typeid(int)) {
            return Variant(-value.get!int);
        } else if (value.type == typeid(double)) {
            return Variant(-value.get!double);
        }
        throw new Exception("Invalid type for negation");
    }
}

// Comparison Expressions

/**
 * Equals expression.
 */
class EqualsExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "==");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == rightVal.type) {
            if (leftVal.type == typeid(int)) {
                return Variant(leftVal.get!int == rightVal.get!int);
            } else if (leftVal.type == typeid(double)) {
                return Variant(leftVal.get!double == rightVal.get!double);
            } else if (leftVal.type == typeid(bool)) {
                return Variant(leftVal.get!bool == rightVal.get!bool);
            } else if (leftVal.type == typeid(string)) {
                return Variant(leftVal.get!string == rightVal.get!string);
            }
        }
        return Variant(false);
    }
}

/**
 * Greater than expression.
 */
class GreaterThanExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, ">");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            return Variant(leftVal.get!int > rightVal.get!int);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            return Variant(left > right);
        }
        throw new Exception("Invalid types for comparison");
    }
}

/**
 * Less than expression.
 */
class LessThanExpression : BinaryExpression {
    this(IExpression left, IExpression right) @safe {
        super(left, right, "<");
    }
    
    override @trusted Variant interpret(IContext context) {
        auto leftVal = _left.interpret(context);
        auto rightVal = _right.interpret(context);
        
        if (leftVal.type == typeid(int) && rightVal.type == typeid(int)) {
            return Variant(leftVal.get!int < rightVal.get!int);
        } else if (leftVal.type == typeid(double) || rightVal.type == typeid(double)) {
            double left = leftVal.type == typeid(int) ? leftVal.get!int : leftVal.get!double;
            double right = rightVal.type == typeid(int) ? rightVal.get!int : rightVal.get!double;
            return Variant(left < right);
        }
        throw new Exception("Invalid types for comparison");
    }
}

// Real-world example 1: Roman Numeral Interpreter

/**
 * Roman numeral context.
 */
class RomanNumeralContext {
    private string _input;
    private int _output;
    
    this(string input) @safe {
        _input = input;
        _output = 0;
    }
    
    @safe string getInput() {
        return _input;
    }
    
    @safe void setInput(string value) {
        _input = value;
    }
    
    @safe int getOutput() const {
        return _output;
    }
    
    @safe void setOutput(int value) {
        _output = value;
    }
}

/**
 * Roman numeral expression.
 */
class RomanNumeralExpression {
    private string _roman;
    private int _decimal;
    
    this(string roman, int decimal) @safe {
        _roman = roman;
        _decimal = decimal;
    }
    
    @trusted void interpret(RomanNumeralContext context) {
        while (context.getInput().startsWith(_roman)) {
            context.setOutput(context.getOutput() + _decimal);
            context.setInput(context.getInput()[_roman.length..$]);
        }
    }
}

/**
 * Roman numeral interpreter.
 */
class RomanNumeralInterpreter {
    private RomanNumeralExpression[] _expressions;
    
    this() @safe {
        _expressions = [
            new RomanNumeralExpression("M", 1000),
            new RomanNumeralExpression("CM", 900),
            new RomanNumeralExpression("D", 500),
            new RomanNumeralExpression("CD", 400),
            new RomanNumeralExpression("C", 100),
            new RomanNumeralExpression("XC", 90),
            new RomanNumeralExpression("L", 50),
            new RomanNumeralExpression("XL", 40),
            new RomanNumeralExpression("X", 10),
            new RomanNumeralExpression("IX", 9),
            new RomanNumeralExpression("V", 5),
            new RomanNumeralExpression("IV", 4),
            new RomanNumeralExpression("I", 1)
        ];
    }
    
    @trusted int interpret(string roman) {
        auto context = new RomanNumeralContext(roman);
        foreach (expr; _expressions) {
            expr.interpret(context);
        }
        return context.getOutput();
    }
}

// Real-world example 2: SQL-like Query Interpreter

/**
 * Query context for SQL-like queries.
 */
class QueryContext {
    private string[][string] _tables;
    
    @safe void addTable(string name, string[] rows) {
        _tables[name] = rows;
    }
    
    @safe string[] getTable(string name) {
        if (name in _tables) {
            return _tables[name];
        }
        return [];
    }
    
    @safe bool hasTable(string name) const {
        return (name in _tables) !is null;
    }
}

/**
 * SELECT query expression.
 */
class SelectExpression {
    private string _tableName;
    private string _condition;
    
    this(string tableName, string condition = "") @safe {
        _tableName = tableName;
        _condition = condition;
    }
    
    @trusted string[] interpret(QueryContext context) {
        auto rows = context.getTable(_tableName);
        if (_condition == "") {
            return rows;
        }
        
        // Simple filtering: rows containing the condition string
        string[] result;
        foreach (row; rows) {
            if (row.indexOf(_condition) >= 0) {
                result ~= row;
            }
        }
        return result;
    }
}

/**
 * WHERE clause expression.
 */
class WhereExpression {
    private string _field;
    private string _operator;
    private string _value;
    
    this(string field, string operator, string value) @safe {
        _field = field;
        _operator = operator;
        _value = value;
    }
    
    @safe bool matches(string row) {
        // Simple matching: check if row contains field=value
        auto pattern = _field ~ "=" ~ _value;
        return row.indexOf(pattern) >= 0;
    }
}

// Real-world example 3: Regular Expression Interpreter (simplified)

/**
 * Regex pattern context.
 */
class RegexContext {
    private string _input;
    private size_t _position;
    
    this(string input) @safe {
        _input = input;
        _position = 0;
    }
    
    @safe string getInput() const {
        return _input;
    }
    
    @safe size_t getPosition() const {
        return _position;
    }
    
    @safe void setPosition(size_t pos) {
        _position = pos;
    }
    
    @safe bool hasMore() const {
        return _position < _input.length;
    }
    
    @safe char current() const {
        if (_position < _input.length) {
            return _input[_position];
        }
        return '\0';
    }
}

/**
 * Literal character pattern.
 */
class LiteralPattern {
    private char _char;
    
    this(char c) @safe {
        _char = c;
    }
    
    @safe bool matches(RegexContext context) {
        if (context.hasMore() && context.current() == _char) {
            context.setPosition(context.getPosition() + 1);
            return true;
        }
        return false;
    }
}

/**
 * Wildcard pattern (matches any character).
 */
class WildcardPattern {
    @safe bool matches(RegexContext context) {
        if (context.hasMore()) {
            context.setPosition(context.getPosition() + 1);
            return true;
        }
        return false;
    }
}

// Embedded unit tests

/* 
@safe unittest {
    // Test literal expression
    auto literal = new LiteralExpression(Variant(42));
    auto context = new Context();
    auto result = literal.interpret(context);
    assert(result.get!int == 42);
}

@safe unittest {
    // Test variable expression
    auto variable = new VariableExpression("x");
    auto context = new Context();
    context.setVariable("x", Variant(100));
    auto result = variable.interpret(context);
    assert(result.get!int == 100);
}

@safe unittest {
    // Test addition
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(5));
    auto add = new AddExpression(left, right);
    auto context = new Context();
    auto result = add.interpret(context);
    assert(result.get!int == 15);
}

@safe unittest {
    // Test subtraction
    auto left = new LiteralExpression(Variant(10));
    auto right = new LiteralExpression(Variant(3));
    auto sub = new SubtractExpression(left, right);
    auto context = new Context();
    auto result = sub.interpret(context);
    assert(result.get!int == 7);
}

@safe unittest {
    // Test multiplication
    auto left = new LiteralExpression(Variant(6));
    auto right = new LiteralExpression(Variant(7));
    auto mul = new MultiplyExpression(left, right);
    auto context = new Context();
    auto result = mul.interpret(context);
    assert(result.get!int == 42);
}

@safe unittest {
    // Test division
    auto left = new LiteralExpression(Variant(20));
    auto right = new LiteralExpression(Variant(4));
    auto div = new DivideExpression(left, right);
    auto context = new Context();
    auto result = div.interpret(context);
    assert(result.get!int == 5);
}

@safe unittest {
    // Test complex arithmetic expression: (10 + 5) * 2
    auto ten = new LiteralExpression(Variant(10));
    auto five = new LiteralExpression(Variant(5));
    auto two = new LiteralExpression(Variant(2));
    auto add = new AddExpression(ten, five);
    auto mul = new MultiplyExpression(add, two);
    auto context = new Context();
    auto result = mul.interpret(context);
    assert(result.get!int == 30);
}

@safe unittest {
    // Test AND expression
    auto trueExpr = new LiteralExpression(Variant(true));
    auto falseExpr = new LiteralExpression(Variant(false));
    auto andExpr = new AndExpression(trueExpr, falseExpr);
    auto context = new Context();
    auto result = andExpr.interpret(context);
    assert(result.get!bool == false);
}

@safe unittest {
    // Test OR expression
    auto trueExpr = new LiteralExpression(Variant(true));
    auto falseExpr = new LiteralExpression(Variant(false));
    auto orExpr = new OrExpression(trueExpr, falseExpr);
    auto context = new Context();
    auto result = orExpr.interpret(context);
    assert(result.get!bool == true);
}

@safe unittest {
    // Test NOT expression
    auto trueExpr = new LiteralExpression(Variant(true));
    auto notExpr = new NotExpression(trueExpr);
    auto context = new Context();
    auto result = notExpr.interpret(context);
    assert(result.get!bool == false);
}

@trusted unittest {
    // Test Roman numeral interpreter
    auto interpreter = new RomanNumeralInterpreter();
    assert(interpreter.interpret("III") == 3);
    assert(interpreter.interpret("IV") == 4);
    assert(interpreter.interpret("IX") == 9);
    assert(interpreter.interpret("XLII") == 42);
    assert(interpreter.interpret("MCMXCIV") == 1994);
}
*/ 