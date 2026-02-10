/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.graphs.algorithms.traversal;

import uim.graphs.interfaces.graph;
import uim.graphs.interfaces.node;
import uim.graphs.core.graph;
import std.container : SList, DList;
import std.array : array;

class BreadthFirstTraversal {
    private Graph _graph;
    private string[] _visited;

    this(Graph graph) {
        _graph = graph;
    }

    string[] traverse(string startId) {
        _visited = [];
        auto queue = DList!string([startId]);
        
        while (!queue.empty()) {
            auto nodeId = queue.front();
            queue.removeFront();
            
            if (_isVisited(nodeId)) continue;
            _visited ~= nodeId;
            
            auto edges = _graph.edgesFrom(nodeId);
            foreach (e; edges) {
                auto nextId = e.source() == nodeId ? e.target() : e.source();
                if (!_isVisited(nextId)) {
                    queue.insertBack(nextId);
                }
            }
        }
        return _visited;
    }

    private bool _isVisited(string id) {
        foreach (v; _visited) {
            if (v == id) return true;
        }
        return false;
    }
}

class DepthFirstTraversal {
    private Graph _graph;
    private string[] _visited;

    this(Graph graph) {
        _graph = graph;
    }

    string[] traverse(string startId) {
        _visited = [];
        _dfs(startId);
        return _visited;
    }

    private void _dfs(string nodeId) {
        if (_isVisited(nodeId)) return;
        _visited ~= nodeId;
        
        auto edges = _graph.edgesFrom(nodeId);
        foreach (e; edges) {
            auto nextId = e.source() == nodeId ? e.target() : e.source();
            _dfs(nextId);
        }
    }

    private bool _isVisited(string id) {
        foreach (v; _visited) {
            if (v == id) return true;
        }
        return false;
    }
}
