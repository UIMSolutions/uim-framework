/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.namedelement;

import uim.edm;

@safe:

/**
 * Interface for named EDM elements
 */
interface IEdmNamedElement : IEdmElement {
    /// Get the name of this element
    string name();
    
    /// Get the fully qualified name (namespace.name)
    string fullName();
}
