module uim.html.mixins;

import uim.html;

mixin(ShowModule!());

@safe:

public {
  import uim.html.mixins.element;
  import uim.html.mixins.input;
}

/*
/// Mixin for elements that can be self-closing
mixin SelfClosing {
  bool selfClosing() {
    return _selfClosing;
  }

  void selfClosing(bool value) {
    _selfClosing = value;
  }

  protected bool _selfClosing;
}

string showSelfClosing() {
  return selfClosing() ? " (self-closing)" : "";
}

string showTagName() {
  return tagName ~ showSelfClosing();
}

string showElement() {
  return "<" ~ tagName ~ showSelfClosing() ~ ">";
}

string showElementWithContent() {
  return "<" ~ tagName ~ showSelfClosing() ~ ">" ~ content() ~ "</" ~ tagName ~ ">";
}

string showElementWithAttributes() {
  string result = "<" ~ tagName;
  foreach (name, value; attributes()) {
    result ~= " " ~ name ~ "=\"" ~ value ~ "\"";
  }
  result ~= showSelfClosing() ~ ">";
  return result;
}

string showElementWithAttributesAndContent() {
  string result = "<" ~ tagName;
  foreach (name, value; attributes()) {
    result ~= " " ~ name ~ "=\"" ~ value ~ "\"";
  }
  result ~= showSelfClosing() ~ ">" ~ content() ~ "</" ~ tagName ~ ">";
  return result;
}

string showElementWithClasses() {
  string result = "<" ~ tagName;
  if (classes().length > 0) {
    result ~= " class=\"" ~ classes().join(" ") ~ "\"";
  }
  result ~= showSelfClosing() ~ ">";
  return result;
}

string showElementWithClassesAndContent() {
  string result = "<" ~ tagName;
  if (classes().length > 0) {
    result ~= " class=\"" ~ classes().join(" ") ~ "\"";
  }
  result ~= showSelfClosing() ~ ">" ~ content() ~ "</" ~ tagName ~ ">";
  return result;
}
*/ 