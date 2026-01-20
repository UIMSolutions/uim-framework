module uim.core.datatypes.strings.convert;

import uim.core;

mixin(ShowModule!());

@safe:

string[] toString(T)(T values) if (isArray!T) {
  return values.map!(v => to!string(v)).array;
}
/// 
unittest {
  auto result = [1, 2, 3].toString;
  assert(result.length == 3);
  assert(result[0] == "1");
  assert(result[1] == "2");
  assert(result[2] == "3");
}

/* 
string toString(T)(T value) if (!isArray!T && !is(T == string) && !isObject!T) {
  return to!string(value);
} */ 
///
unittest {
//   auto result = 42.toString;
//   assert(result == "42");
// }
}