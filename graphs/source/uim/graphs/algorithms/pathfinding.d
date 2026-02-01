/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.graphs.algorithms.pathfinding;

import uim.graphs.core.graph;
import std.container : DList;
import std.math : isInfinity;

struct Path {
    string[] nodes;
    double distance;
}

class Dijkstra {
    private Graph _graph;

    this(Graph graph) @safe {
        _graph = graph;
    }

    Path findShortest(string start, string end) @safe {
        auto distances = _initDistances(start);
        auto previous = _initPrevious();
        auto unvisited = _getAllNodeIds();
        
        while (!unvisited.empty) {
            auto current = _getMinUnvisited(distances, unvisited);
            if (current.empty || (current == end && distances[end].isInfinity())) {
                break;
            }
            _removeFromList(unvisited, current);
            
            auto edges = _graph.edgesFrom(current);
            foreach (e; edges) {
                auto neighbor = e.source() == current ? e.target() : e.source();
                if (_isInList(unvisited, neighbor)) {
                    auto alt = distances[current] + e.weight();
                    if (alt < distances[neighbor]) {
                        distances[neighbor] = alt;
                        previous[neighbor] = current;
                    }
                }
            }
        }
        
        return _reconstructPath(start, end, previous, distances[end]);
    }

    private double[string] _initDistances(string start) @safe {
        double[string] dist;
        foreach (node; _graph.nodes()) {
            dist[node.id()] = double.infinity;
        }
        dist[start] = 0;
        return dist;
    }

    private string[string] _initPrevious() @safe {
        string[string] prev;
        foreach (node; _graph.nodes()) {
            prev[node.id()] = "";
        }
        return prev;
    }

    private string[] _getAllNodeIds() @safe {
        string[] ids;
        foreach (node; _graph.nodes()) {
            ids ~= node.id();
        }
        return ids;
    }

    private string _getMinUnvisited(const double[string] distances, const string[] unvisited) @safe {
        string minId;
        double minDist = double.infinity;
        foreach (id; unvisited) {
            if (id in distances && distances[id] < minDist) {
                minDist = distances[id];
                minId = id;
            }
        }
        return minId;
    }

    private void _removeFromList(ref string[] list, string item) @safe {
        foreach (i, v; list) {
            if (v == item) {
                list = list[0 .. i] ~ list[i + 1 .. $];
                break;
            }
        }
    }

    private bool _isInList(const string[] list, string item) @safe {
        foreach (v; list) {
            if (v == item) return true;
        }
        return false;
    }

    private Path _reconstructPath(string start, string end, const string[string] previous, double distance) @safe {
        string[] path;
        auto current = end;
        while (current != "") {
            path = [current] ~ path;
            current = previous.get(current, "");
        }
        if (path.empty || path[0] != start) {
            return Path([], double.infinity);
        }
        return Path(path, distance);
    }
}
