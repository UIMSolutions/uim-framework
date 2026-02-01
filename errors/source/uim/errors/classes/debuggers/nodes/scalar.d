/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.scalar;

import uim.errors;
mixin(ShowModule!());
@safe:

// Dump node for scalar values.
class ScalarErrorNode : ErrorNode {
    mixin(ErrorNodeThis!("Scalar"));
    
    // #region type
    // Type of scalar data
    private string _type;
    // Get the type of value
    string type() {
        return _type;
    }
    ScalarErrorNode type(string aType) {
        _type = aType;
        return this;
    }
    // #endregion type

    // Scalar data
    protected Json _data;
    Json data() {
        return _data;
    }
    
    ScalarErrorNode data(Json newData) {
        _data = newData;
        return this;
    }
}

/*
unittest {
    // Test construction and getters
    auto value = parseJsonString(`42`);
    auto node = new ScalarErrorNode("int", value);

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