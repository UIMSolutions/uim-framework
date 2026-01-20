/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.schema;

import uim.edm;

@safe:

/**
 * Interface for EDM schema
 */
interface IEdmSchema : IEdmElement {
    /// Get namespace
    string namespace();
    
    /// Get alias
    string alias_();
    
    /// Get all entity types in this schema
    IEdmEntityType[] entityTypes();
    
    /// Get all complex types in this schema
    IEdmComplexType[] complexTypes();
    
    /// Find type by name
    IEdmType findType(string typeName);
    
    /// Add entity type
    IEdmEntityType addEntityType(string name);
    
    /// Add complex type
    IEdmComplexType addComplexType(string name);
}
