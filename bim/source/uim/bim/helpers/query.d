/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.helpers.query;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * BimQuery - Utility functions for filtering and querying collections of BIM elements.
 */
struct BimQuery {
@safe:
  /**
   * Filter elements by IFC class name.
   * Example: BimQuery.byIfcClass(elements, "IfcWall")
   */
  static IBimElement[] byIfcClass(IBimElement[] elements, string ifcClassName) {
    import std.algorithm : filter;
    import std.array : array;
    return elements.filter!(e => e.ifcClass() == ifcClassName).array;
  }

  /**
   * Filter elements by name (case-sensitive substring match).
   */
  static IBimElement[] byName(IBimElement[] elements, string nameFragment) {
    import std.algorithm : filter;
    import std.string : indexOf;
    import std.array : array;
    return elements.filter!(e => e.name().indexOf(nameFragment) >= 0).array;
  }

  /**
   * Filter elements that carry a specific classification code.
   */
  static IBimElement[] byClassification(IBimElement[] elements, string code) {
    import std.algorithm : filter, canFind;
    import std.array : array;
    return elements.filter!(e => e.classifications().canFind(code)).array;
  }

  /**
   * Find a single element by its globalId. Returns null if not found.
   */
  static IBimElement byGlobalId(IBimElement[] elements, string globalId) {
    foreach (e; elements) {
      if (e.globalId() == globalId) return e;
    }
    return null;
  }

  /**
   * Collect all elements that have a specific property key set.
   */
  static IBimElement[] withProperty(IBimElement[] elements, string propertyKey) {
    import std.algorithm : filter;
    import std.array : array;
    return elements.filter!(e => e.hasProperty(propertyKey)).array;
  }
}
