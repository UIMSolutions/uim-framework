module uim.html.mixins.element;

import uim.html;

mixin(ShowModule!());

@safe:

string h5This(string tag, bool selfClosing = false) {
  return `
  this() {
    super("{tag}".toLower());
    _selfClosing = {selfClosing};
  }

  this(string content) {
    super("{tag}".toLower());
    this.content(content);  
    _selfClosing = {selfClosing};
  }

  this(string[] classes, string content = "") {
    super("{tag}".toLower(), classes, content);
    _selfClosing = {selfClosing};
  }

  this(string[] classes, IHtmlElement[] elements) {
    super("{tag}".toLower(), classes, elements);
    _selfClosing = {selfClosing};
  }

  this(string[string] attributes, string content = "") {
    super("{tag}".toLower(), attributes, content);
    _selfClosing = {selfClosing};
  }

  this(string[string] attributes, IHtmlElement[] elements) {
    super("{tag}".toLower(), attributes, elements);
    _selfClosing = {selfClosing};
  }

  this(string[] classes, string[string] attributes, string content = "") {
    super("{tag}".toLower(), classes, attributes, content);
    _selfClosing = {selfClosing};
  }

  this(string[] classes, string[string] attributes, IHtmlElement[] elements) {
    super("{tag}".toLower(), classes, attributes, elements);
    _selfClosing = {selfClosing};
  }`
  .mustache("tag", tag)
  .mustache("selfClosing", selfClosing ? "true" : "false");
}

template H5This(string tag, bool selfClosing = false) {
  const char[] H5This = h5This(tag, selfClosing);
}

string h5Calls(string name) {
  if (name.length > 0) {
    name = "H5" ~ name[0..1].capitalize ~ name[1 .. $];
  }  

  return `
    static {name} opCall() {
      return new {name}();
    }
    static {name} opCall(string content) {
      return new {name}(content);
    }
    static {name} opCall(string[] classes, string content = "") {
      return new {name}(classes, content);
    }
    static {name} opCall(string[string] attributes, string content = "") {
      return new {name}(attributes, content);
    }
    static {name} opCall(string[] classes, string[string] attributes, string content = "") {
      return new {name}(classes, attributes, content);
    }
    `.mustache("name", name);
}

template H5Calls(string name) {
  const char[] H5Calls = h5Calls(name);
}

string htmlTemplate(string name, string tag, bool selfClosing = false) {
  return h5This(tag, selfClosing) ~ h5Calls(name);
}

template HtmlTemplate(string name, string tag, bool selfClosing = false) {
  const char[] HtmlTemplate = htmlTemplate(name, tag, selfClosing);
}
