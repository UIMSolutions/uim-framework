/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphs.interfaces.edge;

import std.variant : Variant;

interface IEdge {
    /// Get source node ID
    @property string source() const @safe;
    
    /// Get target/destination node ID
    @property string target() const @safe;
    
    /// Get edge weight (default 1.0)
    @property double weight() const @safe;
    
    /// Get edge label/type
    @property string label() const @safe;
    
    /// Get edge data/metadata
    @property Variant[string] data() const @safe;
    
    /// Set edge data
    void setData(string key, Variant value) @safe;
    
    /// Check if edge is directed
    @property bool directed() const @safe;
}
