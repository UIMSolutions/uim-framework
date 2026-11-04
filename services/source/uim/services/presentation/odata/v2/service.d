/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.odata.v2.service;

import uim.services;

mixin(ShowModule!());

@safe:

/// An in-memory entity set with CRUD operations backed by Json entities.
class ODataEntitySet {
  this(EdmEntitySet definition) {
    _definition = definition;
  }

  /// The entity set definition
  EdmEntitySet definition() {
    return _definition;
  }

  /// The entity set name
  string name() {
    return _definition.name;
  }

  /// The key property name of the entity type
  string keyProperty() {
    return _definition.entityType.keyName;
  }

  /// Adds an entity (fluent interface)
  auto add(Json entity) {
    _entities ~= entity;
    return this;
  }

  /// All entities
  Json[] all() {
    return _entities.dup;
  }

  /// Number of entities
  size_t length() const {
    return _entities.length;
  }

  /// Finds an entity by its key value, returns Json(null) if absent
  // @trusted: Json access is memory-safe here
  @trusted Json find(string key) {
    string keyProp = keyProperty;
    foreach (entity; _entities) {
      if (keyProp in entity && entity[keyProp].toString.replace("\"", "") == key) {
        return entity;
      }
    }
    return Json(null);
  }

  /// Updates the entity with the given key, returns false if absent
  // @trusted: Json access is memory-safe here
  @trusted bool update(string key, Json changes) {
    string keyProp = keyProperty;
    foreach (ref entity; _entities) {
      if (keyProp in entity && entity[keyProp].toString.replace("\"", "") == key) {
        foreach (string property, Json value; changes) {
          entity[property] = value;
        }
        return true;
      }
    }
    return false;
  }

  /// Removes the entity with the given key, returns false if absent
  // @trusted: Json access is memory-safe here
  @trusted bool remove(string key) {
    string keyProp = keyProperty;
    foreach (i, entity; _entities) {
      if (keyProp in entity && entity[keyProp].toString.replace("\"", "") == key) {
        _entities = _entities.remove(i);
        return true;
      }
    }
    return false;
  }

  private EdmEntitySet _definition;
  private Json[] _entities;
}

/// An OData V2 service: schema, entity sets with data, and query execution.
class ODataV2Service {
  this(string serviceRoot, EdmSchema schema) {
    _schema = schema;
    _payload = new ODataV2Payload(serviceRoot);
  }

  /// The EDM schema of the service
  EdmSchema schema() {
    return _schema;
  }

  /// The payload renderer
  ODataV2Payload payload() {
    return _payload;
  }

  /// Registers a data-backed entity set (fluent interface)
  auto register(ODataEntitySet set) {
    _sets[set.name] = set;
    return this;
  }

  /// Returns the data of an entity set, null if absent
  ODataEntitySet opIndex(string name) {
    auto found = name in _sets;
    return found is null ? null : *found;
  }

  /// Checks whether an entity set is registered
  bool hasSet(string name) {
    return (name in _sets) !is null;
  }

  /// Renders the service document (JSON)
  Json serviceDocument() {
    return _payload.serviceDocumentJson(_schema.entitySetNames);
  }

  /// Renders the $metadata document (CSDL XML)
  string metadata() {
    return _payload.metadataXml(_schema);
  }

  /// Executes a query against an entity set and renders the result as JSON.
  /// Applies $filter, $orderby, $skip, $top, $select and $inlinecount.
  // @trusted: Json access is memory-safe here
  @trusted Json query(ODataUri uri) {
    auto set = uri.entitySet in _sets;
    if (set is null) {
      return _payload.errorJson("404", "Entity set not found: " ~ uri.entitySet);
    }

    // single entity request
    if (uri.isSingleEntity) {
      auto entity = set.find(uri.key);
      if (entity.type == Json.Type.null_) {
        return _payload.errorJson("404", "Entity not found: " ~ uri.entitySet ~ "(" ~ uri.key ~ ")");
      }
      return _payload.entityJson(uri.entitySet, set.definition.entityType.name,
        applySelect(entity, uri.select), uri.key);
    }

    // collection request
    Json[] entities = set.all;
    entities = applyFilters(entities, uri.filters);
    long totalCount = entities.length;
    entities = applyOrderBy(entities, uri.orderBy);
    entities = applyPaging(entities, uri.skip, uri.top);
    entities = entities.map!(entity => applySelect(entity, uri.select)).array;

    return _payload.collectionJson(uri.entitySet, set.definition.entityType.name,
      entities, set.keyProperty, uri.inlineCount ? totalCount : -1);
  }

