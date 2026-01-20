/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.formatters.init;

import uim.errors;

@safe:

/* 

static this() {
  ErrorFormatterFactory.set("console", (Json[string] options = null) @safe {
    return new DConsoleErrorFormatter(options);
  });

  ErrorFormatterFactory.set("html", (Json[string] options = null) @safe {
    return new DHtmlErrorFormatter(options);
  });

  ErrorFormatterFactory.set("json", (Json[string] options = null) @safe {
    return new DJsonErrorFormatter(options);
  });

  ErrorFormatterFactory.set("text", (Json[string] options = null) @safe {
    return new DTextErrorFormatter(options);
  });

  ErrorFormatterFactory.set("xml", (Json[string] options = null) @safe {
    return new DXmlErrorFormatter(options);
  });

  ErrorFormatterFactory.set("yaml", (Json[string] options = null) @safe {
    return new DYamlErrorFormatter(options);
  });
}

unittest {
  writeln(ErrorFormatterFactory.paths);
}

*/