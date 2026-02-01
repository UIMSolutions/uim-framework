/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.ld.graph;

import uim.jsons;

@safe:

/**
 * Json-LD graph containing multiple nodes.
 */
class JsonLDGraph : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected string _id;
  protected JsonLDNode[string] _nodes;

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
  JsonLDGraph addNode(JsonLDNode node) {
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
  JsonLDNode getNode(string id) {
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
  JsonLDNode[] nodes() {
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
  JsonLDNode[] findByType(string type) {
    JsonLDNode[] result;
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
   * Convert to Json-LD format.
   */
  Json toJson() {
    Json[] graphArray;
    
    foreach (node; _nodes.values) {
      graphArray ~= node.toJson();
    }
    
    if (_id.length > 0) {
      auto result = Json.emptyObject;
      result[JsonLDKeywords.id] = _id;
      result[JsonLDKeywords.graph] = Json(graphArray);
      return result;
    }
    
    return Json(graphArray);
  }

  /**
   * Create from Json.
   */
  static JsonLDGraph fromJson(Json json) {
    auto graph = new JsonLDGraph();
    
    if (json.isArray) {
      // Array of nodes
      foreach (item; json.toArray) {
        graph.addNode(JsonLDNode.fromJson(item));
      }
    } else if (json.isObject) {
      auto obj = json.get!(Json[string]);
      
      // Check for @id
      if (auto iUIMValue = JsonLDKeywords.id in obj) {
        graph._id = iUIMValue.get!string;
      }
      
      // Check for @graph
      if (auto graphValue = JsonLDKeywords.graph in obj) {
        if ((*graphValue).isArray) {
          foreach (item; (*graphValue).toArray) {
            graph.addNode(JsonLDNode.fromJson(item));
          }
        }
      }
    }
    
    return graph;
  }
}

unittest {
  auto graph = new JsonLDGraph();
  
  auto person = new JsonLDNode("http://example.com/person/1");
  person.addType("http://schema.org/Person");
  person.set("name", "John Doe");
  
  graph.addNode(person);
  
  assert(graph.count() == 1);
  assert(graph.hasNode("http://example.com/person/1"));
}
