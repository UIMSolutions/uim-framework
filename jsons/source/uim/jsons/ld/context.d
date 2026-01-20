/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.context;

import uim.jsons;

@safe:

/**
 * JSON-LD context definition.
 */
class DJSONLDContext : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected Json _context;
  protected string _vocab;
  protected string _base;
  protected string[string] _terms;
  protected string[string] _prefixes;

  this() {
    super();
    _context = Json.emptyObject;
  }

  this(Json context) {
    this();
    _context = context;
    processContext();
  }

  // Getters
  Json context() { return _context; }
  string vocab() { return _vocab; }
  string base() { return _base; }

  // Setters
  void vocab(string value) { 
    _vocab = value;
    _context[JSONLDKeywords.vocab] = value;
  }
  
  void base(string value) { 
    _base = value;
    _context[JSONLDKeywords.base] = value;
  }

  /**
   * Add a term mapping.
   */
  DJSONLDContext addTerm(string term, string iri) {
    _terms[term] = iri;
    _context[term] = iri;
    return this;
  }

  /**
   * Add a prefix mapping.
   */
  DJSONLDContext addPrefix(string prefix, string iri) {
    _prefixes[prefix] = iri;
    _context[prefix] = iri;
    return this;
  }

  /**
   * Get IRI for a term.
   */
  string getTerm(string term) {
    if (auto iri = term in _terms) {
      return *iri;
    }
    return term;
  }

  /**
   * Check if term exists.
   */
  bool hasTerm(string term) {
    return (term in _terms) !is null;
  }

  /**
   * Expand a compact IRI or term.
   */
  string expand(string compactIri) {
    // Check if it's a term
    if (auto expanded = compactIri in _terms) {
      return *expanded;
    }

    // Check for prefix:suffix pattern
    auto colonPos = compactIri.indexOf(":");
    if (colonPos > 0) {
      auto prefix = compactIri[0 .. colonPos];
      auto suffix = compactIri[colonPos + 1 .. $];
      
      if (auto prefixIri = prefix in _prefixes) {
        return *prefixIri ~ suffix;
      }
    }

    // Check if it's already absolute
    if (compactIri.startsWith("http://") || compactIri.startsWith("https://")) {
      return compactIri;
    }

    // Apply vocab if set
    if (_vocab.length > 0) {
      return _vocab ~ compactIri;
    }

    return compactIri;
  }

  /**
   * Process context object.
   */
  protected void processContext() {
    if (_context.type != Json.Type.object) {
      return;
    }

    foreach (string key, value; _context.get!(Json[string])) {
      if (key == JSONLDKeywords.vocab) {
        _vocab = value.get!string;
      } else if (key == JSONLDKeywords.base) {
        _base = value.get!string;
      } else if (value.type == Json.Type.string) {
        _terms[key] = value.get!string;
        
        // Check if it's a prefix (ends with :)
        if (key.endsWith(":")) {
          _prefixes[key[0 .. $ - 1]] = value.get!string;
        }
      }
    }
  }

  /**
   * Merge with another context.
   */
  DJSONLDContext merge(DJSONLDContext other) {
    auto merged = new DJSONLDContext();
    
    // Copy this context
    foreach (key, value; _terms) {
      merged._terms[key] = value;
    }
    foreach (key, value; _prefixes) {
      merged._prefixes[key] = value;
    }
    merged._vocab = _vocab;
    merged._base = _base;
    
    // Merge other context
    foreach (key, value; other._terms) {
      merged._terms[key] = value;
    }
    foreach (key, value; other._prefixes) {
      merged._prefixes[key] = value;
    }
    if (other._vocab.length > 0) {
      merged._vocab = other._vocab;
    }
    if (other._base.length > 0) {
      merged._base = other._base;
    }
    
    return merged;
  }

  /**
   * Convert to JSON.
   */
  Json toJson() {
    return _context;
  }
}

unittest {
  auto ctx = new DJSONLDContext();
  ctx.vocab("http://schema.org/");
  ctx.addTerm("name", "http://schema.org/name");
  ctx.addPrefix("ex", "http://example.com/");
  
  assert(ctx.expand("name") == "http://schema.org/name");
  assert(ctx.expand("ex:foo") == "http://example.com/foo");
}
