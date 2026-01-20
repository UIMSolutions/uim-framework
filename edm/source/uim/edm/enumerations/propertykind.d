/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.enumerations.propertykind;

/**
 * Kinds of properties in EDM types
 */
enum EdmPropertyKind {
    /// None specified
    None,
    
    /// Structural property (data member)
    Structural,
    
    /// Navigation property (relationship)
    Navigation
}
