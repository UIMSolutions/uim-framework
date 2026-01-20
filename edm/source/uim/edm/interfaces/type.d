/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.type;

import uim.edm;

@safe:

/**
 * Base interface for all EDM types
 */
interface IEdmType : IEdmNamedElement {
    /// Get the type kind
    EdmTypeKind typeKind();
    
    /// Get the type name
    string typeName();
}
