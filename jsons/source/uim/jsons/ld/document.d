/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.ld.document;

import uim.jsons;

@safe:

/**
 * Complete Json-LD document.
 */
class JsonLDDocument : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected JsonLDContext _context;
  protected JsonLDGraph _graph;

  this() {
    super();
    _context = new JsonLDContext();
    _graph = new JsonLDGraph();
  }

  // Getters
  JsonLDContext context() { return _context; }
  JsonLDGraph graph() { return _graph; }

  // Setters
  void context(JsonLDContext value) { _context = value; }
  void graph(JsonLDGraph value) { _graph = value; }

  /**
   * Add a node to the document.
   */
  JsonLDDocument addNode(JsonLDNode node) {
    _graph.addNode(node);
    return this;
  }

  /**
   * Get a node by ID.
   */
  JsonLDNode getNode(string id) {
    return _graph.getNode(id);
  }

  /**
   * Convert to Json-LD format.
   */
  override Json toJson() {
    auto result = Json.emptyObject;
    
    // Add context
    if (!_context.context.isObject || 
        _context.context.toMap.length > 0) {
      result[JsonLDKeywords.context] = _context.toJson();
    }
    
    // Add graph
    auto graphJson = _graph.toJson();
    
    if (graphJson.isArray) {
      auto arr = graphJson.toArray;
      if (arr.length == 1) {
        // Single node - merge into document
        auto nodeObj = arr[0].get!(Json[string]);
        foreach (key, value; nodeObj) {
          result[key] = value;
        }
      } else {
        // Multiple nodes - use @graph
        result[JsonLDKeywords.graph] = graphJson;
      }
    } else if (graphJson.isObject) {
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
    return (cast(JsonLDDocument)this).toJson().toPrettyString();
  }

  /**
   * Convert to compact string.
   */
  string toCompactString() {
    return toJson().toString();
  }

  /**
   * Create from Json string.
   */
  static JsonLDDocument parse(string jsonStr) {
    auto json = parseJsonString(jsonStr);
    return fromJson(json);
  }

  /**
   * Create from Json.
   */
  static JsonLDDocument fromJson(Json json) {
    auto doc = new JsonLDDocument();
    
    if (json.type != Json.Type.object) {
      throw new InvalidDocumentException("Document must be an object");
    }
    
    auto obj = json.get!(Json[string]);
    
    // Extract context
    if (auto contextValue = JsonLDKeywords.context in obj) {
      doc._context = new JsonLDContext(*contextValue);
    }
    
    // Extract graph
    if (auto graphValue = JsonLDKeywords.graph in obj) {
      doc._graph = JsonLDGraph.fromJson(*graphValue);
    } else {
      // Single node or implicit graph
      auto node = JsonLDNode.fromJson(json);
      doc._graph.addNode(node);
    }
    
    return doc;
  }

  /**
   * Load from file.
   */
  static JsonLDDocument loadFile(string filePath) {
    import std.file : readText;
    
    try {
      string content = readText(filePath);
      return parse(content);
    } catch (Exception e) {
      throw new JsonLDException("Failed to load file: " ~ filePath ~ " - " ~ e.msg);
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
      throw new JsonLDException("Failed to save file: " ~ filePath ~ " - " ~ e.msg);
    }
  }
}

unittest {
  auto doc = new JsonLDDocument();
  doc.context.vocab("http://schema.org/");
  
  auto person = new JsonLDNode("http://example.com/person/1");
  person.addType("Person");
  person.set("name", "John Doe");
  
  doc.addNode(person);
  
  auto json = doc.toJson();
  assert(JsonLDKeywords.context in json);
}
