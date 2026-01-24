/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.compilers.classes.analyzers.helpers.factory;

import uim.compilers;

@safe:

class SemanticAnalyzerFactory : UIMFactory!(string, ISemanticAnalyzer) {
    this() {
        super();
    }
}
