/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.odata.v4.service;

import uim.service;

mixin(ShowModule!());

@safe:

/// An in-memory V4 entity set with CRUD operations backed by Json entities.
class ODataV4EntitySet {
  this(EdmV4EntitySet definition) {
    _definition = definition;
  }

  /// The entity set definition
  EdmV4EntitySet definition() {
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

  private EdmV4EntitySet _definition;
  private Json[] _entities;
}

/// An OData V4 service: schema, entity sets with data, and query execution.
class ODataV4Service {
  this(string serviceRoot, EdmV4Schema schema) {
    _schema = schema;
    _payload = new ODataV4Payload(serviceRoot);
  }

  /// The EDM schema of the service
  EdmV4Schema schema() {
    return _schema;
  }

  /// The payload renderer
  ODataV4Payload payload() {
    return _payload;
  }

  /// Registers a data-backed entity set (fluent interface)
  auto register(ODataV4EntitySet set) {
    _sets[set.name] = set;
    return this;
  }

  /// Returns the data of an entity set, null if absent
  ODataV4EntitySet opIndex(string name) {
    auto found = name in _sets;
    return found is null ? null : *found;
  }

  /// Checks whether an entity set is registered
  bool hasSet(string name) {
    return (name in _sets) !is null;
  }

  /// Renders the service document (JSON)
  Json serviceDocument() {
    return _payload.serviceDocumentJson(_schema.entitySetNames, _schema.singletonNames);
  }

  /// Renders the $metadata document (CSDL 4.0 XML)
  string metadata() {
    return _payload.metadataXml(_schema);
  }

  /// Executes a query against an entity set and renders the result as JSON.
  /// Applies $filter, $search, $orderby, $skip, $top, $select and $count.
  // @trusted: Json access is memory-safe here
  @trusted Json query(ODataV4Uri uri) {
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
      return _payload.entityJson(uri.entitySet, applySelect(entity, uri.select));
    }

    // collection request
    Json[] entities = set.all;
    entities = applyFilters(entities, uri.filters);
    if (uri.search.length > 0) {
      entities = applySearch(entities, uri.search);
    }
    long totalCount = entities.length;
    entities = applyOrderBy(entities, uri.orderBy);
    entities = applyPaging(entities, uri.skip, uri.top);
    entities = entities.map!(entity => applySelect(entity, uri.select)).array;

    return _payload.collectionJson(uri.entitySet, entities, uri.count ? totalCount : -1);
  }

  /// Executes a $count query
  // @trusted: Json access is memory-safe here
  @trusted string queryCount(ODataV4Uri uri) {
    auto set = uri.entitySet in _sets;
    if (set is null) {
      return "0";
    }
    return _payload.countText(applyFilters(set.all, uri.filters).length);
  }

  private Json[] applyFilters(Json[] entities, V4FilterCondition[] filters) {
    if (filters.length == 0) {
      return entities;
    }
    return entities.filter!(entity => filters.all!(filter => matchesFilter(entity, filter))).array;
  }

  // @trusted: Json access is memory-safe here
  @trusted private bool matchesFilter(Json entity, V4FilterCondition filter) {
    auto value = filter.property in entity;
    if (value is null) {
      return false;
    }
    string actual = (*value).toString.strip("\"");
    final switch (filter.operator) {
      case V4FilterOperator.eq:
        return actual == filter.value;
      case V4FilterOperator.ne:
        return actual != filter.value;
      case V4FilterOperator.gt:
        return compareValues(actual, filter.value) > 0;
      case V4FilterOperator.ge:
        return compareValues(actual, filter.value) >= 0;
      case V4FilterOperator.lt:
        return compareValues(actual, filter.value) < 0;
      case V4FilterOperator.le:
        return compareValues(actual, filter.value) <= 0;
      case V4FilterOperator.in_:
        return filter.inValues.canFind(actual);
      case V4FilterOperator.contains:
        return actual.canFind(filter.value);
      case V4FilterOperator.startswith:
        return actual.startsWith(filter.value);
      case V4FilterOperator.endswith:
        return actual.endsWith(filter.value);
    }
  }

