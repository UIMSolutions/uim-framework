/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.udas.attribute;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * UDA to mark a field as an entity attribute
 */
struct EntityAttribute {
    string name;
    bool required = false;
    
    this(string fieldName) {
        name = fieldName;
    }
    
    this(string fieldName, bool isRequired) {
        name = fieldName;
        required = isRequired;
    }
}