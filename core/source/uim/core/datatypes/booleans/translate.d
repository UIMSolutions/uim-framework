module uim.core.datatypes.booleans.translate;

import uim.core;

mixin(ShowModule!());

@safe:

/// Translates boolean to defined values
pure T translateTo(T)(bool value, T trueValue, T falseValue) {
  return (value) ? trueValue : falseValue;
}

unittest {
  mixin(ShowTest!"Testing translateTo function");

  assert(translateTo(true, "Yes", "No") == "Yes");
  assert(translateTo(false, "Yes", "No") == "No");

  assert(translateTo(true, 1, 0) == 1);
  assert(translateTo(false, 1, 0) == 0);

  assert(translateTo(true, 3.14, 0.0) == 3.14);
  assert(translateTo(false, 3.14, 0.0) == 0.0);
}
