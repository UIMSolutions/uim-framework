module uim.core.datatypes.strings.mustache;

import uim.core;

mixin(ShowModule!());

@safe:

string mustache(string text, Json[string] items) {
  items.byKeyValue.each!(item => text = text.mustache(item.key, item.value));
  return text;
}

string mustache(string text, Json map, string[] selectedKeys = null) {
  if (!map.isObject) {
    return text; // If items is not an object, return the original text
  }
  map.byKeyValue
    .filter!(kv => map.hasKey(kv.key))
    .filter!(kv => selectedKeys.length == 0 || selectedKeys.hasValue(kv.key))
    .each!(kv => text = text.mustache(kv.key, map[kv.key]));
  return text;
}

string mustache(string text, string[string] items) {
  items.byKeyValue.each!(item => text = text.mustache(item.key, item.value));
  return text;
}

string mustache(string text, string[] keys, string[] values) {
  if (keys.length != values.length) {
    throw new Exception("Keys and values must have the same length.");
  }
  for (size_t i = 0; i < keys.length; i++) {
    text = text.mustache(keys[i], values[i]);
  }
  return text;
}

string mustache(string text, string key, Json value) {
  return value.isString 
    ? mustache(text, key, value.get!string)
    : mustache(text, key, value.to!string);
}

string mustache(string text, string key, string value) {
  return std.string.replace(text, "{" ~ key ~ "}", value);
}
