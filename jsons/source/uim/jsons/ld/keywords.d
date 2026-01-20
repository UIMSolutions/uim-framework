/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.ld.keywords;

@safe:

/**
 * JSON-LD keywords as defined in the specification.
 */
struct JSONLDKeywords {
  // Core keywords
  static immutable string context = "@context";
  static immutable string id = "@id";
  static immutable string type = "@type";
  static immutable string value = "@value";
  static immutable string language = "@language";
  static immutable string graph = "@graph";
  static immutable string list = "@list";
  static immutable string set = "@set";
  static immutable string reverse = "@reverse";
  static immutable string index = "@index";
  
  // Container keywords
  static immutable string container = "@container";
  
  // Vocabulary keywords
  static immutable string vocab = "@vocab";
  static immutable string base = "@base";
  
  // Framing keywords
  static immutable string embed = "@embed";
  static immutable string explicit = "@explicit";
  static immutable string default_ = "@default";
  static immutable string omitDefault = "@omitDefault";
  
  // Processing keywords
  static immutable string nest = "@nest";
  static immutable string protected_ = "@protected";
  static immutable string _version = "@version";
  
  /**
   * Check if a string is a JSON-LD keyword.
   */
  static bool isKeyword(string str) {
    return str.length > 0 && str[0] == '@';
  }
  
  /**
   * Check if a string is a core keyword.
   */
  static bool isCoreKeyword(string str) {
    switch (str) {
      case context, id, type, value, language, graph, list, set, reverse, index:
        return true;
      default:
        return false;
    }
  }
}
