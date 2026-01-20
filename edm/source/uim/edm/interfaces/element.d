/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.interfaces.element;

import uim.edm;

@safe:

/**
 * Base interface for all EDM model elements
 */
interface IEdmElement {
    /// Get the parent schema
    IEdmSchema schema();
}
