/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.classes.schema;

import uim.edm;

@safe:

/**
 * EDM Schema implementation
 */
class EdmSchema : UIMObject, IEdmSchema {
    mixin(ObjThis!("EdmSchema"));
    
    protected string _namespace;
    protected string _alias;
    protected IEdmEntityType[] _entityTypes;
    protected IEdmComplexType[] _complexTypes;
    
    this(string schemaNamespace, string schemaAlias = null) {
        _namespace = schemaNamespace;
        _alias = schemaAlias;
    }
    
    override IEdmSchema schema() {
        return this;
    }
    
    override string namespace() {
        return _namespace;
    }
    
    override string alias_() {
        return _alias;
    }
    
    EdmSchema alias_(string value) {
        _alias = value;
        return this;
    }
    
    override IEdmEntityType[] entityTypes() {
        return _entityTypes;
    }
    
    override IEdmComplexType[] complexTypes() {
        return _complexTypes;
    }
    
    override IEdmType findType(string typeName) {
        // Check entity types
        foreach (entityType; _entityTypes) {
            if (entityType.name() == typeName || entityType.fullName() == typeName) {
                return entityType;
            }
        }
        
        // Check complex types
        foreach (complexType; _complexTypes) {
            if (complexType.name() == typeName || complexType.fullName() == typeName) {
                return complexType;
            }
        }
        
        return null;
    }
    
    override IEdmEntityType addEntityType(string name) {
        auto entityType = new EdmEntityType(this, name);
        _entityTypes ~= entityType;
        return entityType;
    }
    
    override IEdmComplexType addComplexType(string name) {
        auto complexType = new EdmComplexType(this, name);
        _complexTypes ~= complexType;
        return complexType;
    }
    
    /// Create entity type with fluent API
    EdmEntityType createEntityType(string name) {
        return cast(EdmEntityType)addEntityType(name);
    }
    
    /// Create complex type with fluent API
    EdmComplexType createComplexType(string name) {
        return cast(EdmComplexType)addComplexType(name);
    }
}

/// Factory function to create a schema
EdmSchema createSchema(string namespace, string alias_ = null) {
    return new EdmSchema(namespace, alias_);
}
