/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.types;

@safe:

/**
 * Common XSD datatypes used in JSON-LD.
 */
struct XSDTypes {
  static immutable string string_ = "http://www.w3.org/2001/XMLSchema#string";
  static immutable string boolean = "http://www.w3.org/2001/XMLSchema#boolean";
  static immutable string integer = "http://www.w3.org/2001/XMLSchema#integer";
  static immutable string double_ = "http://www.w3.org/2001/XMLSchema#double";
  static immutable string float_ = "http://www.w3.org/2001/XMLSchema#float";
  static immutable string date = "http://www.w3.org/2001/XMLSchema#date";
  static immutable string dateTime = "http://www.w3.org/2001/XMLSchema#dateTime";
  static immutable string time = "http://www.w3.org/2001/XMLSchema#time";
  static immutable string anyURI = "http://www.w3.org/2001/XMLSchema#anyURI";
}

/**
 * Common RDF types used in JSON-LD.
 */
struct RDFTypes {
  static immutable string langString = "http://www.w3.org/1999/02/22-rdf-syntax-ns#langString";
  static immutable string JSON = "http://www.w3.org/1999/02/22-rdf-syntax-ns#JSON";
  static immutable string XMLLiteral = "http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral";
}

/**
 * Common container types in JSON-LD.
 */
enum ContainerType : string {
  list = "@list",
  set = "@set",
  language = "@language",
  index = "@index",
  id = "@id",
  type = "@type",
  graph = "@graph"
}
