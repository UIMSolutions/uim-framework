/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.odata.v4.edm;

import uim.service;

mixin(ShowModule!());

@safe:

/// EDM primitive types (OData V4)
enum EdmV4Type {
  binary,
  boolean,
  byte_,
  date,
  dateTimeOffset,
  decimal,
  double_,
  duration,
  guid,
  int16,
  int32,
  int64,
  sByte,
  single,
  stream,
  string_,
  timeOfDay
}

/// Converts an EDM V4 type to its qualified name, e.g. EdmV4Type.string_ -> "Edm.String"
string toString(EdmV4Type type) {
  final switch (type) {
    case EdmV4Type.binary: return "Edm.Binary";
    case EdmV4Type.boolean: return "Edm.Boolean";
    case EdmV4Type.byte_: return "Edm.Byte";
    case EdmV4Type.date: return "Edm.Date";
    case EdmV4Type.dateTimeOffset: return "Edm.DateTimeOffset";
    case EdmV4Type.decimal: return "Edm.Decimal";
    case EdmV4Type.double_: return "Edm.Double";
    case EdmV4Type.duration: return "Edm.Duration";
    case EdmV4Type.guid: return "Edm.Guid";
    case EdmV4Type.int16: return "Edm.Int16";
    case EdmV4Type.int32: return "Edm.Int32";
    case EdmV4Type.int64: return "Edm.Int64";
    case EdmV4Type.sByte: return "Edm.SByte";
    case EdmV4Type.single: return "Edm.Single";
    case EdmV4Type.stream: return "Edm.Stream";
    case EdmV4Type.string_: return "Edm.String";
    case EdmV4Type.timeOfDay: return "Edm.TimeOfDay";
  }
}

/// A structural property of an EDM V4 entity type.
class EdmV4Property {
  this(string name, EdmV4Type type) {
    _name = name;
    _type = type;
  }

  /// The property name
  string name() const {
    return _name;
  }

  /// The EDM type
  EdmV4Type type() const {
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

  /// Renders the property as a CSDL 4.0 XML element
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
  private EdmV4Type _type;
  private bool _nullable = true;
  private int _maxLength;
  private int _precision;
  private int _scale;
}

/// Creates an EDM V4 property, e.g. edmV4Property("Name", EdmV4Type.string_)
EdmV4Property edmV4Property(string name, EdmV4Type type) {
  return new EdmV4Property(name, type);
}

/// A navigation property of an EDM V4 entity type.
class EdmV4NavigationProperty {
  this(string name, string targetType, bool collection = false) {
    _name = name;
    _targetType = targetType;
    _collection = collection;
  }

  /// The navigation property name
  string name() const {
    return _name;
  }

  /// The target entity type name
  string targetType() const {
    return _targetType;
  }

  /// Whether the navigation targets a collection
  bool collection() const {
    return _collection;
  }

  /// Renders the navigation property as a CSDL 4.0 XML element
  override string toString() const {
    string type = _collection ? "Collection(" ~ _targetType ~ ")" : _targetType;
    return `<NavigationProperty Name="` ~ _name ~ `" Type="` ~ type ~ `"/>`;
  }

  private string _name;
  private string _targetType;
  private bool _collection;
}

/// Creates a navigation property, e.g. edmV4Navigation("Category", "Shop.Category")
EdmV4NavigationProperty edmV4Navigation(string name, string targetType, bool collection = false) {
  return new EdmV4NavigationProperty(name, targetType, collection);
}

/// An EDM V4 entity type with key, structural and navigation properties.
class EdmV4EntityType {
  this(string name) {
    _name = name;
  }

  /// The entity type name
  string name() const {
    return _name;
  }

  /// Adds a structural property (fluent interface)
  auto property(EdmV4Property value) {
    _properties ~= value;
    return this;
  }

  /// Adds a structural property (fluent interface)
  auto property(string name, EdmV4Type type) {
    return property(new EdmV4Property(name, type));
  }

