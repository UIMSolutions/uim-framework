/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphs.core.node;

import uim.graphs.interfaces.node;
import std.variant : Variant;
import std.uuid : UUID, randomUUID;

class Node : INode {
    private string _id;
    private string _label;
    private Variant[string] _data;
    private size_t _degree;

    this(string id, string label = "") @safe {
        _id = id;
        _label = label.empty ? id : label;
        _degree = 0;
    }

    @property string id() const @safe { return _id; }
    
    @property string label() const @safe { return _label; }
    
    void label(string newLabel) @safe { _label = newLabel; }
    
    @property Variant[string] data() const @safe { return _data; }
    
    void setData(string key, Variant value) @safe { _data[key] = value; }
    
    @property size_t degree() const @safe { return _degree; }
    
    package void incDegree() @safe { _degree++; }
    
    package void decDegree() @safe { if (_degree > 0) _degree--; }
}
