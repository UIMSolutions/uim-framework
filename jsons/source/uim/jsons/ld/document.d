/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.document;

import uim.jsons;

@safe:

/**
 * Complete JSON-LD document.
 */
class DJSONLDDocument : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected DJSONLDContext _context;
  protected DJSONLDGraph _graph;

  this() {
    super();
    _context = new DJSONLDContext();
    _graph = new DJSONLDGraph();
  }

  // Getters
  DJSONLDContext context() { return _context; }
  DJSONLDGraph graph() { return _graph; }

  // Setters
  void context(DJSONLDContext value) { _context = value; }
  void graph(DJSONLDGraph value) { _graph = value; }

  /**
   * Add a node to the document.
   */
  DJSONLDDocument addNode(DJSONLDNode node) {
    _graph.addNode(node);
    return this;
  }

  /**
   * Get a node by ID.
   */
  DJSONLDNode getNode(string id) {
    return _graph.getNode(id);
  }

  /**
   * Convert to JSON-LD format.
   */
  Json toJson() {
    auto result = Json.emptyObject;
    
    // Add context
    if (_context.context.type != Json.Type.object || 
        _context.context.get!(Json[string]).length > 0) {
      result[JSONLDKeywords.context] = _context.toJson();
    }
    
    // Add graph
    auto graphJson = _graph.toJson();
    
    if (graphJson.type == Json.Type.array) {
      auto arr = graphJson.get!(Json[]);
      if (arr.length == 1) {
        // Single node - merge into document
        auto nodeObj = arr[0].get!(Json[string]);
        foreach (key, value; nodeObj) {
          result[key] = value;
        }
      } else {
        // Multiple nodes - use @graph
        result[JSONLDKeywords.graph] = graphJson;
      }
    } else if (graphJson.type == Json.Type.object) {
      auto obj = graphJson.get!(Json[string]);
      foreach (key, value; obj) {
        result[key] = value;
      }
    }
    
    return result;
  }

  /**
   * Convert to string (pretty printed).
   */
  override string toString() const @trusted {
    return (cast(DJSONLDDocument)this).toJson().toPrettyString();
  }

  /**
   * Convert to compact string.
   */
  string toCompactString() {
    return toJson().toString();
  }

  /**
   * Create from JSON string.
   */
  static DJSONLDDocument parse(string jsonStr) {
    auto json = parseJsonString(jsonStr);
    return fromJson(json);
  }

  /**
   * Create from JSON.
   */
  static DJSONLDDocument fromJson(Json json) {
    auto doc = new DJSONLDDocument();
    
    if (json.type != Json.Type.object) {
      throw new InvalidDocumentException("Document must be an object");
    }
    
    auto obj = json.get!(Json[string]);
    
    // Extract context
    if (auto contextValue = JSONLDKeywords.context in obj) {
      doc._context = new DJSONLDContext(*contextValue);
    }
    
    // Extract graph
    if (auto graphValue = JSONLDKeywords.graph in obj) {
      doc._graph = DJSONLDGraph.fromJson(*graphValue);
    } else {
      // Single node or implicit graph
      auto node = DJSONLDNode.fromJson(json);
      doc._graph.addNode(node);
    }
    
    return doc;
  }

  /**
   * Load from file.
   */
  static DJSONLDDocument loadFile(string filePath) {
    import std.file : readText;
    
    try {
      string content = readText(filePath);
      return parse(content);
    } catch (Exception e) {
      throw new JSONLDException("Failed to load file: " ~ filePath ~ " - " ~ e.msg);
    }
  }

  /**
   * Save to file.
   */
  void saveFile(string filePath, bool pretty = true) {
    import std.file : write;
    
    try {
      string content = pretty ? toString() : toCompactString();
      std.file.write(filePath, content);
    } catch (Exception e) {
      throw new JSONLDException("Failed to save file: " ~ filePath ~ " - " ~ e.msg);
    }
  }
}

unittest {
  auto doc = new DJSONLDDocument();
  doc.context.vocab("http://schema.org/");
  
  auto person = new DJSONLDNode("http://example.com/person/1");
  person.addType("Person");
  person.set("name", "John Doe");
  
  doc.addNode(person);
  
  auto json = doc.toJson();
  assert(JSONLDKeywords.context in json);
}
