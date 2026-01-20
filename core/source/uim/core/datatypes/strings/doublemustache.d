module uim.core.datatypes.strings.doublemustache;


import uim.core;

mixin(ShowModule!());

@safe:

string doubleMustache(string text, Json[string] items, string[] selectedKeys = null) {
  if (selectedKeys.length > 0) {
    selectedKeys.filter!(key => key in items)
      .each!(key => text = text.doubleMustache(key, items[key]));
  } else {
    items.byKeyValue.each!(item => text = text.doubleMustache(item.key, item.value));
  }
  return text;
}

string doubleMustache(string text, string[string] items) {
  items.byKeyValue.each!(item => text = text.doubleMustache(item.key, item.value));
  return text;
}

string doubleMustache(string text, string key, Json value) {
  return std.string.replace(text, "{" ~ key ~ "}", value.toString);
}

string doubleMustache(string text, string key, string value) {
  return std.string.replace(text, "{{" ~ key ~ "}}", value);
}

unittest {
  assert("A:{{a}}, B:{{b}}".doubleMustache(["a": "x", "b": "y"]) == "A:x, B:y");
  assert("A:{{a}}, B:{{b}}".doubleMustache(["a": "a", "b": "b"]) != "A:x, B:y");

  string text = "A:{{a}}, B:{{b}}";
  assert(text.doubleMustache(["a": "x", "b": "y"]) == "A:x, B:y");
  assert(text == "A:{{a}}, B:{{b}}");
}