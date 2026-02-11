/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.parsers.helpers.factory;

import uim.compilers;

@safe:

/**
  * Factory for creating instances of parsers.
  * This factory allows for the registration of different types of parsers
  * and provides a way to create them by name.
  */
class ParserFactory : UIMFactory!(string, ICompilerParser) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing ParserFactory");

  auto factory = new ParserFactory();
  assert(factory !is null);
  factory.register("test", () => new CompilerParser());
  auto parser = factory.create("test");
  assert(parser !is null);
}
