module uim.tests.assertions.matcher;

import uim.tests;

mixin(ShowModule!());

@safe:
/**
 * Fluent assertion matcher
 */
class AssertionMatcher(T) {
  protected T _actual;
  protected string _message;

  this(T value, string message = "") {
    _actual = value;
    _message = message;
  }

  AssertionMatcher!T equal(T expected) {
    if (_actual != expected) {
      string msg = _message.length > 0 ? _message : 
        format("Expected %s but got %s", expected.to!string, _actual.to!string);
      throw new AssertionException(msg);
    }
    return this;
  }

  AssertionMatcher!T notEqual(T expected) {
    if (_actual == expected) {
      string msg = _message.length > 0 ? _message : 
        format("Expected values to not be equal: %s", _actual.to!string);
      throw new AssertionException(msg);
    }
    return this;
  }

  AssertionMatcher!T isNull() {
    if (_actual !is null) {
      throw new AssertionException(_message.length > 0 ? _message : "Expected null");
    }
    return this;
  }

  AssertionMatcher!T notNull() {
    if (_actual is null) {
      throw new AssertionException(_message.length > 0 ? _message : "Expected non-null");
    }
    return this;
  }
}

/**
 * Create fluent assertion matcher
 */
AssertionMatcher!T expect(T)(T value, string message = "") {
  return new AssertionMatcher!T(value, message);
}
