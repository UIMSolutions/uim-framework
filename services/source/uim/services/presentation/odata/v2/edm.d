/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.odata.v2.edm;

import uim.services;

mixin(ShowModule!());

@safe:

/// EDM primitive types (OData V2)
enum EdmType {
  binary,
  boolean,
  byte_,
  dateTime,
  dateTimeOffset,
  decimal,
  double_,
  guid,
  int16,
  int32,
  int64,
  sByte,
  single,
  string_,
  time
}

/// Converts an EDM type to its qualified name, e.g. EdmType.string_ -> "Edm.String"
string toString(EdmType type) {
  final switch (type) {
    case EdmType.binary: return "Edm.Binary";
    case EdmType.boolean: return "Edm.Boolean";
    case EdmType.byte_: return "Edm.Byte";
    case EdmType.dateTime: return "Edm.DateTime";
    case EdmType.dateTimeOffset: return "Edm.DateTimeOffset";
    case EdmType.decimal: return "Edm.Decimal";
    case EdmType.double_: return "Edm.Double";
    case EdmType.guid: return "Edm.Guid";
    case EdmType.int16: return "Edm.Int16";
    case EdmType.int32: return "Edm.Int32";
    case EdmType.int64: return "Edm.Int64";
    case EdmType.sByte: return "Edm.SByte";
    case EdmType.single: return "Edm.Single";
    case EdmType.string_: return "Edm.String";
    case EdmType.time: return "Edm.Time";
  }
}

/// A property of an EDM entity type.
class EdmProperty {
  this(string name, EdmType type) {
    _name = name;
    _type = type;
  }

  /// The property name
  string name() const {
    return _name;
  }

  /// The EDM type
  EdmType type() const {
    return _type;
  }

  /// Marks the property as non-nullable (fluent interface)
  auto notNullable(bool value = true) {
    _nullable = !value;
    return this;
  }

  /// Sets the maximum length for string properties (fluent interface)
  auto maxLength(int value) {
    _maxLength = value;
    return this;
  }

  /// Sets precision and scale for decimal properties (fluent interface)
  auto precisionScale(int precision, int scale) {
    _precision = precision;
    _scale = scale;
    return this;
  }

  /// Whether the property is nullable
  bool nullable() const {
    return _nullable;
  }

  /// Renders the property as a CSDL XML element
  override string toString() const {
    auto result = appender!string;
    result.put(`<Property Name="` ~ _name ~ `" Type="` ~ _type.toString ~ `"`);
    if (!_nullable) {
      result.put(` Nullable="false"`);
    }
    if (_maxLength > 0) {
      result.put(` MaxLength="` ~ _maxLength.to!string ~ `"`);
    }
    if (_precision > 0) {
      result.put(` Precision="` ~ _precision.to!string ~ `" Scale="` ~ _scale.to!string ~ `"`);
    }
    result.put("/>");
    return result.data;
  }

  private string _name;
  private EdmType _type;
  private bool _nullable = true;
  private int _maxLength;
  private int _precision;
  private int _scale;
}

/// Creates an EDM property, e.g. edmProperty("Name", EdmType.string_)
EdmProperty edmProperty(string name, EdmType type) {
  return new EdmProperty(name, type);
}

/// An EDM entity type with key and properties.
class EdmEntityType {
  this(string name) {
    _name = name;
  }

  /// The entity type name
  string name() const {
    return _name;
  }

  /// Adds a property (fluent interface)
  auto property(EdmProperty value) {
    _properties ~= value;
    return this;
  }

  /// Adds a property (fluent interface)
  auto property(string name, EdmType type) {
    return property(new EdmProperty(name, type));
  }

  /// Marks a property as the entity key (fluent interface)
  auto key(string propertyName) {
    _key = propertyName;
    return this;
  }

  /// The key property name
  string keyName() const {
    return _key;
  }

  /// All properties
  EdmProperty[] properties() {
    return _properties.dup;
  }

  /// Returns the property with the given name, null if absent
  EdmProperty findProperty(string name) {
    foreach (property; _properties) {
      if (property.name == name) {
        return property;
      }
    }
    return null;
  }

  /// Renders the entity type as a CSDL XML element
  override string toString() const {
    auto result = appender!string;
    result.put(`<EntityType Name="` ~ _name ~ `">`);
    if (_key.length > 0) {
      result.put("<Key><PropertyRef Name=\"" ~ _key ~ "\"/></Key>");
    }
    foreach (property; _properties) {
      result.put(property.toString);
    }
    result.put("</EntityType>");
    return result.data;
  }

  private string _name;
  private string _key;
  private EdmProperty[] _properties;
}

/// Creates an EDM entity type, e.g. edmEntityType("Product")
EdmEntityType edmEntityType(string name) {
  return new EdmEntityType(name);
}

/// An EDM entity set (a named collection of entities).
class EdmEntitySet {
  this(string name, EdmEntityType entityType) {
    _name = name;
    _entityType = entityType;
  }

  /// The entity set name, e.g. "Products"
  string name() const {
    return _name;
  }

  /// The entity type of the set
  EdmEntityType entityType() {
    return _entityType;
  }

