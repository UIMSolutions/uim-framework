/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.classes.structuredtype;

import uim.edm;
import std.algorithm : canFind, filter;
import std.array : array;

@safe:

/**
 * Base class for structured types (complex and entity)
 */
abstract class EdmStructuredType : EdmType, IEdmStructuredType {
    mixin(ObjThis!("EdmStructuredType"));
    
    protected IEdmStructuredType _baseType;
    protected bool _isAbstract;
    protected bool _isOpen;
    protected IEdmProperty[] _declaredProperties;
    
    this(IEdmSchema parentSchema, string typeName, EdmTypeKind kind) {
        super(parentSchema, typeName, kind);
    }
    
    override IEdmStructuredType baseType() {
        return _baseType;
    }
    
    EdmStructuredType baseType(IEdmStructuredType value) {
        _baseType = value;
        return this;
    }
    
    override bool isAbstract() {
        return _isAbstract;
    }
    
    EdmStructuredType isAbstract(bool value) {
        _isAbstract = value;
        return this;
    }
    
    override bool isOpen() {
        return _isOpen;
    }
    
    EdmStructuredType isOpen(bool value) {
        _isOpen = value;
        return this;
    }
    
    override IEdmProperty[] properties() {
        IEdmProperty[] allProps = _declaredProperties.dup;
        if (_baseType) {
            allProps = _baseType.properties() ~ allProps;
        }
        return allProps;
    }
    
    override IEdmProperty[] declaredProperties() {
        return _declaredProperties;
    }
    
    override IEdmProperty findProperty(string propertyName) {
        foreach (prop; _declaredProperties) {
            if (prop.name() == propertyName) {
                return prop;
            }
        }
        if (_baseType) {
            return _baseType.findProperty(propertyName);
        }
        return null;
    }
    
    /// Add a structural property
    EdmStructuralProperty addProperty(string propertyName, IEdmType propertyType, bool nullable = true) {
        auto prop = new EdmStructuralProperty(this, propertyName, propertyType);
        prop.nullable(nullable);
        _declaredProperties ~= prop;
        return prop;
    }
    
    /// Add a navigation property
    EdmNavigationProperty addNavigationProperty(string propertyName, IEdmType targetType, bool isCollection = false) {
        auto prop = new EdmNavigationProperty(this, propertyName, targetType, isCollection);
        _declaredProperties ~= prop;
        return prop;
    }
}

/**
 * Entity type implementation
 */
class EdmEntityType : EdmStructuredType, IEdmEntityType {
    mixin(ObjThis!("EdmEntityType"));
    
    protected IEdmStructuralProperty[] _keyProperties;
    protected bool _hasStream;
    
    this(IEdmSchema parentSchema, string typeName) {
        super(parentSchema, typeName, EdmTypeKind.Entity);
    }
    
    override IEdmStructuralProperty[] keyProperties() {
        return _keyProperties;
    }
    
    /// Add a key property
    EdmEntityType addKey(string propertyName) {
        auto prop = cast(IEdmStructuralProperty)findProperty(propertyName);
        if (prop && !_keyProperties.canFind(prop)) {
            _keyProperties ~= prop;
        }
        return this;
    }
    
    override bool hasStream() {
        return _hasStream;
    }
    
    EdmEntityType hasStream(bool value) {
        _hasStream = value;
        return this;
    }
}

/**
 * Complex type implementation
 */
class EdmComplexType : EdmStructuredType, IEdmComplexType {
    mixin(ObjThis!("EdmComplexType"));
    
    this(IEdmSchema parentSchema, string typeName) {
        super(parentSchema, typeName, EdmTypeKind.Complex);
    }
}
