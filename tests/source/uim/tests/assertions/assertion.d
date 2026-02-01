/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.tests.assertions.assertion;

import uim.tests;

mixin(ShowModule!());

@safe:

/**
 * Assertion helper class
 */
class Assert {
  /**
   * Assert that value is true
   */
  static void assertTrue(bool value, string message = "Expected true") {
    if (!value) {
      throw new AssertionException(message);
    }
  }

  /**
   * Assert that value is false
   */
  static void assertFalse(bool value, string message = "Expected false") {
    if (value) {
      throw new AssertionException(message);
    }
  }

  /**
   * Assert equality
   */
  static void assertEquals(T)(T actual, T expected, string message = "") {
    if (actual != expected) {
      string msg = message.length > 0 ? message : 
        format("Expected %s but got %s", expected.to!string, actual.to!string);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert inequality
   */
  static void assertNotEquals(T)(T actual, T expected, string message = "") {
    if (actual == expected) {
      string msg = message.length > 0 ? message : 
        format("Expected values to not be equal: %s", actual.to!string);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert that object is null
   */
  static void assertNull(T)(T value, string message = "Expected null") {
    if (value !is null) {
      throw new AssertionException(message);
    }
  }

  /**
   * Assert that object is not null
   */
  static void assertNotNull(T)(T value, string message = "Expected non-null") {
    if (value is null) {
      throw new AssertionException(message);
    }
  }

  /**
   * Assert that value is greater than
   */
  static void assertGreaterThan(T)(T actual, T expected, string message = "") {
    if (actual <= expected) {
      string msg = message.length > 0 ? message : 
        format("Expected %s to be greater than %s", actual.to!string, expected.to!string);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert that value is less than
   */
  static void assertLessThan(T)(T actual, T expected, string message = "") {
    if (actual >= expected) {
      string msg = message.length > 0 ? message : 
        format("Expected %s to be less than %s", actual.to!string, expected.to!string);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert string contains substring
   */
  static void assertStringContains(string haystack, string needle, string message = "") {
    import std.string : indexOf;
    if (haystack.indexOf(needle) < 0) {
      string msg = message.length > 0 ? message : 
        format("Expected '%s' to contain '%s'", haystack, needle);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert array contains value
   */
  static void assertArrayContains(T)(T[] array, T value, string message = "") {
    import std.algorithm : canFind;
    if (!array.canFind(value)) {
      string msg = message.length > 0 ? message : 
        format("Expected array to contain %s", value.to!string);
      throw new AssertionException(msg);
    }
  }

  /**
   * Assert that exception is thrown
   */
  static void assertThrows(T : Exception)(void delegate() @safe dg, string message = "") {
    try {
      dg();
      string msg = message.length > 0 ? message : 
        format("Expected %s to be thrown", T.stringof);
      throw new AssertionException(msg);
    } catch (T ex) {
      // Expected
    } catch (Exception ex) {
      string msg = message.length > 0 ? message : 
        format("Expected %s but got %s", T.stringof, typeid(ex).name);
      throw new AssertionException(msg);
    }
  }

  /**
   * Fail test with message
   */
  static void fail(string message) {
    throw new AssertionException(message);
  }
}