  /// Renders the entity set as a CSDL XML element
  override string toString() const {
    return `<EntitySet Name="` ~ _name ~ `" EntityType="` ~ _entityType.name ~ `"/>`;
  }

  private string _name;
  private EdmEntityType _entityType;
}

/// Creates an EDM entity set, e.g. edmEntitySet("Products", productType)
EdmEntitySet edmEntitySet(string name, EdmEntityType entityType) {
  return new EdmEntitySet(name, entityType);
}

/// An EDM schema: entity types and entity sets, renderable as CSDL XML ($metadata).
class EdmSchema {
  this(string namespace) {
    _namespace = namespace;
  }

  /// The schema namespace, e.g. "MyService"
  string namespace() const {
    return _namespace;
  }

  /// Adds an entity type (fluent interface)
  auto entityType(EdmEntityType value) {
    _entityTypes[value.name] = value;
    if (!_typeOrder.canFind(value.name)) {
      _typeOrder ~= value.name;
    }
    return this;
  }

  /// Adds an entity set (fluent interface)
  auto entitySet(EdmEntitySet value) {
    _entitySets[value.name] = value;
    if (!_setOrder.canFind(value.name)) {
      _setOrder ~= value.name;
    }
    return this;
  }

  /// Returns the entity type with the given name, null if absent
  EdmEntityType findEntityType(string name) {
    auto found = name in _entityTypes;
    return found is null ? null : *found;
  }

  /// Returns the entity set with the given name, null if absent
  EdmEntitySet findEntitySet(string name) {
    auto found = name in _entitySets;
    return found is null ? null : *found;
  }

  /// All entity type names in insertion order
  string[] entityTypeNames() const {
    return _typeOrder.dup;
  }

  /// All entity set names in insertion order
  string[] entitySetNames() const {
    return _setOrder.dup;
  }

  /// Renders the schema as CSDL XML (the $metadata document body)
  override string toString() const {
    auto result = appender!string;
    result.put(`<Schema Namespace="` ~ _namespace ~ `" xmlns="http://schemas.microsoft.com/ado/2008/09/edm">`);
    foreach (name; _typeOrder) {
      result.put(_entityTypes[name].toString);
    }
    result.put(`<EntityContainer Name="Container">`);
    foreach (name; _setOrder) {
      result.put(_entitySets[name].toString);
    }
    result.put("</EntityContainer>");
    result.put("</Schema>");
    return result.data;
  }

  private string _namespace;
  private EdmEntityType[string] _entityTypes;
  private string[] _typeOrder;
  private EdmEntitySet[string] _entitySets;
  private string[] _setOrder;
}

/// Creates an EDM schema, e.g. edmSchema("MyService")
EdmSchema edmSchema(string namespace) {
  return new EdmSchema(namespace);
}

///
unittest {
  // type names
  assert(EdmType.string_.toString == "Edm.String");
  assert(EdmType.int32.toString == "Edm.Int32");
  assert(EdmType.dateTime.toString == "Edm.DateTime");

  // property
  auto name = edmProperty("Name", EdmType.string_).notNullable.maxLength(100);
  assert(name.name == "Name");
  assert(name.type == EdmType.string_);
  assert(!name.nullable);
  assert(name.toString == `<Property Name="Name" Type="Edm.String" Nullable="false" MaxLength="100"/>`);

  auto price = edmProperty("Price", EdmType.decimal).precisionScale(10, 2);
  assert(price.toString == `<Property Name="Price" Type="Edm.Decimal" Precision="10" Scale="2"/>`);

  auto optional = edmProperty("Description", EdmType.string_);
  assert(optional.nullable);
  assert(optional.toString == `<Property Name="Description" Type="Edm.String"/>`);

  // entity type
  auto product = edmEntityType("Product")
    .key("Id")
    .property("Id", EdmType.int32)
    .property(name)
    .property(price);
  assert(product.name == "Product");
  assert(product.keyName == "Id");
  assert(product.properties.length == 3);
  assert(product.findProperty("Name") !is null);
  assert(product.findProperty("missing") is null);
  assert(product.toString.canFind(`<EntityType Name="Product">`));
  assert(product.toString.canFind(`<Key><PropertyRef Name="Id"/></Key>`));

  // entity set
  auto products = edmEntitySet("Products", product);
  assert(products.name == "Products");
  assert(products.entityType is product);
  assert(products.toString == `<EntitySet Name="Products" EntityType="Product"/>`);

  // schema
  auto schema = edmSchema("MyService")
    .entityType(product)
    .entitySet(products);
  assert(schema.namespace == "MyService");
  assert(schema.findEntityType("Product") is product);
  assert(schema.findEntitySet("Products") is products);
  assert(schema.findEntityType("missing") is null);
  assert(schema.entityTypeNames == ["Product"]);
  assert(schema.entitySetNames == ["Products"]);

  string csdl = schema.toString;
  assert(csdl.canFind(`<Schema Namespace="MyService" xmlns="http://schemas.microsoft.com/ado/2008/09/edm">`));
  assert(csdl.canFind(`<EntityContainer Name="Container">`));
  assert(csdl.canFind(`<EntitySet Name="Products" EntityType="Product"/>`));
}
