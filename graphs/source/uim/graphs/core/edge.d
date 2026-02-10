/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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

    this(string source, string target, string label = "", double weight = 1.0, bool directed = false) {
        _source = source;
        _target = target;
        _label = label;
        _weight = weight;
        _directed = directed;
    }

    @property string source() const { return _source; }
    
    @property string target() const { return _target; }
    
    @property double weight() const { return _weight; }
    
    void weight(double w) { _weight = w; }
    
    @property string label() const { return _label; }
    
    void label(string newLabel) { _label = newLabel; }
    
    @property Variant[string] data() const { return _data; }
    
    void setData(string key, Variant value) { _data[key] = value; }
    
    @property bool directed() const { return _directed; }
}
