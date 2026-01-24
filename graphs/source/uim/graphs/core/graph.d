/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.graphs.core.graph;

import uim.graphs.interfaces.graph;
import uim.graphs.interfaces.node;
import uim.graphs.interfaces.edge;
import uim.graphs.core.node : Node;
import uim.graphs.core.edge : Edge;
import std.array : array;
import std.algorithm : filter;

class Graph : IGraph {
    private Node[string] _nodes;
    private Edge[] _edges;

    void addNode(INode node) @safe {
        auto n = cast(Node) node;
        if (n !is null) {
            _nodes[n.id()] = n;
        }
    }

    Node getNode(string id) @safe {
        return _nodes.get(id, null);
    }

    bool hasNode(string id) const @safe {
        return (id in _nodes) !is null;
    }

    void removeNode(string id) @safe {
        if (auto node = _nodes.get(id, null)) {
            // Remove all edges connected to this node
            _edges = _edges.filter!(e => e.source() != id && e.target() != id).array;
            _nodes.remove(id);
        }
    }

    Node[] nodes() @safe {
        return _nodes.values.dup;
    }

    void addEdge(IEdge edge) @safe {
        auto e = cast(Edge) edge;
        if (e !is null && hasNode(e.source()) && hasNode(e.target())) {
            _edges ~= e;
            auto src = getNode(e.source());
            auto tgt = getNode(e.target());
            if (src) src.incDegree();
            if (tgt) tgt.incDegree();
        }
    }

    Edge getEdge(string source, string target) @safe {
        foreach (e; _edges) {
            if (e.source() == source && e.target() == target) {
                return e;
            }
            if (!e.directed() && e.source() == target && e.target() == source) {
                return e;
            }
        }
        return null;
    }

    bool hasEdge(string source, string target) const @safe {
        foreach (e; _edges) {
            if (e.source() == source && e.target() == target) {
                return true;
            }
            if (!e.directed() && e.source() == target && e.target() == source) {
                return true;
            }
        }
        return false;
    }

    void removeEdge(string source, string target) @safe {
        foreach (i, e; _edges) {
            if ((e.source() == source && e.target() == target) ||
                (!e.directed() && e.source() == target && e.target() == source)) {
                auto src = getNode(e.source());
                auto tgt = getNode(e.target());
                if (src) src.decDegree();
                if (tgt) tgt.decDegree();
                _edges = _edges[0 .. i] ~ _edges[i + 1 .. $];
                break;
            }
        }
    }

    Edge[] edgesFrom(string nodeId) @safe {
        return _edges.filter!(e => e.source() == nodeId || (!e.directed() && e.target() == nodeId)).array;
    }

    Edge[] edgesTo(string nodeId) @safe {
        return _edges.filter!(e => e.target() == nodeId || (!e.directed() && e.source() == nodeId)).array;
    }

    Edge[] edges() @safe {
        return _edges.dup;
    }

    @property size_t nodeCount() const @safe { return _nodes.length; }

    @property size_t edgeCount() const @safe { return _edges.length; }

    @property bool empty() const @safe { return _nodes.empty && _edges.empty; }

    void clear() @safe {
        _nodes.clear();
        _edges.clear();
    }
}