  /// Adds a navigation property (fluent interface)
  auto navigation(EdmV4NavigationProperty value) {
    _navigations ~= value;
    return this;
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

  /// All structural properties
  EdmV4Property[] properties() {
    return _properties.dup;
  }

  /// All navigation properties
  EdmV4NavigationProperty[] navigations() {
    return _navigations.dup;
  }

  /// Returns the property with the given name, null if absent
  EdmV4Property findProperty(string name) {
    foreach (property; _properties) {
      if (property.name == name) {
        return property;
      }
    }
    return null;
  }

  /// Renders the entity type as a CSDL 4.0 XML element
  override string toString() const {
    auto result = appender!string;
    result.put(`<EntityType Name="` ~ _name ~ `">`);
    if (_key.length > 0) {
      result.put("<Key><PropertyRef Name=\"" ~ _key ~ "\"/></Key>");
    }
    foreach (property; _properties) {
      result.put(property.toString);
    }
    foreach (navigation; _navigations) {
      result.put(navigation.toString);
    }
    result.put("</EntityType>");
    return result.data;
  }

  private string _name;
  private string _key;
  private EdmV4Property[] _properties;
  private EdmV4NavigationProperty[] _navigations;
}

/// Creates an EDM V4 entity type, e.g. edmV4EntityType("Product")
EdmV4EntityType edmV4EntityType(string name) {
  return new EdmV4EntityType(name);
}

/// An EDM V4 entity set (a named collection of entities).
class EdmV4EntitySet {
  this(string name, EdmV4EntityType entityType) {
    _name = name;
    _entityType = entityType;
  }

  /// The entity set name, e.g. "Products"
  string name() const {
    return _name;
  }

  /// The entity type of the set
  EdmV4EntityType entityType() {
    return _entityType;
  }

  /// Renders the entity set as a CSDL 4.0 XML element
  override string toString() const {
    return `<EntitySet Name="` ~ _name ~ `" EntityType="` ~ _entityType.name ~ `"/>`;
  }

  private string _name;
  private EdmV4EntityType _entityType;
}

/// Creates an EDM V4 entity set, e.g. edmV4EntitySet("Products", productType)
EdmV4EntitySet edmV4EntitySet(string name, EdmV4EntityType entityType) {
  return new EdmV4EntitySet(name, entityType);
}

/// An EDM V4 singleton (a single addressable entity).
class EdmV4Singleton {
  this(string name, EdmV4EntityType entityType) {
    _name = name;
    _entityType = entityType;
  }

  /// The singleton name
  string name() const {
    return _name;
  }

  /// The entity type of the singleton
  EdmV4EntityType entityType() {
    return _entityType;
  }

  /// Renders the singleton as a CSDL 4.0 XML element
  override string toString() const {
    return `<Singleton Name="` ~ _name ~ `" Type="` ~ _entityType.name ~ `"/>`;
  }

  private string _name;
  private EdmV4EntityType _entityType;
}

/// Creates a singleton, e.g. edmV4Singleton("Me", userType)
EdmV4Singleton edmV4Singleton(string name, EdmV4EntityType entityType) {
  return new EdmV4Singleton(name, entityType);
}

/// An EDM V4 schema: entity types, entity sets and singletons, renderable as CSDL 4.0 XML.
class EdmV4Schema {
  this(string namespace) {
    _namespace = namespace;
  }

  /// The schema namespace, e.g. "MyService"
  string namespace() const {
    return _namespace;
  }

  /// Adds an entity type (fluent interface)
  auto entityType(EdmV4EntityType value) {
    _entityTypes[value.name] = value;
    if (!_typeOrder.canFind(value.name)) {
      _typeOrder ~= value.name;
    }
    return this;
  }

  /// Adds an entity set (fluent interface)
  auto entitySet(EdmV4EntitySet value) {
    _entitySets[value.name] = value;
    if (!_setOrder.canFind(value.name)) {
      _setOrder ~= value.name;
    }
    return this;
  }

  /// Adds a singleton (fluent interface)
  auto singleton(EdmV4Singleton value) {
    _singletons[value.name] = value;
    if (!_singletonOrder.canFind(value.name)) {
      _singletonOrder ~= value.name;
    }
    return this;
  }

  /// Returns the entity type with the given name, null if absent
  EdmV4EntityType findEntityType(string name) {
    auto found = name in _entityTypes;
    return found is null ? null : *found;
  }

