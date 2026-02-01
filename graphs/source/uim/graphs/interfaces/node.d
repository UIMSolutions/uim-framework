/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.graphs.interfaces.node;

import std.variant : Variant;

interface INode {
    /// Get unique node ID
    @property string id() const @safe;
    
    /// Get node label
    @property string label() const @safe;
    
    /// Get node data/metadata
    @property Variant[string] data() const @safe;
    
    /// Set node data
    void setData(string key, Variant value) @safe;
    
    /// Get node degree (number of connections)
    @property size_t degree() const @safe;
}
