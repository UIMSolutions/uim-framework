module uim.core.datatypes.strings.bind;

import uim.core;

mixin(ShowModule!());

@safe:

string bind(string source, string[string] replaceMap, string placeHolder = "{{%s}}") {
  string updatedText = source;
  replaceMap.byKeyValue
    .each!(kv => updatedText = std.string.replace(updatedText, placeHolder.format(kv.key), kv
        .value));

  return updatedText;
}
///
unittest {
  // Test with string[string] replaceMap
  string source = "Hello, {{name}}! Welcome to {{place}}.";
  string[string] replaceMap = ["name": "Alice", "place": "Wonderland"];
  string result = bind(source, replaceMap);
  assert(result == "Hello, Alice! Welcome to Wonderland.");

  // Custom placeholder
  source = "User: [[user]], Role: [[role]]";
  replaceMap = ["user": "Bob", "role": "Admin"];
  result = bind(source, replaceMap, "[[%s]]");
  assert(result == "User: Bob, Role: Admin");

  // No replacements
  source = "Nothing to replace here.";
  replaceMap = null;
  result = bind(source, replaceMap);
  assert(result == "Nothing to replace here.");

  // Multiple occurrences
  source = "{{x}} + {{x}} = {{y}}";
  replaceMap = ["x": "2", "y": "4"];
  result = bind(source, replaceMap);
  assert(result == "2 + 2 = 4");

  // Placeholder not found
  source = "Hello, {{name}}!";
  replaceMap = ["notfound": "Bob"];
  result = bind(source, replaceMap);
  assert(result == "Hello, {{name}}!");
}

string bind(string source, string[] keys, string[] values, string placeHolder = "{{%s}}") {
  auto length = min(keys.length, values.length);
  if (length == 0) {
    return source; // No replacements to make
  }

  string updatedText = source;
  for (size_t i = 0; i < length; i++) {
    updatedText = std.string.replace(updatedText, placeHolder.format(keys[i]), values[i]);
  }

  return updatedText;
}
///
unittest {
  // Basic replacement test
  string source = "Hello, {{name}}! Welcome to {{place}}.";
  string[] keys = ["name", "place"];
  string[] values = ["Alice", "Wonderland"];
  string result = bind(source, keys, values);
  assert(result == "Hello, Alice! Welcome to Wonderland.");

  // Custom placeholder test
  source = "User: [[user]], Role: [[role]]";
  keys = ["user", "role"];
  values = ["Bob", "Admin"];
  result = bind(source, keys, values, "[[%s]]");
  assert(result == "User: Bob, Role: Admin");

  // No replacements
  source = "Nothing to replace here.";
  keys = [];
  values = [];
  result = bind(source, keys, values);
  assert(result == "Nothing to replace here.");

  // Multiple occurrences
  source = "{{x}} + {{x}} = {{y}}";
  keys = ["x", "y"];
  values = ["2", "4"];
  result = bind(source, keys, values);
  assert(result == "2 + 2 = 4");
}
