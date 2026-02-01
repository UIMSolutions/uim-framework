/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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

    INode getNode(string id) @safe {
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

    INode[] nodes() @safe {
        INode[] result;
        foreach (node; _nodes.values) {
            result ~= node;
        }
        return result;
    }

    void addEdge(IEdge edge) @safe {
        auto e = cast(Edge) edge;
        if (e !is null && hasNode(e.source()) && hasNode(e.target())) {
            _edges ~= e;
            auto src = cast(Node)getNode(e.source());
            auto tgt = cast(Node)getNode(e.target());
            if (src) src.incDegree();
            if (tgt) tgt.incDegree();
        }
    }

    IEdge getEdge(string source, string target) @safe {
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
                auto src = cast(Node)getNode(e.source());
                auto tgt = cast(Node)getNode(e.target());
                if (src) src.decDegree();
                if (tgt) tgt.decDegree();
                _edges = _edges[0 .. i] ~ _edges[i + 1 .. $];
                break;
            }
        }
    }

    IEdge[] edgesFrom(string nodeId) @safe {
        IEdge[] result;
        foreach (e; _edges) {
            if (e.source() == nodeId || (!e.directed() && e.target() == nodeId)) {
                result ~= e;
            }
        }
        return result;
    }

    IEdge[] edgesTo(string nodeId) @safe {
        IEdge[] result;
        foreach (e; _edges) {
            if (e.target() == nodeId || (!e.directed() && e.source() == nodeId)) {
                result ~= e;
            }
        }
        return result;
    }

    IEdge[] edges() @safe {
        IEdge[] result;
        foreach (e; _edges) {
            result ~= e;
        }
        return result;
    }

    @property size_t nodeCount() const @safe { return _nodes.length; }

    @property size_t edgeCount() const @safe { return _edges.length; }

    @property bool empty() const @safe { return _nodes.empty && _edges.empty; }

    void clear() @safe {
        _nodes.clear();
        _edges.clear();
    }
}