  // $search matches the term against any string property of the entity
  // @trusted: Json access is memory-safe here
  @trusted private Json[] applySearch(Json[] entities, string term) {
    return entities.filter!((entity) {
      foreach (string property, Json value; entity) {
        if (value.type == Json.Type.string && value.get!string.canFind(term)) {
          return true;
        }
      }
      return false;
    }).array;
  }

  // numeric comparison when both sides parse as numbers, string comparison otherwise
  private int compareValues(string left, string right) {
    try {
      return cmp(left.to!double, right.to!double);
    } catch (Exception) {
      return cmp(left, right);
    }
  }

  private Json[] applyOrderBy(Json[] entities, V4OrderField[] orderBy) {
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

  private EdmV4Schema _schema;
  private ODataV4Payload _payload;
  private ODataV4EntitySet[string] _sets;
}

/// Creates an OData V4 service, e.g. odataV4Service("https://host/odata", schema)
ODataV4Service odataV4Service(string serviceRoot, EdmV4Schema schema) {
  return new ODataV4Service(serviceRoot, schema);
}

///
unittest {
  // schema and data
  auto productType = edmV4EntityType("Product")
    .key("Id")
    .property("Id", EdmV4Type.int32)
    .property("Name", EdmV4Type.string_)
    .property("Price", EdmV4Type.decimal);

  auto schema = edmV4Schema("Shop")
    .entityType(productType)
    .entitySet(edmV4EntitySet("Products", productType));

  auto products = new ODataV4EntitySet(schema.findEntitySet("Products"));
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
  auto service = odataV4Service("https://example.com/odata", schema).register(products);
  assert(service.hasSet("Products"));
  assert(!service.hasSet("Orders"));
  assert(service["Products"] is products);
  assert(service["Orders"] is null);

  // service document and metadata
  assert(service.serviceDocument["value"].length == 1);
  assert(service.serviceDocument["@odata.context"].get!string == "https://example.com/odata/$metadata#");
  assert(service.metadata.canFind(`Version="4.0"`));

  // query: full collection
  auto all = service.query(parseODataV4Uri("Products"));
  assert(all["value"].length == 3);
  assert(all["@odata.context"].get!string == "https://example.com/odata/$metadata#Products");

  // query: single entity
  auto single = service.query(parseODataV4Uri("Products(1)"));
  assert(single["Name"].get!string == "Milk");
  assert(single["@odata.context"].get!string == "https://example.com/odata/$metadata#Products/$entity");

  // query: missing entity and set
  assert("error" in service.query(parseODataV4Uri("Products(99)")));
  assert("error" in service.query(parseODataV4Uri("Orders")));

  // query: $filter
  auto filtered = service.query(parseODataV4Uri("Products", "$filter=Price gt 2"));
  assert(filtered["value"].length == 2);
  auto byName = service.query(parseODataV4Uri("Products", "$filter=Name eq 'Milk'"));
  assert(byName["value"].length == 1);

  // query: V4 "in" operator
  auto inFilter = service.query(parseODataV4Uri("Products", "$filter=Name in ('Milk', 'Cheese')"));
  assert(inFilter["value"].length == 2);

  // query: $search
  auto searched = service.query(parseODataV4Uri("Products", "$search=Bread"));
  assert(searched["value"].length == 1);

  // query: $orderby
  auto ordered = service.query(parseODataV4Uri("Products", "$orderby=Price desc"));
  assert(ordered["value"][0]["Name"].get!string == "Cheese");

  // query: $top and $skip
  assert(service.query(parseODataV4Uri("Products", "$top=2"))["value"].length == 2);
  assert(service.query(parseODataV4Uri("Products", "$skip=2"))["value"].length == 1);

  // query: $select
  auto selected = service.query(parseODataV4Uri("Products", "$select=Name"));
  assert("Name" in selected["value"][0]);
  assert(!("Price" in selected["value"][0]));

  // query: $count=true (inline count before paging)
  auto counted = service.query(parseODataV4Uri("Products", "$count=true&$top=1"));
  assert(counted["@odata.count"].get!long == 3);
  assert(counted["value"].length == 1);

  // query: $count segment
  assert(service.queryCount(parseODataV4Uri("Products/$count")) == "3");
  assert(service.queryCount(parseODataV4Uri("Products/$count", "$filter=Price gt 2")) == "2");
  assert(service.queryCount(parseODataV4Uri("Orders/$count")) == "0");
}
