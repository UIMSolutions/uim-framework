/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.databases.classes.columns.column;

import uim.databases;

mixin(ShowModule!());

@safe:

class TableColumn : UIMObject {
    private string _name;
    private string _type;

    this(string name, string type) {
        this._name = name;
        this._type = type;
    }

    @property string name() const {
        return _name;
    }

    @property void name(string value) {
        _name = value;
    }

    @property string type() const {
        return _type;
    }

    @property void type(string value) {
        _type = value;
    }

    override string toString() {
        return "Column(name: " ~ _name ~ ", type: " ~ _type ~ ")";
    }
}
