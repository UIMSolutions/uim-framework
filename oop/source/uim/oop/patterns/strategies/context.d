/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.strategies.context;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Context class that uses a strategy.
 * The context maintains a reference to a Strategy object and delegates
 * work to the strategy.
 */
class Context(TStrategy) {
  private TStrategy _strategy;

  /**
   * Create a context with a strategy.
   * Params:
   *   strategy = The strategy to use
   */
  this(TStrategy strategy) {
    _strategy = strategy;
  }

  /**
   * Get the current strategy.
   * Returns: The strategy
   */
  TStrategy strategy() {
    return _strategy;
  }

  /**
   * Set a new strategy.
   * Params:
   *   strategy = The new strategy
   */
  void strategy(TStrategy strategy) {
    _strategy = strategy;
  }

  /**
   * Execute the strategy's algorithm.
   * Returns: Result of the strategy execution
   */
  string executeStrategy() {
    static if (is(TStrategy : IStrategy)) {
      return _strategy.execute();
    } else {
      return "";
    }
  }
}

/**
 * Generic context for strategies with input/output types.
 */
class GenericContext(TInput, TOutput) {
  private IGenericStrategy!(TInput, TOutput) _strategy;

  /**
   * Create a context with a strategy.
   * Params:
   *   strategy = The strategy to use
   */
  this(IGenericStrategy!(TInput, TOutput) strategy) {
    _strategy = strategy;
  }

  /**
   * Get the current strategy.
   * Returns: The strategy
   */
  IGenericStrategy!(TInput, TOutput) strategy() {
    return _strategy;
  }

  /**
   * Set a new strategy.
   * Params:
   *   strategy = The new strategy
   */
  void strategy(IGenericStrategy!(TInput, TOutput) strategy) {
    _strategy = strategy;
  }

  /**
   * Execute the strategy with input.
   * Params:
   *   input = The input data
   * Returns: The result
   */
  TOutput executeStrategy(TInput input) {
    return _strategy.execute(input);
  }
}

/**
 * Sorter context that can switch between sorting strategies.
 */
class Sorter(T) {
  private ISortStrategy!T _strategy;

  /**
   * Create a sorter with a strategy.
   * Params:
   *   strategy = The sorting strategy
   */
  this(ISortStrategy!T strategy) {
    _strategy = strategy;
  }

  /**
   * Set the sorting strategy.
   * Params:
   *   strategy = The new strategy
   */
  void strategy(ISortStrategy!T strategy) {
    _strategy = strategy;
  }

  /**
   * Sort data using the current strategy.
   * Params:
   *   data = The data to sort
   * Returns: Sorted data
   */
  T[] sort(T[] data) {
    return _strategy.sort(data);
  }
}

/**
 * Validator context that can switch between validation strategies.
 */
class Validator(T) {
  private IValidationStrategy!T _strategy;

  /**
   * Create a validator with a strategy.
   * Params:
   *   strategy = The validation strategy
   */
  this(IValidationStrategy!T strategy) {
    _strategy = strategy;
  }

  /**
   * Set the validation strategy.
   * Params:
   *   strategy = The new strategy
   */
  void strategy(IValidationStrategy!T strategy) {
    _strategy = strategy;
  }

  /**
   * Validate data using the current strategy.
   * Params:
   *   data = The data to validate
   * Returns: true if valid
   */
  bool validate(T data) {
    return _strategy.validate(data);
  }

  /**
   * Get validation error message.
   * Returns: Error message
   */
  string errorMessage() {
    return _strategy.errorMessage();
  }
}

// Unit tests
unittest {
  auto strategy = createStrategy(() => "Test");
  auto context = new Context!Strategy(strategy);
  
  assert(context.executeStrategy() == "Test");
  
  auto newStrategy = createStrategy(() => "New");
  context.strategy(newStrategy);
  assert(context.executeStrategy() == "New");
}

unittest {
  auto strategy = createGenericStrategy!int((int x) => x + 1);
  auto context = new GenericContext!(int, int)(strategy);
  
  assert(context.executeStrategy(5) == 6);
  
  auto doubleStrategy = createGenericStrategy!int((int x) => x * 2);
  context.strategy(doubleStrategy);
  assert(context.executeStrategy(5) == 10);
}

unittest {
  auto sorter = new Sorter!int(new BubbleSortStrategy!int());
  auto data = [3, 1, 4, 1, 5];
  
  auto sorted = sorter.sort(data);
  assert(sorted == [1, 1, 3, 4, 5]);
  
  sorter.strategy(new QuickSortStrategy!int());
  sorted = sorter.sort(data);
  assert(sorted == [1, 1, 3, 4, 5]);
}

unittest {
  auto validator = new Validator!string(new LengthValidationStrategy(3, 10));
  
  assert(validator.validate("hello"));
  assert(!validator.validate("hi"));
  assert(validator.errorMessage() == "String too short");
}
