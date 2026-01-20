/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.builder;

import uim.jsons;

@safe:

/**
 * Fluent builder for JSON-LD documents.
 */
class DJSONLDBuilder : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected DJSONLDDocument _document;
  protected DJSONLDNode _currentNode;

  this() {
    super();
    _document = new DJSONLDDocument();
  }

  /**
   * Set vocabulary.
   */
  DJSONLDBuilder vocab(string vocab) {
    _document.context.vocab(vocab);
    return this;
  }

  /**
   * Set base IRI.
   */
  DJSONLDBuilder base(string base) {
    _document.context.base(base);
    return this;
  }

  /**
   * Add term to context.
   */
  DJSONLDBuilder term(string term, string iri) {
    _document.context.addTerm(term, iri);
    return this;
  }

  /**
   * Add prefix to context.
   */
  DJSONLDBuilder prefix(string prefix, string iri) {
    _document.context.addPrefix(prefix, iri);
    return this;
  }

  /**
   * Start a new node.
   */
  DJSONLDBuilder node(string id = "") {
    _currentNode = new DJSONLDNode(id);
    _document.addNode(_currentNode);
    return this;
  }

  /**
   * Add type to current node.
   */
  DJSONLDBuilder type(string type) {
    if (_currentNode is null) {
      node();
    }
    _currentNode.addType(type);
    return this;
  }

  /**
   * Add property to current node.
   */
  DJSONLDBuilder property(string name, Json value) {
    if (_currentNode is null) {
      node();
    }
    _currentNode.set(name, value);
    return this;
  }

  /**
   * Add string property.
   */
  DJSONLDBuilder property(string name, string value) {
    return property(name, Json(value));
  }

  /**
   * Add integer property.
   */
  DJSONLDBuilder property(string name, long value) {
    return property(name, Json(value));
  }

  /**
   * Add boolean property.
   */
  DJSONLDBuilder property(string name, bool value) {
    return property(name, Json(value));
  }

  /**
   * Build the document.
   */
  DJSONLDDocument build() {
    return _document;
  }

  /**
   * Get JSON representation.
   */
  Json toJson() {
    return _document.toJson();
  }

  /**
   * Get string representation.
   */
  override string toString() const @trusted {
    return (cast(DJSONLDBuilder)this)._document.toString();
  }
}

// Convenience function
DJSONLDBuilder jsonld() {
  return new DJSONLDBuilder();
}

unittest {
  auto doc = jsonld()
    .vocab("http://schema.org/")
    .node("http://example.com/person/1")
      .type("Person")
      .property("name", "John Doe")
      .property("age", 30)
    .build();
  
  assert(doc.context.vocab == "http://schema.org/");
  assert(doc.graph.count() == 1);
}
