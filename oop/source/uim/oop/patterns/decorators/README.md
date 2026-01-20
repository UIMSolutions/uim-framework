# Decorator Pattern

The Decorator pattern allows you to attach additional responsibilities to an object dynamically. Decorators provide a flexible alternative to subclassing for extending functionality.

## Features

- **Base Decorator**: Abstract decorator class for creating custom decorators
- **Generic Decorator**: Type-safe decoration with delegate support
- **Functional Decorator**: Apply before/after hooks to component execution
- **Chainable Decorator**: Chain multiple decorators together
- **Component Interface**: Standard interface for all decoratable components

## Basic Usage

### Simple Decorator

```d
import uim.oop;

// Define a base component
class TextComponent : IDecoratorComponent {
    private string _text;
    
    this(string text) { _text = text; }
    
    string execute() {
        return _text;
    }
}

// Create a decorator
class BoldDecorator : Decorator {
    this(IDecoratorComponent component) {
        super(component);
    }
    
    override string execute() {
        return "<b>" ~ super.execute() ~ "</b>";
    }
}

// Use it
auto text = new TextComponent("Hello");
auto bold = new BoldDecorator(text);
writeln(bold.execute()); // Output: <b>Hello</b>
```

### Stacking Decorators

```d
class ItalicDecorator : Decorator {
    this(IDecoratorComponent component) {
        super(component);
    }
    
    override string execute() {
        return "<i>" ~ super.execute() ~ "</i>";
    }
}

auto text = new TextComponent("Hello");
auto bold = new BoldDecorator(text);
auto italic = new ItalicDecorator(bold);

writeln(italic.execute()); // Output: <i><b>Hello</b></i>
```

### Functional Decorator

```d
auto component = new TextComponent("Data");

auto decorated = createFunctionalDecorator(
    component,
    () => "[Start] ",  // Before
    () => " [End]"     // After
);

writeln(decorated.execute()); // Output: [Start] Data [End]
```

### Generic Decorator

```d
class Product {
    string name;
    double price;
    
    this(string n, double p) {
        name = n;
        price = p;
    }
}

auto product = new Product("Laptop", 999.99);

auto decorator = createGenericDecorator(product, (Product p) {
    import std.format : format;
    return format("%s: $%.2f", p.name, p.price);
});

writeln(decorator.execute()); // Output: Laptop: $999.99
```

## Real-World Examples

### Coffee Shop

```d
class Coffee : IDecoratorComponent {
    string execute() { return "Coffee"; }
    double cost() { return 2.0; }
}

class MilkDecorator : Decorator {
    this(IDecoratorComponent component) { super(component); }
    
    override string execute() {
        return super.execute() ~ " + Milk";
    }
    
    double cost() { return 0.5; }
}

auto coffee = new Coffee();
auto coffeeWithMilk = new MilkDecorator(coffee);
// Total cost: $2.50
```

### Logging Decorator

```d
class DataProcessor : IDecoratorComponent {
    string execute() { return "Processing data"; }
}

auto withLogging = createFunctionalDecorator(
    new DataProcessor(),
    () { writeln("[LOG] Starting..."); return ""; },
    () { writeln("[LOG] Completed!"); return ""; }
);

withLogging.execute();
```

## Benefits

1. **Open/Closed Principle**: Add new functionality without modifying existing code
2. **Single Responsibility**: Each decorator handles one specific enhancement
3. **Flexible Composition**: Mix and match decorators as needed
4. **Runtime Configuration**: Add or remove decorations at runtime

## When to Use

- Add responsibilities to individual objects dynamically
- Avoid explosion of subclasses for every combination of features
- Need to add/remove functionality at runtime
- Want transparent wrapping (decorators are interchangeable with components)

## See Also

- [examples/decorator.d](../examples/decorator.d) - Complete working examples
- [tests/patterns/decorators.d](../../tests/patterns/decorators.d) - Unit tests
