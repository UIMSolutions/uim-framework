/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.strategies.strategy;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base strategy implementation using a delegate.
 */
class Strategy : IStrategy {
  private string delegate() @safe _executeDelegate;

  /**
   * Create a strategy with an execution delegate.
   * Params:
   *   executeFunc = The function to execute
   */
  this(string delegate() @safe executeFunc) {
    _executeDelegate = executeFunc;
  }

  /**
   * Execute the strategy algorithm.
   * Returns: Result of the strategy execution
   */
  string execute() {
    if (_executeDelegate) {
      return _executeDelegate();
    }
    return "";
  }
}

/**
 * Generic strategy implementation.
 */
class GenericStrategy(TInput, TOutput) : IGenericStrategy!(TInput, TOutput) {
  private TOutput delegate(TInput) @safe _executeDelegate;

  /**
   * Create a generic strategy.
   * Params:
   *   executeFunc = The function to execute
   */
  this(TOutput delegate(TInput) @safe executeFunc) {
    _executeDelegate = executeFunc;
  }

  /**
   * Execute the strategy with input data.
   * Params:
   *   input = The input data
   * Returns: The result
   */
  TOutput execute(TInput input) {
    return _executeDelegate(input);
  }
}

/**
 * Sort strategy base class.
 */
abstract class SortStrategy(T) : ISortStrategy!T {
  /**
   * Sort an array using the strategy's algorithm.
   * Params:
   *   data = The array to sort
   * Returns: The sorted array
   */
  abstract T[] sort(T[] data);
}

/**
 * Bubble sort strategy.
 */
class BubbleSortStrategy(T) : SortStrategy!T {
  override T[] sort(T[] data) {
    import std.algorithm : swap;
    
    auto result = data.dup;
    bool swapped;
    
    do {
      swapped = false;
      for (size_t i = 1; i < result.length; i++) {
        if (result[i - 1] > result[i]) {
          swap(result[i - 1], result[i]);
          swapped = true;
        }
      }
    } while (swapped);
    
    return result;
  }
}

/**
 * Quick sort strategy.
 */
class QuickSortStrategy(T) : SortStrategy!T {
  override T[] sort(T[] data) {
    import std.algorithm : sort;
    
    auto result = data.dup;
    result.sort();
    return result;
  }
}

/**
 * Validation strategy base class.
 */
abstract class ValidationStrategy(T) : IValidationStrategy!T {
  protected string _errorMessage;

  /**
   * Get validation error message.
   * Returns: Error message if validation failed
   */
  string errorMessage() {
    return _errorMessage;
  }

  /**
   * Validate data using the strategy's rules.
   * Params:
   *   data = The data to validate
   * Returns: true if valid, false otherwise
   */
  abstract bool validate(T data);
}

/**
 * String length validation strategy.
 */
class LengthValidationStrategy : ValidationStrategy!string {
  private size_t _minLength;
  private size_t _maxLength;

  /**
   * Create a length validation strategy.
   * Params:
   *   minLength = Minimum allowed length
   *   maxLength = Maximum allowed length
   */
  this(size_t minLength, size_t maxLength) {
    _minLength = minLength;
    _maxLength = maxLength;
  }

  override bool validate(string data) {
    if (data.length < _minLength) {
      _errorMessage = "String too short";
      return false;
    }
    if (data.length > _maxLength) {
      _errorMessage = "String too long";
      return false;
    }
    return true;
  }
}

/**
 * Numeric range validation strategy.
 */
class RangeValidationStrategy(T) : ValidationStrategy!T {
  private T _min;
  private T _max;

  /**
   * Create a range validation strategy.
   * Params:
   *   min = Minimum allowed value
   *   max = Maximum allowed value
   */
  this(T min, T max) {
    _min = min;
    _max = max;
  }

  override bool validate(T data) {
    if (data < _min) {
      import std.conv : to;
      _errorMessage = "Value below minimum: " ~ _min.to!string;
      return false;
    }
    if (data > _max) {
      import std.conv : to;
      _errorMessage = "Value above maximum: " ~ _max.to!string;
      return false;
    }
    return true;
  }
}

/**
 * Helper function to create a strategy.
 */
Strategy createStrategy(string delegate() @safe executeFunc) {
  return new Strategy(executeFunc);
}

/**
 * Helper function to create a generic strategy.
 */
GenericStrategy!(TInput, TOutput) createGenericStrategy(TInput, TOutput)(
    TOutput delegate(TInput) @safe executeFunc) {
  return new GenericStrategy!(TInput, TOutput)(executeFunc);
}

// Unit tests
unittest {
  auto strategy = createStrategy(() => "Hello");
  assert(strategy.execute() == "Hello");
}

unittest {
  auto strategy = createGenericStrategy!int((int x) => x * 2);
  assert(strategy.execute(5) == 10);
  assert(strategy.execute(21) == 42);
}

unittest {
  auto bubbleSort = new BubbleSortStrategy!int();
  auto data = [3, 1, 4, 1, 5, 9, 2, 6];
  auto sorted = bubbleSort.sort(data);
  assert(sorted == [1, 1, 2, 3, 4, 5, 6, 9]);
}

unittest {
  auto quickSort = new QuickSortStrategy!int();
  auto data = [3, 1, 4, 1, 5, 9, 2, 6];
  auto sorted = quickSort.sort(data);
  assert(sorted == [1, 1, 2, 3, 4, 5, 6, 9]);
}

unittest {
  auto validator = new LengthValidationStrategy(3, 10);
  
  assert(validator.validate("hello"));
  assert(!validator.validate("hi"));
  assert(validator.errorMessage() == "String too short");
  assert(!validator.validate("this is too long"));
  assert(validator.errorMessage() == "String too long");
}

unittest {
  auto validator = new RangeValidationStrategy!int(0, 100);
  
  assert(validator.validate(50));
  assert(!validator.validate(-1));
  assert(!validator.validate(101));
}
