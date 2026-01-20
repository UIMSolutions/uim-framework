/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.property;

import uim.edm;

@safe:

/**
 * Interface for EDM properties
 */
interface IEdmProperty : IEdmNamedElement {
    /// Get the property kind
    EdmPropertyKind propertyKind();
    
    /// Get the property type
    IEdmType propertyType();
    
    /// Check if property is nullable
    bool nullable();
    
    /// Get the declaring type
    IEdmStructuredType declaringType();
}

/**
 * Interface for structural properties (data members)
 */
interface IEdmStructuralProperty : IEdmProperty {
    /// Get default value
    string defaultValue();
    
    /// Get max length (for strings/binary)
    int maxLength();
    
    /// Get precision (for decimals)
    int precision();
    
    /// Get scale (for decimals)
    int scale();
    
    /// Check if Unicode
    bool unicode();
}

/**
 * Interface for navigation properties (relationships)
 */
interface IEdmNavigationProperty : IEdmProperty {
    /// Get partner navigation property
    IEdmNavigationProperty partner();
    
    /// Check if this is a collection
    bool isCollection();
    
    /// Get the target entity type
    IEdmType targetType();
    
    /// Check if this side contains the dependent (foreign key)
    bool containsTarget();
}
