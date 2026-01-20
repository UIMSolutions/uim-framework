/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.tests.asserts;

import uim.core;

mixin(ShowModule!());

@safe:

// assertTrue / assertFalse
void assertTrue(bool condition, string msg = "Expected true") {
  assert(condition, msg);
}

void assertFalse(bool condition, string msg = "Expected false") {
  assert(!condition, msg);
}

// assertNull / assertNotNull (Uses 'is' for reference identity)
void assertNull(T)(T obj, string msg = "Expected null") {
  assert(obj is null, msg);
}

void assertNotNull(T)(T obj, string msg = "Expected not null") {
  assert(obj !is null, msg);
}

// assertEquals / assertNotEquals (Uses '==' for value equality)
void assertEquals(T, U)(T expected, U actual, string msg = "") {
  assert(expected == actual,
    text(msg, " -> Expected: ", expected, ", but was: ", actual));
}

void assertNotEquals(T, U)(T expected, U actual, string msg = "") {
  assert(expected != actual,
    text(msg, " -> Values should not be equal: ", actual));
}

// assertArrayEquals
void assertArrayEquals(T)(T[] expected, T[] actual, string msg = "") {
  assert(expected == actual,
    text(msg, " -> Arrays differ. Expected: ", expected, ", Actual: ", actual));
}

// assertSame / assertNotSame (Memory address identity)
void assertSame(T)(T expected, T actual, string msg = "Objects are not same instance") {
  assert(expected is actual, msg);
}

void assertNotSame(T)(T expected, T actual, string msg = "Objects should be different instances") {
  assert(expected !is actual, msg);
}

// assertThrows (Mimics JUnit 5's executable lambda)
T assertThrows(T : Throwable = Exception, E)(lazy E expression, string msg = "") {
  try {
    return assertThrown!T(expression, msg);
  } catch (AssertError e) {
    throw new AssertError(text("assertThrows failed: ", msg), e.file, e.line);
  }
}
