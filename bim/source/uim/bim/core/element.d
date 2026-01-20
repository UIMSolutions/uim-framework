/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.core.element;

import uim.bim;

@safe:

/**
 * Base class for all BIM elements.
 * Provides common functionality for building elements.
 */
class DBIMElement : UIMObject, IBIMElement {
  protected string _guid;
  protected string _elementType;
  protected IBIMProperty[string] _properties;
  protected IBIMGeometry _geometry;

  this() {
    super();
    generateGUID();
  }

  this(string elementType) {
    this();
    _elementType = elementType;
  }

  /**
   * Generate a new GUID for this element.
   */
  protected void generateGUID() {
    import std.uuid : randomUUID;
    _guid = randomUUID().toString();
  }

  string guid() {
    return _guid;
  }

  void guid(string value) {
    _guid = value;
  }

  string elementType() {
    return _elementType;
  }

  IBIMProperty[] properties() {
    return _properties.values;
  }

  void addProperty(IBIMProperty property) {
    if (property !is null) {
      _properties[property.name] = property;
    }
  }

  IBIMProperty getProperty(string name) {
    return _properties.get(name, null);
  }

  IBIMGeometry geometry() {
    return _geometry;
  }

  void geometry(IBIMGeometry geom) {
    _geometry = geom;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto guid = "guid" in initData) {
      _guid = guid.get!string;
    }

    if (auto elementType = "elementType" in initData) {
      _elementType = elementType.get!string;
    }

    return true;
  }
}

unittest {
  auto element = new DBIMElement("Wall");
  assert(element !is null);
  assert(element.guid.length > 0);
  assert(element.elementType == "Wall");
}
