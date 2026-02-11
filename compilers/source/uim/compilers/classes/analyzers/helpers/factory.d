/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.compilers.classes.analyzers.helpers.factory;

import uim.compilers;

@safe:

/**
  * Factory for creating instances of semantic analyzers.
  * This factory allows for the registration of different types of semantic analyzers
  * and provides a way to create them by name.
  */
class SemanticAnalyzerFactory : UIMFactory!(string, ISemanticAnalyzer) {
  this() {
    super();
  }
}
///
unittest {
  mixin(ShowTest!"Testing SemanticAnalyzerFactory");  

  auto factory = new SemanticAnalyzerFactory();
  assert(factory !is null);
  factory.register("test", () => new SemanticAnalyzer());
  auto analyzer = factory.create("test");
  assert(analyzer !is null);
}