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