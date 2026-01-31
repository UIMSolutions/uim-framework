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
auto ErrorRendererFactory() { return ErrorRendererFactory.instance; }

static this() {
  ErrorRendererFactory.register("console", () @safe {
    return new DConsoleErrorRenderer();
  });

  ErrorRendererFactory.register("html", () @safe {
    return new DHtmlErrorRenderer();
  });

  ErrorRendererFactory.register("json", () @safe {
    return new DJsonErrorRenderer();
  });

  ErrorRendererFactory.register("text", () @safe {
    return new DTextErrorRenderer();
  });

  ErrorRendererFactory.register("xml", () @safe {
    return new DXmlErrorRenderer();
  });

  ErrorRendererFactory.register("web", () @safe {
    return new DWebErrorRenderer();
  });

  ErrorRendererFactory.register("yaml", () @safe {
    return new DYamlErrorRenderer();
  });
}
