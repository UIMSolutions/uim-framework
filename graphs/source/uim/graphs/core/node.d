/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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

    this(string id, string label = "") {
        _id = id;
        _label = label.empty ? id : label;
        _degree = 0;
    }

    @property string id() const { return _id; }
    
    @property string label() const { return _label; }
    
    void label(string newLabel) { _label = newLabel; }
    
    @property Variant[string] data() const { return _data; }
    
    void setData(string key, Variant value) { _data[key] = value; }
    
    @property size_t degree() const { return _degree; }
    
    package void incDegree() { _degree++; }
    
    package void decDegree() { if (_degree > 0) _degree--; }
}
