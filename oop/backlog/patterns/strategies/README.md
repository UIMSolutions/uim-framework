# Strategy Pattern

The Strategy pattern defines a family of algorithms, encapsulates each one, and makes them interchangeable. Strategy lets the algorithm vary independently from clients that use it.

## Features

- **Base Strategy Interface**: Standard contract for all strategies
- **Generic Strategy**: Type-safe strategies with input/output types
- **Context Classes**: Maintain reference to strategies and delegate work
- **Sorting Strategies**: Built-in bubble sort and quick sort
- **Validation Strategies**: Length and range validation
- **Flexible Switching**: Change algorithms at runtime

## Basic Usage

### Simple Strategy

```d
import uim.oop;

// Create strategies
auto strategy1 = createStrategy(() => "Algorithm 1");
auto strategy2 = createStrategy(() => "Algorithm 2");

// Use with context
auto context = new Context!Strategy(strategy1);
writeln(context.executeStrategy()); // "Algorithm 1"

// Switch strategy
context.strategy(strategy2);
writeln(context.executeStrategy()); // "Algorithm 2"
```

### Generic Strategy

```d
// Define strategies with input/output types
auto doubleIt = createGenericStrategy!int((int x) => x * 2);
auto squareIt = createGenericStrategy!int((int x) => x * x);

auto context = new GenericContext!(int, int)(doubleIt);
writeln(context.executeStrategy(5)); // 10

context.strategy(squareIt);
writeln(context.executeStrategy(5)); // 25
```

### Sorting Strategies

```d
auto data = [5, 2, 8, 1, 9, 3];

// Use sorter with different strategies
auto sorter = new Sorter!int(new BubbleSortStrategy!int());
auto sorted1 = sorter.sort(data);

sorter.strategy(new QuickSortStrategy!int());
auto sorted2 = sorter.sort(data);
```

### Custom Strategy Implementation

```d
// Define your own strategy
class AdditionStrategy : IGenericStrategy!(int, int) {
    int execute(int input) {
        return input + 10;
    }
}

class MultiplicationStrategy : IGenericStrategy!(int, int) {
    int execute(int input) {
        return input * 2;
    }
}

// Use them
auto context = new GenericContext!(int, int)(new AdditionStrategy());
writeln(context.executeStrategy(5)); // 15

context.strategy(new MultiplicationStrategy());
writeln(context.executeStrategy(5)); // 10
```

## Real-World Examples

### Payment Processing

```d
interface IPaymentStrategy {
    bool pay(double amount);
    string paymentMethod();
}

class CreditCardStrategy : IPaymentStrategy {
    bool pay(double amount) {
        // Process credit card payment
        return true;
    }
    
    string paymentMethod() { return "Credit Card"; }
}

class PayPalStrategy : IPaymentStrategy {
    bool pay(double amount) {
        // Process PayPal payment
        return true;
    }
    
    string paymentMethod() { return "PayPal"; }
}

class ShoppingCart {
    private IPaymentStrategy _strategy;
    
    void setPaymentStrategy(IPaymentStrategy strategy) {
        _strategy = strategy;
    }
    
    void checkout(double amount) {
        _strategy.pay(amount);
    }
}
```

### Text Formatting

```d
auto uppercase = createGenericStrategy!string((string s) {
    import std.string : toUpper;
    return s.toUpper();
});

auto lowercase = createGenericStrategy!string((string s) {
    import std.string : toLower;
    return s.toLower();
});

auto processor = new GenericContext!(string, string)(uppercase);
writeln(processor.executeStrategy("Hello")); // "HELLO"

processor.strategy(lowercase);
writeln(processor.executeStrategy("Hello")); // "hello"
```

### Validation

```d
// String length validation
auto validator = new Validator!string(
    new LengthValidationStrategy(3, 10)
);

if (validator.validate("hello")) {
    writeln("Valid!");
} else {
    writeln("Error: ", validator.errorMessage());
}

// Numeric range validation
auto rangeValidator = new Validator!int(
    new RangeValidationStrategy!int(0, 100)
);

if (rangeValidator.validate(50)) {
    writeln("Valid!");
}
```

## Benefits

1. **Open/Closed Principle**: Add new strategies without modifying existing code
2. **Runtime Flexibility**: Switch algorithms at runtime based on conditions
3. **Testability**: Each strategy can be tested independently
4. **Maintainability**: Isolates algorithm implementation details
5. **Reusability**: Strategies can be reused across different contexts

## When to Use

- Multiple related classes differ only in behavior
- Need different variants of an algorithm
- Algorithm uses data that clients shouldn't know about
- Class defines many behaviors with multiple conditional statements

## Comparison with Other Patterns

| Pattern | Purpose | Key Difference |
|---------|---------|----------------|
| Strategy | Interchangeable algorithms | Focuses on behavior |
| Decorator | Add responsibilities | Focuses on adding features |
| Template Method | Define algorithm skeleton | Uses inheritance, not composition |
| State | Change behavior based on state | State transitions vs. algorithm selection |

## See Also

- [examples/strategy.d](../examples/strategy.d) - Complete working examples
- [tests/patterns/strategies.d](../../tests/patterns/strategies.d) - Unit tests
