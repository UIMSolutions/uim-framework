/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.graphs.interfaces.graph;

import uim.graphs.interfaces.node;
import uim.graphs.interfaces.edge;

interface IGraph {
    /// Add a node to the graph
    void addNode(INode node) @safe;
    
    /// Get node by ID
    INode getNode(string id) @safe;
    
    /// Check if node exists
    bool hasNode(string id) const @safe;
    
    /// Remove node by ID
    void removeNode(string id) @safe;
    
    /// Get all nodes
    INode[] nodes() @safe;
    
    /// Add an edge between nodes
    void addEdge(IEdge edge) @safe;
    
    /// Get edge from source to target
    IEdge getEdge(string source, string target) @safe;
    
    /// Check if edge exists
    bool hasEdge(string source, string target) const @safe;
    
    /// Remove edge
    void removeEdge(string source, string target) @safe;
    
    /// Get all edges from a node
    IEdge[] edgesFrom(string nodeId) @safe;
    
    /// Get all edges to a node
    IEdge[] edgesTo(string nodeId) @safe;
    
    /// Get all edges
    IEdge[] edges() @safe;
    
    /// Get total node count
    @property size_t nodeCount() const @safe;
    
    /// Get total edge count
    @property size_t edgeCount() const @safe;
    
    /// Check if graph is empty
    @property bool empty() const @safe;
    
    /// Clear entire graph
    void clear() @safe;
}
