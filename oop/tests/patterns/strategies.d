/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.strategies;

import uim.oop;
import std.stdio;

@safe:

// Test basic strategy pattern
unittest {
  class AddStrategy : IStrategy {
    string execute() {
      return "Addition";
    }
  }

  class MultiplyStrategy : IStrategy {
    string execute() {
      return "Multiplication";
    }
  }

  auto addStrat = new AddStrategy();
  auto multStrat = new MultiplyStrategy();

  assert(addStrat.execute() == "Addition", "Add strategy should work");
  assert(multStrat.execute() == "Multiplication", "Multiply strategy should work");
}

// Test strategy context
unittest {
  auto strategy1 = createStrategy(() => "Strategy 1");
  auto strategy2 = createStrategy(() => "Strategy 2");

  auto context = new Context!Strategy(strategy1);
  assert(context.executeStrategy() == "Strategy 1", "Should use first strategy");

  context.strategy(strategy2);
  assert(context.executeStrategy() == "Strategy 2", "Should switch to second strategy");
}

// Test generic strategy
unittest {
  auto doubleStrategy = createGenericStrategy!int((int x) => x * 2);
  auto tripleStrategy = createGenericStrategy!int((int x) => x * 3);

  assert(doubleStrategy.execute(5) == 10, "Double strategy should work");
  assert(tripleStrategy.execute(5) == 15, "Triple strategy should work");
}

// Test sorting strategies
unittest {
  auto data = [5, 2, 8, 1, 9, 3];

  auto bubbleSort = new BubbleSortStrategy!int();
  auto bubbleSorted = bubbleSort.sort(data);
  assert(bubbleSorted == [1, 2, 3, 5, 8, 9], "Bubble sort should work");

  auto quickSort = new QuickSortStrategy!int();
  auto quickSorted = quickSort.sort(data);
  assert(quickSorted == [1, 2, 3, 5, 8, 9], "Quick sort should work");
}

// Test sorter context
unittest {
  auto sorter = new Sorter!int(new BubbleSortStrategy!int());
  auto data = [3, 1, 4, 1, 5, 9, 2, 6];

  auto sorted1 = sorter.sort(data);
  assert(sorted1 == [1, 1, 2, 3, 4, 5, 6, 9], "Should sort with bubble sort");

  sorter.strategy(new QuickSortStrategy!int());
  auto sorted2 = sorter.sort(data);
  assert(sorted2 == [1, 1, 2, 3, 4, 5, 6, 9], "Should sort with quick sort");
}

// Test validation strategies
unittest {
  auto lengthValidator = new LengthValidationStrategy(3, 10);

  assert(lengthValidator.validate("hello"), "Valid string should pass");
  assert(!lengthValidator.validate("hi"), "Too short string should fail");
  assert(lengthValidator.errorMessage() == "String too short", "Should have error message");

  assert(!lengthValidator.validate("this string is way too long"), "Too long string should fail");
  assert(lengthValidator.errorMessage() == "String too long", "Should have error message");
}

// Test range validation
unittest {
  auto rangeValidator = new RangeValidationStrategy!int(0, 100);

  assert(rangeValidator.validate(50), "Valid value should pass");
  assert(rangeValidator.validate(0), "Minimum value should pass");
  assert(rangeValidator.validate(100), "Maximum value should pass");

  assert(!rangeValidator.validate(-1), "Below minimum should fail");
  assert(!rangeValidator.validate(101), "Above maximum should fail");
}

// Test validator context
unittest {
  auto validator = new Validator!string(new LengthValidationStrategy(5, 15));

  assert(validator.validate("hello"), "Valid string should pass");
  assert(!validator.validate("hi"), "Invalid string should fail");

  // Switch strategy
  validator.strategy(new LengthValidationStrategy(2, 5));
  assert(validator.validate("hi"), "Should use new strategy");
  assert(!validator.validate("hello"), "Should fail with new limits");
}

// Test multiple strategies composition
unittest {
  class CalculationContext {
    private IGenericStrategy!(int, int) _strategy;

    this(IGenericStrategy!(int, int) strategy) {
      _strategy = strategy;
    }

    void strategy(IGenericStrategy!(int, int) strategy) {
      _strategy = strategy;
    }

    int calculate(int value) {
      return _strategy.execute(value);
    }
  }

  auto addTen = createGenericStrategy!int((int x) => x + 10);
  auto multiplyByTwo = createGenericStrategy!int((int x) => x * 2);
  auto square = createGenericStrategy!int((int x) => x * x);

  auto calculator = new CalculationContext(addTen);
  assert(calculator.calculate(5) == 15, "Add 10 strategy");

  calculator.strategy(multiplyByTwo);
  assert(calculator.calculate(5) == 10, "Multiply by 2 strategy");

  calculator.strategy(square);
  assert(calculator.calculate(5) == 25, "Square strategy");
}

// Test string processing strategies
unittest {
  class StringProcessor {
    private IGenericStrategy!(string, string) _strategy;

    this(IGenericStrategy!(string, string) strategy) {
      _strategy = strategy;
    }

    void strategy(IGenericStrategy!(string, string) strategy) {
      _strategy = strategy;
    }

    string process(string text) {
      return _strategy.execute(text);
    }
  }

  auto uppercase = createGenericStrategy!string((string s) {
    import std.string : toUpper;
    return s.toUpper();
  });

  auto lowercase = createGenericStrategy!string((string s) {
    import std.string : toLower;
    return s.toLower();
  });

  auto reverse = createGenericStrategy!string((string s) {
    import std.range : retro;
    import std.array : array;
    import std.conv : to;
    return s.retro.array.to!string;
  });

  auto processor = new StringProcessor(uppercase);
  assert(processor.process("Hello") == "HELLO", "Uppercase strategy");

  processor.strategy(lowercase);
  assert(processor.process("Hello") == "hello", "Lowercase strategy");

  processor.strategy(reverse);
  assert(processor.process("Hello") == "olleH", "Reverse strategy");
}

// Test strategy with state
unittest {
  class CountingStrategy : IStrategy {
    private int _count;

    string execute() {
      import std.conv : to;
      _count++;
      return "Called " ~ _count.to!string ~ " times";
    }
  }

  auto strategy = new CountingStrategy();
  assert(strategy.execute() == "Called 1 times");
  assert(strategy.execute() == "Called 2 times");
  assert(strategy.execute() == "Called 3 times");
}

// Test nested strategy switching
unittest {
  auto data = [9, 3, 7, 1, 5];

  auto sorter = new Sorter!int(new BubbleSortStrategy!int());
  
  // First sort with bubble sort
  auto result1 = sorter.sort(data);
  assert(result1 == [1, 3, 5, 7, 9], "First sort");

  // Switch to quick sort
  sorter.strategy(new QuickSortStrategy!int());
  auto result2 = sorter.sort(data);
  assert(result2 == [1, 3, 5, 7, 9], "Second sort with different strategy");

  // Verify original data unchanged
  assert(data == [9, 3, 7, 1, 5], "Original data should be unchanged");
}
