/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.classes.type;

import uim.edm;

@safe:

/**
 * Base class for EDM types
 */
abstract class EdmType : EdmNamedElement, IEdmType {
    mixin(ObjThis!("EdmType"));
    
    protected EdmTypeKind _typeKind;
    
    this(IEdmSchema parentSchema, string typeName, EdmTypeKind kind) {
        super(parentSchema, typeName);
        _typeKind = kind;
    }
    
    override EdmTypeKind typeKind() {
        return _typeKind;
    }
    
    override string typeName() {
        return fullName();
    }
}

/**
 * Primitive type implementation
 */
class EdmPrimitiveTypeRef : EdmType {
    mixin(ObjThis!("EdmPrimitiveTypeRef"));
    
    protected EdmPrimitiveType _primitiveType;
    
    this(EdmPrimitiveType primitiveType) {
        super(null, cast(string)primitiveType, EdmTypeKind.Primitive);
        _primitiveType = primitiveType;
    }
    
    EdmPrimitiveType primitiveType() {
        return _primitiveType;
    }
    
    override string name() {
        return cast(string)_primitiveType;
    }
    
    override string fullName() {
        return cast(string)_primitiveType;
    }
}

/// Factory function to get primitive type reference
EdmPrimitiveTypeRef primitiveType(EdmPrimitiveType type) {
    return new EdmPrimitiveTypeRef(type);
}
