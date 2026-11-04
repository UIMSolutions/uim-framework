/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.odata.v4.payload;

import uim.services;

mixin(ShowModule!());

@safe:

/// Renders OData V4 response payloads (JSON with @odata.* annotations and CSDL XML).
class ODataV4Payload {
  this(string serviceRoot) {
    // service root without trailing slash, e.g. "https://host/odata"
    _serviceRoot = serviceRoot.endsWith("/") ? serviceRoot[0 .. $ - 1] : serviceRoot;
  }

  /// The service root URL
  string serviceRoot() const {
    return _serviceRoot;
  }

  /// The @odata.context URL for an entity set, e.g. "$metadata#Products"
  string contextUrl(string entitySetName, string suffix = null) const {
    return "%s/$metadata#%s%s".format(_serviceRoot, entitySetName, suffix);
  }

  /// Renders the service document (GET on the service root) as JSON
  // @trusted: Json construction is memory-safe here
  @trusted Json serviceDocumentJson(string[] entitySetNames, string[] singletonNames = null) const {
    auto values = Json.emptyArray;
    foreach (name; entitySetNames) {
      auto entry = Json.emptyObject;
      entry["name"] = name;
      entry["kind"] = "EntitySet";
      entry["url"] = name;
      values ~= entry;
    }
    foreach (name; singletonNames) {
      auto entry = Json.emptyObject;
      entry["name"] = name;
      entry["kind"] = "Singleton";
      entry["url"] = name;
      values ~= entry;
    }
    auto json = Json.emptyObject;
    json["@odata.context"] = contextUrl("");
    json["value"] = values;
    return json;
  }

  /// Renders the $metadata document (CSDL 4.0 XML)
  string metadataXml(EdmV4Schema schema) const {
    return `<?xml version="1.0" encoding="utf-8"?>`
      ~ `<edmx:Edmx Version="4.0" xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx">`
      ~ `<edmx:DataServices>`
      ~ schema.toString
      ~ `</edmx:DataServices></edmx:Edmx>`;
  }

  /// Renders a single entity as an OData V4 JSON object
  // @trusted: Json construction is memory-safe here
  @trusted Json entityJson(string entitySetName, Json entity) const {
    auto result = cloneV4Json(entity);
    result["@odata.context"] = contextUrl(entitySetName, "/$entity");
    return result;
  }

  /// Renders a collection of entities as an OData V4 JSON object
  // @trusted: Json construction is memory-safe here
  @trusted Json collectionJson(string entitySetName, Json[] entities, long count = -1) const {
    auto values = Json.emptyArray;
    foreach (entity; entities) {
      values ~= cloneV4Json(entity);
    }
    auto json = Json.emptyObject;
    json["@odata.context"] = contextUrl(entitySetName);
    if (count >= 0) {
      json["@odata.count"] = count;
    }
    json["value"] = values;
    return json;
  }

  /// Renders a $count response (plain text body)
  string countText(long count) const {
    return count.to!string;
  }

  /// Renders an OData V4 error response as JSON
  // @trusted: Json construction is memory-safe here
  @trusted Json errorJson(string code, string message) const {
    auto inner = Json.emptyObject;
    inner["code"] = code;
    inner["message"] = message;
    auto json = Json.emptyObject;
    json["error"] = inner;
    return json;
  }

  private string _serviceRoot;
}

/// Creates a V4 payload renderer, e.g. odataV4Payload("https://host/odata")
ODataV4Payload odataV4Payload(string serviceRoot) {
  return new ODataV4Payload(serviceRoot);
}

// deep-copies a Json value via serialization
// @trusted: Json round-trip is memory-safe here
@trusted private Json cloneV4Json(Json value) {
  return parseJsonString(value.toString);
}

///
unittest {
  auto payload = odataV4Payload("https://example.com/odata/");
  assert(payload.serviceRoot == "https://example.com/odata"); // trailing slash removed

  // context URLs
  assert(payload.contextUrl("Products") == "https://example.com/odata/$metadata#Products");
  assert(payload.contextUrl("Products", "/$entity") == "https://example.com/odata/$metadata#Products/$entity");

  // service document
  auto doc = payload.serviceDocumentJson(["Products", "Categories"], ["Me"]);
  assert(doc["@odata.context"].get!string == "https://example.com/odata/$metadata#");
  assert(doc["value"].length == 3);
  assert(doc["value"][0]["kind"].get!string == "EntitySet");
  assert(doc["value"][2]["kind"].get!string == "Singleton");

  // metadata
  auto schema = edmV4Schema("Shop")
    .entityType(edmV4EntityType("Product").key("Id").property("Id", EdmV4Type.int32))
    .entitySet(edmV4EntitySet("Products", edmV4EntityType("Product")));
  string metadata = payload.metadataXml(schema);
  assert(metadata.canFind(`<edmx:Edmx Version="4.0"`));
  assert(metadata.canFind(`xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx"`));
  assert(metadata.canFind(`<Schema Namespace="Shop"`));

  // single entity
  auto product = Json.emptyObject;
  product["Id"] = 1;
  product["Name"] = "Milk";
  auto entity = payload.entityJson("Products", product);
  assert(entity["@odata.context"].get!string == "https://example.com/odata/$metadata#Products/$entity");
  assert(entity["Name"].get!string == "Milk");
  assert(!("__metadata" in entity)); // V4 has no __metadata

  // collection
  auto other = Json.emptyObject;
  other["Id"] = 2;
  auto collection = payload.collectionJson("Products", [product, other], 2);
  assert(collection["@odata.context"].get!string == "https://example.com/odata/$metadata#Products");
  assert(collection["@odata.count"].get!long == 2);
  assert(collection["value"].length == 2);

  // collection without count
  auto noCount = payload.collectionJson("Products", [product]);
  assert(!("@odata.count" in noCount));

  // count
  assert(payload.countText(42) == "42");

  // error
  auto error = payload.errorJson("404", "Resource not found");
  assert(error["error"]["code"].get!string == "404");
  assert(error["error"]["message"].get!string == "Resource not found");
}
