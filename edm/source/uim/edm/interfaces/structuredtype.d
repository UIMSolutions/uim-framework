/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.structuredtype;

import uim.edm;

@safe:

/**
 * Interface for structured types (complex and entity types)
 */
interface IEdmStructuredType : IEdmType {
    /// Get base type
    IEdmStructuredType baseType();
    
    /// Check if this type is abstract
    bool isAbstract();
    
    /// Check if this type is open (allows dynamic properties)
    bool isOpen();
    
    /// Get all properties (including inherited)
    IEdmProperty[] properties();
    
    /// Get declared properties (not inherited)
    IEdmProperty[] declaredProperties();
    
    /// Find property by name
    IEdmProperty findProperty(string propertyName);
}

/**
 * Interface for entity types (with keys)
 */
interface IEdmEntityType : IEdmStructuredType {
    /// Get key properties
    IEdmStructuralProperty[] keyProperties();
    
    /// Check if this entity has a stream
    bool hasStream();
}

/**
 * Interface for complex types (without keys)
 */
interface IEdmComplexType : IEdmStructuredType {
}
