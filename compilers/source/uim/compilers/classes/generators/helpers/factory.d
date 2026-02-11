/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.generators.helpers.factory;

import uim.compilers;

mixin(ShowModule!());

@safe:

class CodeGeneratorFactory : UIMFactory!(string, ICodeGenerator) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing CodeGeneratorFactory");

  auto factory = new CodeGeneratorFactory();

  assert(factory !is null);
  factory.register("test", () => new CodeGenerator());
  auto generator = factory.create("test");
  assert(generator !is null);
}
