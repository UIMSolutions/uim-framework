module uim.html.mixins.element;

import uim.html;

mixin(ShowModule!());

@safe:

template H5This(string tag, bool selfClosing = false) {
  this() {
    super(tag);
    _selfClosing = selfClosing;
  }

  this(string[] classes, string content = "") {
    super(tag, classes, content);
    _selfClosing = selfClosing;
  }

  this(string[] classes, IHtmlElement[] elements) {
    super(tag, classes, elements);
    _selfClosing = selfClosing;
  }

  this(string[string] attributes, string content = "") {
    super(tag, attributes, content);
    _selfClosing = selfClosing;
  }

  this(string[string] attributes, IHtmlElement[] elements) {
    super(tag, attributes, elements);
    _selfClosing = selfClosing;
  }

  this(string[] classes, string[string] attributes, string content = "") {
    super(tag, classes, attributes, content);
    _selfClosing = selfClosing;
  }

  this(string[] classes, string[string] attributes, IHtmlElement[] elements) {
    super(tag, classes, attributes, elements);
    _selfClosing = selfClosing;
  }
}

string h5Calls(string name) {
  return `
    static H5{name} opCall() {
      return new H5{name}();
    }
    static H5{name} opCall(string content) {
      auto element = new H5{name}();
      element.content(content);
      return element;
    }
    static H5{name} opCall(string[string] attributes) {
      auto element = new H5{name}();
      element.attributes(attributes);
      return element;
    }
    `.mustache("name", name);
}

template H5Calls(string name) {
  const char[] H5Calls = h5Calls(name);
}
