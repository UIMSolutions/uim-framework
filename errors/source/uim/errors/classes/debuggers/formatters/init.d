/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.formatters.init;

import uim.errors;

@safe:

/* 

static this() {
  ErrorFormatterFactory.set("console", (Json[string] options = null) {
    return new DConsoleErrorFormatter(options);
  });

  ErrorFormatterFactory.set("html", (Json[string] options = null) {
    return new DHtmlErrorFormatter(options);
  });

  ErrorFormatterFactory.set("json", (Json[string] options = null) {
    return new DJsonErrorFormatter(options);
  });

  ErrorFormatterFactory.set("text", (Json[string] options = null) {
    return new DTextErrorFormatter(options);
  });

  ErrorFormatterFactory.set("xml", (Json[string] options = null) {
    return new DXmlErrorFormatter(options);
  });

  ErrorFormatterFactory.set("yaml", (Json[string] options = null) {
    return new DYamlErrorFormatter(options);
  });
}

unittest {
  writeln(ErrorFormatterFactory.paths);
}

*/