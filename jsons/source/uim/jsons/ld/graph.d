/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.graph;

import uim.jsons;

@safe:

/**
 * JSON-LD graph containing multiple nodes.
 */
class DJSONLDGraph : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _id;
  protected DJSONLDNode[string] _nodes;

  this() {
    super();
  }

  this(string id) {
    this();
    _id = id;
  }

  // Getters
  string id() { return _id; }

  // Setters
  void id(string value) { _id = value; }

  /**
   * Add a node to the graph.
   */
  DJSONLDGraph addNode(DJSONLDNode node) {
    if (node.id.length > 0) {
      _nodes[node.id] = node;
    } else {
      // Generate blank node ID
      auto blankId = "_:b" ~ _nodes.length.to!string;
      node.id(blankId);
      _nodes[blankId] = node;
    }
    return this;
  }

  /**
   * Get a node by ID.
   */
  DJSONLDNode getNode(string id) {
    if (auto node = id in _nodes) {
      return *node;
    }
    return null;
  }

  /**
   * Check if node exists.
   */
  bool hasNode(string id) {
    return (id in _nodes) !is null;
  }

  /**
   * Remove a node.
   */
  bool removeNode(string id) {
    if (id in _nodes) {
      _nodes.remove(id);
      return true;
    }
    return false;
  }

  /**
   * Get all node IDs.
   */
  string[] nodeIds() {
    return _nodes.keys;
  }

  /**
   * Get all nodes.
   */
  DJSONLDNode[] nodes() {
    return _nodes.values;
  }

  /**
   * Get number of nodes.
   */
  size_t count() {
    return _nodes.length;
  }

  /**
   * Clear all nodes.
   */
  void clear() {
    _nodes.clear();
  }

  /**
   * Find nodes by type.
   */
  DJSONLDNode[] findByType(string type) {
    DJSONLDNode[] result;
    foreach (node; _nodes.values) {
      foreach (nodeType; node.types()) {
        if (nodeType == type) {
          result ~= node;
          break;
        }
      }
    }
    return result;
  }

  /**
   * Convert to JSON-LD format.
   */
  Json toJson() {
    Json[] graphArray;
    
    foreach (node; _nodes.values) {
      graphArray ~= node.toJson();
    }
    
    if (_id.length > 0) {
      auto result = Json.emptyObject;
      result[JSONLDKeywords.id] = _id;
      result[JSONLDKeywords.graph] = Json(graphArray);
      return result;
    }
    
    return Json(graphArray);
  }

  /**
   * Create from JSON.
   */
  static DJSONLDGraph fromJson(Json json) {
    auto graph = new DJSONLDGraph();
    
    if (json.type == Json.Type.array) {
      // Array of nodes
      foreach (item; json.get!(Json[])) {
        graph.addNode(DJSONLDNode.fromJson(item));
      }
    } else if (json.type == Json.Type.object) {
      auto obj = json.get!(Json[string]);
      
      // Check for @id
      if (auto idValue = JSONLDKeywords.id in obj) {
        graph._id = idValue.get!string;
      }
      
      // Check for @graph
      if (auto graphValue = JSONLDKeywords.graph in obj) {
        if (graphValue.type == Json.Type.array) {
          foreach (item; graphValue.get!(Json[])) {
            graph.addNode(DJSONLDNode.fromJson(item));
          }
        }
      }
    }
    
    return graph;
  }
}

unittest {
  auto graph = new DJSONLDGraph();
  
  auto person = new DJSONLDNode("http://example.com/person/1");
  person.addType("http://schema.org/Person");
  person.set("name", "John Doe");
  
  graph.addNode(person);
  
  assert(graph.count() == 1);
  assert(graph.hasNode("http://example.com/person/1"));
}
