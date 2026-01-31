/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
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
  errorRendererFactory.register("console", () @safe {
    return new ConsoleErrorRenderer();
  });

  errorRendererFactory.register("html", () @safe {
    return new HtmlErrorRenderer();
  });

  errorRendererFactory.register("json", () @safe {
    return new JsonErrorRenderer();
  });

  errorRendererFactory.register("text", () @safe {
    return new TextErrorRenderer();
  });

  errorRendererFactory.register("xml", () @safe {
    return new XmlErrorRenderer();
  });

  errorRendererFactory.register("web", () @safe {
    return new WebErrorRenderer();
  });

  errorRendererFactory.register("yaml", () @safe {
    return new YamlErrorRenderer();
  });
}
