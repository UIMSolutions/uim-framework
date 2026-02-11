/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.factories.renderer;

mixin(ShowModule!());

import uim.errors;
@safe:

class ErrorRendererFactory : UIMFactory!(string, ErrorRenderer) {
  this() {
    super(() => new ErrorRenderer());
  }
  
  private static ErrorRendererFactory _instance;
  static ErrorRendererFactory instance() {
    if (_instance is null) {
      _instance = new ErrorRendererFactory();
    }
    return _instance;
  }
}
auto errorRendererFactory() { return ErrorRendererFactory.instance; }

static this() {
  errorRendererFactory.register("console", () {
    return new ConsoleErrorRenderer();
  });

  errorRendererFactory.register("html", () {
    return new HtmlErrorRenderer();
  });

  errorRendererFactory.register("json", () {
    return new JsonErrorRenderer();
  });

  errorRendererFactory.register("text", () {
    return new TextErrorRenderer();
  });

  errorRendererFactory.register("xml", () {
    return new XmlErrorRenderer();
  });

  errorRendererFactory.register("web", () {
    return new WebErrorRenderer();
  });

  errorRendererFactory.register("yaml", () {
    return new YamlErrorRenderer();
  });
}
