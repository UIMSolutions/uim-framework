/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.imports;

import uim.service;

mixin(ShowModule!());

@safe:

string generateImports(string namespace, string[] modules, bool isPublic = true) {
    string visibility = isPublic ? "public " : "";
    return modules.map!(m => visibility ~ "import " ~ namespace ~ "." ~ m ~ ";").join("\n");
}

template GenerateImports(string namespace, string[] modules, bool isPublic = true) {
    const char[] GenerateImports = generateImports(namespace, modules, isPublic);
}

template ImportPresentation(string namespace) {
    const char[] ImportPresentation = generateImports(namespace, [
            "http", "cli", "gui", "rest", "grpc", "web", "socket", "tcp", "unix"
        ], true);
}
