/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module graph_test;

import uim.graphs;
import uim.graphs.core.node : Node;
import uim.graphs.core.edge : Edge;
import uim.graphs.core.graph : Graph;
import uim.graphs.algorithms.traversal : BreadthFirstTraversal, DepthFirstTraversal;
import uim.graphs.algorithms.pathfinding : Dijkstra;
import std.stdio;
import std.variant : Variant;

void main() {
    auto graph = new Graph();
    
    // Create nodes
    graph.addNode(new Node("A", "Node A"));
    graph.addNode(new Node("B", "Node B"));
    graph.addNode(new Node("C", "Node C"));
    graph.addNode(new Node("D", "Node D"));
    
    assert(graph.nodeCount() == 4);
    
    // Create edges
    graph.addEdge(new Edge("A", "B", "connects", 1.0, true));
    graph.addEdge(new Edge("B", "C", "connects", 2.0, true));
    graph.addEdge(new Edge("A", "C", "connects", 4.0, true));
    graph.addEdge(new Edge("C", "D", "connects", 1.0, true));
    
    assert(graph.edgeCount() == 4);
    
    // Test BFS
    auto bfs = new BreadthFirstTraversal(graph);
    auto bfsPath = bfs.traverse("A");
    assert(bfsPath.length == 4);
    
    // Test DFS
    auto dfs = new DepthFirstTraversal(graph);
    auto dfsPath = dfs.traverse("A");
    assert(dfsPath.length == 4);
    
    // Test Dijkstra
    auto dijkstra = new Dijkstra(graph);
    auto shortestPath = dijkstra.findShortest("A", "D");
    assert(shortestPath.nodes.length > 0);
    assert(shortestPath.distance == 4.0);
    
    // Test node properties
    auto nodeA = graph.getNode("A");
    nodeA.setData("color", Variant("red"));
    assert(nodeA.data()["color"].get!string() == "red");
    
    // Test edge retrieval
    auto edge = graph.getEdge("A", "B");
    assert(edge !is null);
    assert(edge.weight() == 1.0);
    
    writeln("All graph tests passed!");
}
