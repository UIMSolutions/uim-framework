/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.factories.error;

mixin(ShowModule!());

import uim.errors;

@safe:

class UIMErrorFactory : UIMFactory!(string, UIMError) {
    this() {
        super(() => new UIMError());
    }

    private static UIMErrorFactory _instance;
    static UIMErrorFactory instance() {
        if (_instance is null) {
            _instance = new UIMErrorFactory();
        }
        return _instance;
    }
}

auto ErrorFactory() {
    return UIMErrorFactory.instance;
}
