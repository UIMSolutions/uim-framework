/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.ld.builder;

import uim.jsons;

@safe:

/**
 * Fluent builder for Json-LD documents.
 */
class JsonLDBuilder : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected JsonLDDocument _document;
  protected JsonLDNode _currentNode;

  this() {
    super();
    _document = new JsonLDDocument();
  }

  /**
   * Set vocabulary.
   */
  JsonLDBuilder vocab(string vocab) {
    _document.context.vocab(vocab);
    return this;
  }

  /**
   * Set base IRI.
   */
  JsonLDBuilder base(string base) {
    _document.context.base(base);
    return this;
  }

  /**
   * Add term to context.
   */
  JsonLDBuilder term(string term, string iri) {
    _document.context.addTerm(term, iri);
    return this;
  }

  /**
   * Add prefix to context.
   */
  JsonLDBuilder prefix(string prefix, string iri) {
    _document.context.addPrefix(prefix, iri);
    return this;
  }

  /**
   * Start a new node.
   */
  JsonLDBuilder node(string id = "") {
    _currentNode = new JsonLDNode(id);
    _document.addNode(_currentNode);
    return this;
  }

  /**
   * Add type to current node.
   */
  JsonLDBuilder type(string type) {
    if (_currentNode is null) {
      node();
    }
    _currentNode.addType(type);
    return this;
  }

  /**
   * Add property to current node.
   */
  JsonLDBuilder property(string name, Json value) {
    if (_currentNode is null) {
      node();
    }
    _currentNode.set(name, value);
    return this;
  }

  /**
   * Add string property.
   */
  JsonLDBuilder property(string name, string value) {
    return property(name, Json(value));
  }

  /**
   * Add integer property.
   */
  JsonLDBuilder property(string name, long value) {
    return property(name, Json(value));
  }

  /**
   * Add boolean property.
   */
  JsonLDBuilder property(string name, bool value) {
    return property(name, Json(value));
  }

  /**
   * Build the document.
   */
  JsonLDDocument build() {
    return _document;
  }

  /**
   * Get Json representation.
   */
  Json toJson() {
    return _document.toJson();
  }

  /**
   * Get string representation.
   */
  override string toString() const @trusted {
    return (cast(JsonLDBuilder)this)._document.toString();
  }
}

// Convenience function
JsonLDBuilder jsonld() {
  return new JsonLDBuilder();
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
