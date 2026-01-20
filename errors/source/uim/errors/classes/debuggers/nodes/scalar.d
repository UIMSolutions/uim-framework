/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.scalar;

import uim.errors;
mixin(ShowModule!());
@safe:

// Dump node for scalar values.
class DScalarErrorNode : UIMErrorNode {
    mixin(ErrorNodeThis!("Scalar"));
    
    this(string newType, Json newValue) {
        super();
        _type = newType;
        _data = newValue;
    }
    
    // #region type
    // Type of scalar data
    private string _type;
    // Get the type of value
    string type() {
        return _type;
    }
    DScalarErrorNode type(string aType) {
        _type = aType;
        return this;
    }
    // #endregion type

    // Scalar data
    protected Json _data;
    Json data() {
        return _data;
    }
    
    DScalarErrorNode data(Json newData) {
        _data = newData;
        return this;
    }
}

/*
unittest {
    // Test construction and getters
    auto value = parseJsonString(`42`);
    auto node = new DScalarErrorNode("int", value);

    assert(node.type == "int");
    assert(node.data == value);

    // Test type setter
    node.type("float");
    assert(node.type == "float");

    // Test data setter
    auto newValue = parseJsonString(`3.14`);
    node.data(newValue);
    assert(node.data == newValue);

    // Test chaining
    auto chained = node.type("string").data(Json("hello"));
    assert(chained is node);
    assert(node.type == "string");
    assert(node.data == Json("hello"));
} */