module uim.html.mixins.input;

import uim.html;

mixin(ShowModule!());

@safe:

template H5InputThis(string type) {
  this() {
    super();
    attribute("type", type);
  }

  this(string content) {
    super(content);
    attribute("type", type);
  }

  this(string[] classes, string content = "") {
    super(classes, content);
    attribute("type", type);
  }

  this(string[] classes, IHtmlElement[] elements) {
    super(classes, elements);
    attribute("type", type);
  }

  this(string[string] attributes, string content = "") {
    super(attributes, content);
    attribute("type", type);
  }

  this(string[string] attributes, IHtmlElement[] elements) {
    super(attributes, elements);
    attribute("type", type);
  }

  this(string[] classes, string[string] attributes, string content = "") {
    super(classes, attributes, content);
    attribute("type", type);
  }

  this(string[] classes, string[string] attributes, IHtmlElement[] elements) {
    super(classes, attributes, elements);
    attribute("type", type);
  }
}