  /// Executes a $count query
  // @trusted: Json access is memory-safe here
  @trusted string queryCount(ODataUri uri) {
    auto set = uri.entitySet in _sets;
    if (set is null) {
      return "0";
    }
    return _payload.countText(applyFilters(set.all, uri.filters).length);
  }

  private Json[] applyFilters(Json[] entities, FilterCondition[] filters) {
    if (filters.length == 0) {
      return entities;
    }
    return entities.filter!(entity => filters.all!(filter => matchesFilter(entity, filter))).array;
  }

  // @trusted: Json access is memory-safe here
  @trusted private bool matchesFilter(Json entity, FilterCondition filter) {
    auto value = filter.property in entity;
    if (value is null) {
      return false;
    }
    string actual = (*value).toString.strip("\"");
    final switch (filter.operator) {
      case FilterOperator.eq:
        return actual == filter.value;
      case FilterOperator.ne:
        return actual != filter.value;
      case FilterOperator.gt:
        return compareValues(actual, filter.value) > 0;
      case FilterOperator.ge:
        return compareValues(actual, filter.value) >= 0;
      case FilterOperator.lt:
        return compareValues(actual, filter.value) < 0;
      case FilterOperator.le:
        return compareValues(actual, filter.value) <= 0;
      case FilterOperator.contains:
        return actual.canFind(filter.value);
      case FilterOperator.startswith:
        return actual.startsWith(filter.value);
      case FilterOperator.endswith:
        return actual.endsWith(filter.value);
    }
  }

  // numeric comparison when both sides parse as numbers, string comparison otherwise
  private int compareValues(string left, string right) {
    try {
      return cmp(left.to!double, right.to!double);
    } catch (Exception) {
      return cmp(left, right);
    }
  }

  private Json[] applyOrderBy(Json[] entities, OrderField[] orderBy) {
    if (orderBy.length == 0) {
      return entities;
    }
    auto sorted = entities.dup;
    sorted.sort!((a, b) {
      foreach (field; orderBy) {
        string left = field.property in a ? a[field.property].toString.strip("\"") : "";
        string right = field.property in b ? b[field.property].toString.strip("\"") : "";
        int order = compareValues(left, right);
        if (order != 0) {
          return field.descending ? order > 0 : order < 0;
        }
      }
      return false;
    });
    return sorted;
  }

  private Json[] applyPaging(Json[] entities, long skip, long top) {
    auto result = entities;
    if (skip > 0) {
      result = result.length > skip ? result[skip .. $] : [];
    }
    if (top >= 0 && result.length > top) {
      result = result[0 .. top];
    }
    return result;
  }

  // @trusted: Json access is memory-safe here
  @trusted private Json applySelect(Json entity, string[] select) {
    if (select.length == 0) {
      return entity;
    }
    auto result = Json.emptyObject;
    foreach (property; select) {
      if (property in entity) {
        result[property] = entity[property];
      }
    }
    return result;
  }

  private EdmSchema _schema;
  private ODataV2Payload _payload;
  private ODataEntitySet[string] _sets;
}

/// Creates an OData V2 service, e.g. odataV2Service("https://host/odata", schema)
ODataV2Service odataV2Service(string serviceRoot, EdmSchema schema) {
  return new ODataV2Service(serviceRoot, schema);
}

