/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphs.core.edge;

import uim.graphs.interfaces.edge;
import std.variant : Variant;

class Edge : IEdge {
    private string _source;
    private string _target;
    private double _weight;
    private string _label;
    private Variant[string] _data;
    private bool _directed;

    this(string source, string target, string label = "", double weight = 1.0, bool directed = false) @safe {
        _source = source;
        _target = target;
        _label = label;
        _weight = weight;
        _directed = directed;
    }

    @property string source() const @safe { return _source; }
    
    @property string target() const @safe { return _target; }
    
    @property double weight() const @safe { return _weight; }
    
    void weight(double w) @safe { _weight = w; }
    
    @property string label() const @safe { return _label; }
    
    void label(string newLabel) @safe { _label = newLabel; }
    
    @property Variant[string] data() const @safe { return _data; }
    
    void setData(string key, Variant value) @safe { _data[key] = value; }
    
    @property bool directed() const @safe { return _directed; }
}
