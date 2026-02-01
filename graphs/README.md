# UIM Graphs

Updated on 1. February 2026


A graph/network modeling library for D that supports entities (nodes), relationships (edges), and common graph algorithms like BFS, DFS, and Dijkstra's shortest path.

## Features

✅ **Type-Safe Nodes & Edges** - INode and IEdge interfaces with metadata support
✅ **Directed & Undirected** - Configure edges as directed or undirected
✅ **Weighted Graphs** - Edges support custom weights for algorithm use
✅ **Graph Queries** - Fast node/edge lookup and adjacency queries
✅ **BFS/DFS Traversal** - Breadth-first and depth-first graph traversal
✅ **Dijkstra's Algorithm** - Find shortest paths with weighted edges
✅ **Node/Edge Metadata** - Store arbitrary key-value data on entities
✅ **Relationship Management** - Add, remove, query edges between nodes
✅ **@safe Throughout** - Type-safe @safe attributes
✅ **vibe.d Compatible** - Integrates seamlessly with vibe.d projects

## Installation

Add to your `dub.sdl`:

```
dependency "uim-graphs" version="~master"
```

## Quick Start

### Create Nodes and Edges

```d
import uim.graphs;
import uim.graphs.core.node : Node;
import uim.graphs.core.edge : Edge;
import uim.graphs.core.graph : Graph;

auto graph = new Graph();

// Create nodes (entities)
graph.addNode(new Node("alice", "Alice"));
graph.addNode(new Node("bob", "Bob"));
graph.addNode(new Node("charlie", "Charlie"));

// Create relationships (edges)
graph.addEdge(new Edge("alice", "bob", "knows", 1.0, false));
graph.addEdge(new Edge("bob", "charlie", "knows", 1.0, false));

assert(graph.nodeCount() == 3);
assert(graph.edgeCount() == 2);
```

### Add Metadata

```d
import std.variant : Variant;

auto alice = graph.getNode("alice");
alice.setData("age", Variant(30));
alice.setData("city", Variant("NYC"));

auto edge = graph.getEdge("alice", "bob");
edge.setData("since", Variant(2020));
```

### Graph Traversal

```d
import uim.graphs.algorithms.traversal;

// BFS traversal
auto bfs = new BreadthFirstTraversal(graph);
auto visited = bfs.traverse("alice");
foreach (id; visited) {
    writeln("Visited: ", id);
}

// DFS traversal
auto dfs = new DepthFirstTraversal(graph);
auto depthPath = dfs.traverse("alice");
```

### Find Shortest Path

```d
import uim.graphs.algorithms.pathfinding : Dijkstra;

// Create weighted graph
auto graph = new Graph();
graph.addNode(new Node("A"));
graph.addNode(new Node("B"));
graph.addNode(new Node("C"));
graph.addNode(new Node("D"));

graph.addEdge(new Edge("A", "B", "", 1.0, true));
graph.addEdge(new Edge("B", "C", "", 2.0, true));
graph.addEdge(new Edge("A", "C", "", 4.0, true));
graph.addEdge(new Edge("C", "D", "", 1.0, true));

auto dijkstra = new Dijkstra(graph);
auto path = dijkstra.findShortest("A", "D");

writeln("Path: ", path.nodes);  // [A, B, C, D]
writeln("Distance: ", path.distance);  // 4.0
```

### Query Graph Structure

```d
// Check existence
assert(graph.hasNode("alice"));
assert(graph.hasEdge("alice", "bob"));

// Get neighbors
auto edges = graph.edgesFrom("alice");
foreach (e; edges) {
    writeln("Connected to: ", e.target());
}

// Get connected relationships
auto incoming = graph.edgesTo("bob");
auto outgoing = graph.edgesFrom("bob");
```

## Architecture

### Modules

- **interfaces/** - INode, IEdge, IGraph, ITraversal contracts
- **core/** - Node, Edge, Graph implementations
- **algorithms/** - Traversal (BFS, DFS) and pathfinding (Dijkstra)

### Key Classes

- **Node** - Entity with ID, label, and metadata
- **Edge** - Relationship with source, target, weight, label, directed flag, and metadata
- **Graph** - Container managing nodes and edges with O(1) lookups
- **BreadthFirstTraversal** - Level-by-level graph exploration
- **DepthFirstTraversal** - Recursive depth-first exploration
- **Dijkstra** - Shortest path finder for weighted graphs

## Design Patterns

1. **Interface Segregation** - Separate contracts for nodes, edges, graphs, traversal
2. **Strategy Pattern** - Multiple traversal algorithms (BFS, DFS, Dijkstra)
3. **Composite Pattern** - Graphs compose nodes and edges
4. **Visitor Pattern** - Traversal visitors for node processing
5. **Decorator Pattern** - Metadata attached to nodes and edges

## Performance

- **Node Lookup**: O(1) via associative array
- **Edge Lookup**: O(e) linear scan through edges
- **BFS**: O(n + e) where n=nodes, e=edges
- **DFS**: O(n + e) via recursive traversal
- **Dijkstra**: O((n + e) log n) with priority queue (simplified: O(n²))

## Type Safety

All operations use @safe attribute enforcement:

```d
// Type-safe graph construction
auto edge = new Edge("alice", "bob", "knows", 1.0, false);
graph.addEdge(edge);  // Type-checked

// Type-safe metadata
alice.setData("age", Variant(30));
auto age = alice.data()["age"].get!int();
```

## Testing

```bash
cd graphs
dub test
```

## Examples

See `examples/` for complete usage examples:
- Social network modeling
- Knowledge graphs
- Workflow graphs
- Network routing

## Notes

- **Directed vs Undirected**: Set Edge `directed` flag to control directionality
- **Weighted Edges**: Use edge weight for algorithms (default 1.0)
- **Node Degree**: Automatically maintained as edges are added/removed
- **Disconnected Graphs**: Supported; traversals only visit connected components
- **Self-Loops**: Allowed (edge from node to itself)
- **Duplicate Edges**: Not automatically prevented; manually manage if needed
- **Memory**: Edges stored in dynamic array; consider for very large graphs (millions of edges)

## License

Apache 2.0
