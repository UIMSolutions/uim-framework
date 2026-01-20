/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.enumerations.typekind;

/**
 * Kinds of EDM types in the type system
 */
enum EdmTypeKind {
    /// No type specified
    None,
    
    /// Primitive type (string, int, etc.)
    Primitive,
    
    /// Entity type (with key)
    Entity,
    
    /// Complex type (structured without key)
    Complex,
    
    /// Collection type
    Collection,
    
    /// Entity reference
    EntityReference,
    
    /// Enumeration type
    Enum,
    
    /// Type definition (alias)
    TypeDefinition,
    
    /// Untyped
    Untyped,
    
    /// Path type
    Path
}
