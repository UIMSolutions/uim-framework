/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.classes.element;

import uim.edm;

@safe:

/**
 * Base class for EDM elements
 */
class EdmElement : UIMObject, IEdmElement {
    mixin(ObjThis!("EdmElement"));
    
    protected IEdmSchema _schema;
    
    this(IEdmSchema parentSchema) {
        _schema = parentSchema;
    }
    
    override IEdmSchema schema() {
        return _schema;
    }
}

/**
 * Base class for named EDM elements
 */
class EdmNamedElement : EdmElement, IEdmNamedElement {
    mixin(ObjThis!("EdmNamedElement"));
    
    protected string _name;
    
    this(IEdmSchema parentSchema, string elementName) {
        super(parentSchema);
        _name = elementName;
    }
    
    override string name() {
        return _name;
    }
    
    override string fullName() {
        if (_schema) {
            return _schema.namespace() ~ "." ~ _name;
        }
        return _name;
    }
}
