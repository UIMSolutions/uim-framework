/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.every;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Iterates over each key-value pair in an associative array, applying the provided delegate function.
  *
  * Params:
  *   items = The associative array to iterate over.
  *   func = A delegate function that takes a key and a value as its parameters.
  */
void every(K, V)(V[K] items, void delegate(K key, V value) @safe func) {
  items.byKeyValue.each!(kv => func(kv.key, kv.value));
}
///
unittest {
  // Test with built-in associative array and key-value delegate
  int[string] items;
  items["a"] = 1;
  items["b"] = 2;
  items["c"] = 3;

  string keys;
  int valuesSum = 0;
  every(items, (string key, int value) @safe {
    keys ~= key ~ ",";
    valuesSum += value;
  });
  assert(keys == "a,b,c," || keys == "b,a,c," || keys == "c,a,b," || keys == "a,c,b," || keys == "b,c,a," || keys == "c,b,a,"); // order not guaranteed
  assert(valuesSum == 6);

  // Test with empty associative array and key-value delegate
  int[string] emptyItems;
  int callCount = 0;
  every(emptyItems, (string key, int value) @safe { callCount++; });
  assert(callCount == 0);

  // Test with different value type and key-value delegate
  string[int] items2;
  items2[1] = "one";
  items2[2] = "two";
  items2[3] = "three";

  string kvResult;
  items2.every((int key, string value) @safe {
    kvResult ~= to!string(key) ~ ":" ~ value ~ ",";
  });
  assert(kvResult.countUntil("one") != -1 && kvResult.countUntil("two") != -1 && kvResult.countUntil(
      "three") != -1);

  // Test with custom delegate capturing keys and values
  int[string] items3 = ["x": 10, "y": 20];
  string[] keysArr;
  int[] valuesArr;
  every(items3, (string key, int value) @safe {
    keysArr ~= key;
    valuesArr ~= value;
  });
  assert(keysArr.length == 2 && (keysArr == ["x", "y"] || keysArr == ["y", "x"]));
  assert(valuesArr == [10, 20] || valuesArr == [20, 10]); // order not guaranteed
}

/**
  * Iterates over each value in an associative array, applying the provided delegate function.
  *
  * Params:
  *   items = The associative array to iterate over.
  *   func = A delegate function that takes a single value as its parameter.
  */
void every(K, V)(V[K] items, void delegate(V value) @safe func) {
  V[] values = items.byValue.array;
  values.each!(value => func(value));
}
///
unittest {
  // Test with built-in associative array
  int[string] items;
  items["a"] = 1;
  items["b"] = 2;
  items["c"] = 3;

  int sum = 0;
  every(items, (int value) @safe { sum += value; });
  assert(sum == 6);

  // Test with empty associative array
  int[string] emptyItems;
  int count = 0;
  emptyItems.every((int value) @safe { count++; });
  assert(count == 0);

  // Test with custom delegate capturing values
  int[string] items3 = ["x": 10, "y": 20];
  int[] values;
  items3.every((int value) @safe { values ~= value; });
  assert(values == [10, 20] || values == [20, 10]); // order not guaranteed
}

/** 
  * Iterates over each key in an associative array, applying the provided delegate function.
  *
  * Params:
  *   items = The associative array to iterate over.
  *   func = A delegate function that takes a single key as its parameter.
  */
void everyKey(K, V)(V[K] items, void delegate(K) @safe func) {
  items.byKey.each!(k => func(k));
}
///
unittest {
  // Test everyKey with int[string] associative array
  int[string] items;
  items["a"] = 1;
  items["b"] = 2;
  items["c"] = 3;

  string keys;
  everyKey(items, (string key) @safe { keys ~= key ~ ","; });
  assert(keys == "a,b,c," || keys == "b,a,c," || keys == "c,a,b," || keys == "a,c,b," || keys == "b,c,a," || keys == "c,b,a,");

  // Test everyKey with empty associative array
  int[string] emptyItems;
  int callCount = 0;
  everyKey(emptyItems, (string key) @safe { callCount++; });
  assert(callCount == 0);

  // Test everyKey with string[int] associative array
  string[int] items2;
  items2[1] = "one";
  items2[2] = "two";
  items2[3] = "three";

  int[] keysArr;
  everyKey(items2, (int key) @safe { keysArr ~= key; });
  assert(keysArr.length == 3);
  assert(keysArr.sort.array == [1, 2, 3]);
}

/**
  * Iterates over each value in an associative array, applying the provided delegate function.
  *
  * Params:
  *   items = The associative array to iterate over.
  *   func = A delegate function that takes a single value as its parameter.
  */
void everyValue(K, V)(V[K] items, void delegate(V value) @safe func) {
  items.byValue.each!(v => func(v));
}
///
unittest {
  // Test with int[string] associative array
  int[string] items;
  items["a"] = 1;
  items["b"] = 2;
  items["c"] = 3;

  int sum = 0;
  items.everyValue((int value) @safe { sum += value; });
  assert(sum == 6);

  // Test with empty associative array
  int[string] emptyItems;
  int count = 0;
  everyValue(emptyItems, (int value) @safe { count++; });
  assert(count == 0);

  // Test with string[int] associative array
  string[int] items2;
  items2[1] = "one";
  items2[2] = "two";
  items2[3] = "three";

  string result;
  items2.everyValue((string value) @safe { result ~= value ~ ","; });
  assert(result.countUntil("one") != -1 && result.countUntil("two") != -1 && result.countUntil(
      "three") != -1);

  // Test with custom delegate capturing values into array
  int[string] items3 = ["x": 10, "y": 20];
  int[] values;
  items3.everyValue((int value) @safe { values ~= value; });
  assert(values.length == 2);
  assert(values.sort.array == [10, 20]);
}
