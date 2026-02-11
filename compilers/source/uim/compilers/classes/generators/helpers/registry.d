/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.generators.helpers.registry;

import uim.compilers;

mixin(ShowModule!());

@safe:

/**
  * This module defines registries for code generators and parsers.
  * It provides a way to register and retrieve code generators and parsers by name.
  * The registries are implemented as singletons to ensure a single point of access throughout the
  * application.
  */
class CodeGeneratorRegistry : UIMRegistry!(string, ICodeGenerator) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing CodeGeneratorRegistry");

  // TODO: auto registry = new CodeGeneratorRegistry();
  // TODO: assert(registry !is null);
  // TODO: registry.register("test", () => new CodeGenerator());
  // TODO: auto generator = registry.create("test");
  // TODO: assert(generator !is null);
}