  /// Returns the entity set with the given name, null if absent
  EdmV4EntitySet findEntitySet(string name) {
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

  /// All singleton names in insertion order
  string[] singletonNames() const {
    return _singletonOrder.dup;
  }

  /// Renders the schema as CSDL 4.0 XML (the $metadata document body)
  override string toString() const {
    auto result = appender!string;
    result.put(`<Schema Namespace="` ~ _namespace ~ `" xmlns="http://docs.oasis-open.org/odata/ns/edm">`);
    foreach (name; _typeOrder) {
      result.put(_entityTypes[name].toString);
    }
    result.put(`<EntityContainer Name="Container">`);
    foreach (name; _setOrder) {
      result.put(_entitySets[name].toString);
    }
    foreach (name; _singletonOrder) {
      result.put(_singletons[name].toString);
    }
    result.put("</EntityContainer>");
    result.put("</Schema>");
    return result.data;
  }

  private string _namespace;
  private EdmV4EntityType[string] _entityTypes;
  private string[] _typeOrder;
  private EdmV4EntitySet[string] _entitySets;
  private string[] _setOrder;
  private EdmV4Singleton[string] _singletons;
  private string[] _singletonOrder;
}

/// Creates an EDM V4 schema, e.g. edmV4Schema("MyService")
EdmV4Schema edmV4Schema(string namespace) {
  return new EdmV4Schema(namespace);
}

///
unittest {
  // type names (V4-specific types)
  assert(EdmV4Type.string_.toString == "Edm.String");
  assert(EdmV4Type.date.toString == "Edm.Date");
  assert(EdmV4Type.duration.toString == "Edm.Duration");
  assert(EdmV4Type.timeOfDay.toString == "Edm.TimeOfDay");
  assert(EdmV4Type.stream.toString == "Edm.Stream");

  // property
  auto name = edmV4Property("Name", EdmV4Type.string_).notNullable.maxLength(100);
  assert(name.toString == `<Property Name="Name" Type="Edm.String" Nullable="false" MaxLength="100"/>`);
  assert(edmV4Property("Price", EdmV4Type.decimal).precisionScale(10, 2).toString
    == `<Property Name="Price" Type="Edm.Decimal" Precision="10" Scale="2"/>`);

  // navigation property
  auto nav = edmV4Navigation("Category", "Shop.Category");
  assert(nav.name == "Category");
  assert(!nav.collection);
  assert(nav.toString == `<NavigationProperty Name="Category" Type="Shop.Category"/>`);
  assert(edmV4Navigation("Orders", "Shop.Order", true).toString
    == `<NavigationProperty Name="Orders" Type="Collection(Shop.Order)"/>`);

  // entity type
  auto product = edmV4EntityType("Product")
    .key("Id")
    .property("Id", EdmV4Type.int32)
    .property(name)
    .navigation(nav);
  assert(product.name == "Product");
  assert(product.keyName == "Id");
  assert(product.properties.length == 2);
  assert(product.navigations.length == 1);
  assert(product.findProperty("Name") !is null);
  string productXml = product.toString;
  assert(productXml.canFind(`<Key><PropertyRef Name="Id"/></Key>`));
  assert(productXml.canFind(`<NavigationProperty Name="Category"`));

  // entity set
  auto products = edmV4EntitySet("Products", product);
  assert(products.toString == `<EntitySet Name="Products" EntityType="Product"/>`);

  // singleton
  auto me = edmV4Singleton("Me", product);
  assert(me.toString == `<Singleton Name="Me" Type="Product"/>`);

  // schema
  auto schema = edmV4Schema("Shop")
    .entityType(product)
    .entitySet(products)
    .singleton(me);
  assert(schema.namespace == "Shop");
  assert(schema.findEntityType("Product") is product);
  assert(schema.findEntitySet("Products") is products);
  assert(schema.entityTypeNames == ["Product"]);
  assert(schema.entitySetNames == ["Products"]);
  assert(schema.singletonNames == ["Me"]);

  string csdl = schema.toString;
  assert(csdl.canFind(`xmlns="http://docs.oasis-open.org/odata/ns/edm"`));
  assert(csdl.canFind(`<EntityContainer Name="Container">`));
  assert(csdl.canFind(`<Singleton Name="Me" Type="Product"/>`));
}
