/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.factories.renderer;

mixin(ShowModule!());

import uim.errors;
@safe:

class ErrorRendererFactory : UIMFactory!(string, IErrorRenderer) {
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
  static ErrorRendererFactory opCall() { return ErrorRendererFactory.instance; }
  static IErrorRenderer opCall(string name) { return ErrorRendererFactory().create(name); }

}

static this() {
  ErrorRendererFactory().register("console", () {
    return new ConsoleErrorRenderer();
  });

  ErrorRendererFactory().register("html", () {
    return new HtmlErrorRenderer();
  });

  ErrorRendererFactory().register("json", () {
    return new JsonErrorRenderer();
  });

  ErrorRendererFactory().register("text", () {
    return new TextErrorRenderer();
  });

  ErrorRendererFactory().register("xml", () {
    return new XmlErrorRenderer();
  });

  ErrorRendererFactory().register("web", () {
    return new WebErrorRenderer();
  });

  ErrorRendererFactory().register("yaml", () {
    return new YamlErrorRenderer();
  });
}
///
unittest {
  import uim.errors.classes.errors.renderers.console;
  import uim.errors.classes.errors.renderers.html;
  import uim.errors.classes.errors.renderers.json;
  import uim.errors.classes.errors.renderers.text;
  import uim.errors.classes.errors.renderers.web;
  import uim.errors.classes.errors.renderers.yaml;
  
  auto consoleRenderer = ErrorRendererFactory("console");
  assert(cast(ConsoleErrorRenderer)consoleRenderer);
  
  auto htmlRenderer = ErrorRendererFactory("html");
  assert(cast(HtmlErrorRenderer)htmlRenderer);
  
  auto jsonRenderer = ErrorRendererFactory("json");
  assert(cast(JsonErrorRenderer)jsonRenderer);
  
  auto textRenderer = ErrorRendererFactory("text");
  assert(cast(TextErrorRenderer)textRenderer);
  
  auto webRenderer = ErrorRendererFactory("web");
  assert(cast(WebErrorRenderer)webRenderer);
  
  auto yamlRenderer = ErrorRendererFactory("yaml");
  assert(cast(YamlErrorRenderer)yamlRenderer);
}