///
unittest {
  // schema and data
  auto productType = edmEntityType("Product")
    .key("Id")
    .property("Id", EdmType.int32)
    .property("Name", EdmType.string_)
    .property("Price", EdmType.decimal);

  auto schema = edmSchema("Shop")
    .entityType(productType)
    .entitySet(edmEntitySet("Products", productType));

  auto products = new ODataEntitySet(schema.findEntitySet("Products"));
  assert(products.name == "Products");
  assert(products.keyProperty == "Id");

  Json product(string name, double price, int id) {
    auto json = Json.emptyObject;
    json["Id"] = id;
    json["Name"] = name;
    json["Price"] = price;
    return json;
  }

  products.add(product("Milk", 1.50, 1)).add(product("Bread", 2.00, 2)).add(product("Cheese", 5.25, 3));
  assert(products.length == 3);

  // CRUD on the entity set
  assert(products.find("1")["Name"].get!string == "Milk");
  assert(products.find("99").type == Json.Type.null_);
  assert(products.update("2", product("Rye Bread", 2.50, 2)));
  assert(products.find("2")["Name"].get!string == "Rye Bread");
  assert(!products.update("99", product("X", 0, 99)));
  assert(products.remove("3"));
  assert(products.length == 2);
  assert(!products.remove("99"));
  products.add(product("Cheese", 5.25, 3));

  // service
  auto service = odataV2Service("https://example.com/odata", schema).register(products);
  assert(service.hasSet("Products"));
  assert(!service.hasSet("Orders"));
  assert(service["Products"] is products);
  assert(service["Orders"] is null);

  // service document and metadata
  assert(service.serviceDocument["d"]["EntitySets"].length == 1);
  assert(service.metadata.canFind(`<EntitySet Name="Products"`));

  // query: full collection
  auto all = service.query(parseODataUri("Products"));
  assert(all["d"]["results"].length == 3);

  // query: single entity
  auto single = service.query(parseODataUri("Products(1)"));
  assert(single["d"]["Name"].get!string == "Milk");
  assert(single["d"]["__metadata"]["uri"].get!string == "https://example.com/odata/Products(1)");

  // query: missing entity and set
  assert("error" in service.query(parseODataUri("Products(99)")));
  assert("error" in service.query(parseODataUri("Orders")));

  // query: $filter
  auto filtered = service.query(parseODataUri("Products", "$filter=Price gt 2"));
  assert(filtered["d"]["results"].length == 2);
  auto byName = service.query(parseODataUri("Products", "$filter=Name eq 'Milk'"));
  assert(byName["d"]["results"].length == 1);
  auto contains = service.query(parseODataUri("Products", "$filter=contains(Name,'ee')"));
  assert(contains["d"]["results"].length == 1); // Cheese
  auto containsE = service.query(parseODataUri("Products", "$filter=contains(Name,'e')"));
  assert(containsE["d"]["results"].length == 2); // Rye Bread, Cheese

  // query: $orderby
  auto ordered = service.query(parseODataUri("Products", "$orderby=Price desc"));
  assert(ordered["d"]["results"][0]["Name"].get!string == "Cheese");

  // query: $top and $skip
  auto top = service.query(parseODataUri("Products", "$top=2"));
  assert(top["d"]["results"].length == 2);
  auto skipped = service.query(parseODataUri("Products", "$skip=2"));
  assert(skipped["d"]["results"].length == 1);

  // query: $select
  auto selected = service.query(parseODataUri("Products", "$select=Name"));
  assert("Name" in selected["d"]["results"][0]);
  assert(!("Price" in selected["d"]["results"][0]));

  // query: $inlinecount
  auto counted = service.query(parseODataUri("Products", "$inlinecount=allpages&$top=1"));
  assert(counted["d"]["__count"].get!string == "3");
  assert(counted["d"]["results"].length == 1);

  // query: $count
  assert(service.queryCount(parseODataUri("Products/$count")) == "3");
  assert(service.queryCount(parseODataUri("Products/$count", "$filter=Price gt 2")) == "2");
  assert(service.queryCount(parseODataUri("Orders/$count")) == "0");
}
