/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.lexers.helpers.factory;

import uim.compilers;

mixin(ShowModule!());

@safe:

// Factory for creating instances of lexers. This factory allows for the registration of different types of lexers and provides a way to create them by name.
class LexerFactory : UIMFactory!(string, ILexer) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing LexerFactory");

  auto factory = new LexerFactory();
  assert(factory !is null);
  factory.register("test", () => new Lexer());
  auto lexer = factory.create("test");
  assert(lexer !is null);
}
