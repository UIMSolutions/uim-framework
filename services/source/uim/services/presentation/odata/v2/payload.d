/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.odata.v2.payload;

import uim.service;

mixin(ShowModule!());

@safe:

/// Renders OData V2 response payloads (JSON and Atom XML).
class ODataV2Payload {
  this(string serviceRoot) {
    // service root without trailing slash, e.g. "https://host/odata"
    _serviceRoot = serviceRoot.endsWith("/") ? serviceRoot[0 .. $ - 1] : serviceRoot;
  }

  /// The service root URL
  string serviceRoot() const {
    return _serviceRoot;
  }

  /// Renders the service document (GET on the service root) as JSON
  // @trusted: Json construction is memory-safe here
  @trusted Json serviceDocumentJson(string[] entitySetNames) const {
    auto sets = Json.emptyArray;
    foreach (name; entitySetNames) {
      auto entry = Json.emptyObject;
      entry["name"] = name;
      entry["url"] = name;
      sets ~= entry;
    }
    auto d = Json.emptyObject;
    d["EntitySets"] = sets;
    auto json = Json.emptyObject;
    json["d"] = d;
    return json;
  }

  /// Renders the service document as Atom XML
  string serviceDocumentXml(string[] entitySetNames) const {
    auto result = appender!string;
    result.put(`<?xml version="1.0" encoding="utf-8"?>`);
    result.put(`<app:service xml:base="` ~ escapeXml(_serviceRoot) ~ `/" `
      ~ `xmlns:app="http://www.w3.org/2007/app" `
      ~ `xmlns:atom="http://www.w3.org/2005/Atom">`);
    result.put(`<app:workspace><atom:title>Default</atom:title>`);
    foreach (name; entitySetNames) {
      result.put(`<app:collection href="` ~ escapeXml(name) ~ `">`);
      result.put(`<atom:title>` ~ escapeXml(name) ~ `</atom:title>`);
      result.put(`</app:collection>`);
    }
    result.put(`</app:workspace></app:service>`);
    return result.data;
  }

  /// Renders the $metadata document (CSDL XML)
  string metadataXml(EdmSchema schema) const {
    return `<?xml version="1.0" encoding="utf-8"?>`
      ~ `<edmx:Edmx Version="1.0" xmlns:edmx="http://schemas.microsoft.com/ado/2007/06/edmx">`
      ~ `<edmx:DataServices m:DataServiceVersion="2.0" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata">`
      ~ schema.toString
      ~ `</edmx:DataServices></edmx:Edmx>`;
  }

  /// Renders a single entity as an OData V2 JSON object (wrapped in "d")
  // @trusted: Json construction is memory-safe here
  @trusted Json entityJson(string entitySetName, string entityTypeName, Json entity, string key) const {
    auto d = cloneJson(entity);
    d["__metadata"] = metadataJson(entitySetName, entityTypeName, key);
    auto json = Json.emptyObject;
    json["d"] = d;
    return json;
  }

  /// Renders a collection of entities as an OData V2 JSON object
  // @trusted: Json construction is memory-safe here
  @trusted Json collectionJson(string entitySetName, string entityTypeName, Json[] entities,
      string keyProperty, long inlineCount = -1) const {
    auto results = Json.emptyArray;
    foreach (entity; entities) {
      auto entry = cloneJson(entity);
      string key = keyProperty.length > 0 && keyProperty in entity
        ? entity[keyProperty].toString.replace("\"", "") : null;
      entry["__metadata"] = metadataJson(entitySetName, entityTypeName, key);
      results ~= entry;
    }
    auto d = Json.emptyObject;
    d["results"] = results;
    if (inlineCount >= 0) {
      d["__count"] = inlineCount.to!string;
    }
    auto json = Json.emptyObject;
    json["d"] = d;
    return json;
  }

  /// Renders a $count response (plain text body)
  string countText(long count) const {
    return count.to!string;
  }

  /// Renders an OData V2 error response as JSON
  // @trusted: Json construction is memory-safe here
  @trusted Json errorJson(string code, string message) const {
    auto inner = Json.emptyObject;
    inner["code"] = code;
    inner["message"] = Json.emptyObject;
    inner["message"]["lang"] = "en";
    inner["message"]["value"] = message;
    auto json = Json.emptyObject;
    json["error"] = inner;
    return json;
  }

  private Json metadataJson(string entitySetName, string entityTypeName, string key) const {
    string uri = key.length > 0
      ? "%s/%s(%s)".format(_serviceRoot, entitySetName, key)
      : "%s/%s".format(_serviceRoot, entitySetName);
    auto metadata = Json.emptyObject;
    metadata["uri"] = uri;
    metadata["type"] = entityTypeName;
    return metadata;
  }

  private string _serviceRoot;
}

/// Creates a payload renderer, e.g. odataV2Payload("https://host/odata")
ODataV2Payload odataV2Payload(string serviceRoot) {
  return new ODataV2Payload(serviceRoot);
}

private string escapeXml(string value) {
  return value
    .replace("&", "&amp;")
    .replace("<", "&lt;")
    .replace(">", "&gt;")
    .replace(`"`, "&quot;");
}

// deep-copies a Json value via serialization
// @trusted: Json round-trip is memory-safe here
@trusted private Json cloneJson(Json value) {
  return parseJsonString(value.toString);
}

///
unittest {
  auto payload = odataV2Payload("https://example.com/odata/");
  assert(payload.serviceRoot == "https://example.com/odata"); // trailing slash removed

  // service document
  auto docJson = payload.serviceDocumentJson(["Products", "Categories"]);
  assert(docJson["d"]["EntitySets"].length == 2);
  assert(docJson["d"]["EntitySets"][0]["name"].get!string == "Products");

  string docXml = payload.serviceDocumentXml(["Products"]);
  assert(docXml.canFind(`<app:service xml:base="https://example.com/odata/"`));
  assert(docXml.canFind(`<app:collection href="Products">`));
  assert(docXml.canFind(`<atom:title>Products</atom:title>`));

  // metadata
  auto schema = edmSchema("Shop")
    .entityType(edmEntityType("Product").key("Id").property("Id", EdmType.int32))
    .entitySet(edmEntitySet("Products", edmEntityType("Product")));
  string metadata = payload.metadataXml(schema);
  assert(metadata.canFind(`<edmx:Edmx Version="1.0"`));
  assert(metadata.canFind(`m:DataServiceVersion="2.0"`));
  assert(metadata.canFind(`<Schema Namespace="Shop"`));

  // single entity
  auto product = Json.emptyObject;
  product["Id"] = 1;
  product["Name"] = "Milk";
  auto entityJson = payload.entityJson("Products", "Shop.Product", product, "1");
  assert(entityJson["d"]["Id"].get!int == 1);
  assert(entityJson["d"]["__metadata"]["uri"].get!string == "https://example.com/odata/Products(1)");
  assert(entityJson["d"]["__metadata"]["type"].get!string == "Shop.Product");

  // collection
  auto other = Json.emptyObject;
  other["Id"] = 2;
  other["Name"] = "Bread";
  auto collection = payload.collectionJson("Products", "Shop.Product", [product, other], "Id", 2);
  assert(collection["d"]["results"].length == 2);
  assert(collection["d"]["results"][1]["__metadata"]["uri"].get!string == "https://example.com/odata/Products(2)");
  assert(collection["d"]["__count"].get!string == "2");

  // collection without inline count
  auto noCount = payload.collectionJson("Products", "Shop.Product", [product], "Id");
  assert(!("__count" in noCount["d"]));

  // count
  assert(payload.countText(42) == "42");

  // error
  auto error = payload.errorJson("404", "Resource not found");
  assert(error["error"]["code"].get!string == "404");
  assert(error["error"]["message"]["value"].get!string == "Resource not found");
}
