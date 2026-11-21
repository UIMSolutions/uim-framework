/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// CSDL (EDMX 4.0) $metadata and service document generation, including the
/// annotations SAP Fiori elements needs out of the box: Common.Label,
/// Core.Computed/Immutable, Capabilities.*Restrictions, UI.HeaderInfo,
/// UI.LineItem and UI.SelectionFields.
module uim.service.presentation.odata.metadata;

import std.array : appender, Appender;
import uim.service;
import uim.service.presentation.odata.model;

mixin(ShowModule!());

@safe:

/// Escape a string for use in XML text or attributes.
string odataXmlEscape(string value) pure {
  return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
    .replace("\"", "&quot;").replace("'", "&apos;");
}

private string attr(string value) pure {
  return `"` ~ odataXmlEscape(value) ~ `"`;
}

private string boolText(bool value) pure {
  return value ? "true" : "false";
}

/// Generate the CSDL document served at $metadata.
string buildODataMetadata(const ODataServiceModel model) {
  auto x = appender!string;
  auto ns = model.namespace_;

  x ~= `<?xml version="1.0" encoding="utf-8"?>` ~ "\n";
  x ~= `<edmx:Edmx Version="4.0" xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx">` ~ "\n";
  reference(x, "https://oasis-tcs.github.io/odata-vocabularies/vocabularies/Org.OData.Core.V1.xml", "Core", "Org.OData.Core.V1");
  reference(x, "https://oasis-tcs.github.io/odata-vocabularies/vocabularies/Org.OData.Capabilities.V1.xml",
    "Capabilities", "Org.OData.Capabilities.V1");
  reference(x, "https://sap.github.io/odata-vocabularies/vocabularies/Common.xml", "Common", "com.sap.vocabularies.Common.v1");
  reference(x, "https://sap.github.io/odata-vocabularies/vocabularies/UI.xml", "UI", "com.sap.vocabularies.UI.v1");
  x ~= `  <edmx:DataServices>` ~ "\n";
  x ~= `    <Schema Namespace=` ~ attr(ns) ~ ` xmlns="http://docs.oasis-open.org/odata/ns/edm">` ~ "\n";

  void properties(const ODataPropertyDef[] props, string key = "") {
    foreach (prop; props) {
      x ~= `        <Property Name=` ~ attr(prop.name) ~ ` Type=` ~ attr(prop.edmType);
      if (!prop.nullable || prop.name == key)
        x ~= ` Nullable="false"`;
      if (prop.maxLength > 0)
        x ~= ` MaxLength="` ~ prop.maxLength.to!string ~ `"`;
      if (prop.type == Edm.decimal)
        x ~= ` Scale="variable"`;
      if (prop.type == Edm.dateTimeOffset)
        x ~= ` Precision="3"`;
      x ~= "/>\n";
    }
  }

  foreach (set; model.entitySets) {
    x ~= `      <EntityType Name=` ~ attr(set.entityType) ~ `>` ~ "\n";
    x ~= `        <Key><PropertyRef Name=` ~ attr(set.key) ~ `/></Key>` ~ "\n";
    properties(set.properties, set.key);
    x ~= "      </EntityType>\n";
  }

  foreach (ct; model.complexTypes) {
    x ~= `      <ComplexType Name=` ~ attr(ct.name) ~ `>` ~ "\n";
    properties(ct.properties);
    x ~= "      </ComplexType>\n";
  }

  foreach (action; model.actions) {
    x ~= `      <Action Name=` ~ attr(action.name) ~ ` IsBound="false">` ~ "\n";
    foreach (param; action.parameters) {
      x ~= `        <Parameter Name=` ~ attr(param.name) ~ ` Type=` ~ attr(param.edmType);
      if (!param.nullable)
        x ~= ` Nullable="false"`;
      x ~= "/>\n";
    }
    if (action.returnType.length > 0)
      x ~= `        <ReturnType Type=` ~ attr(action.returnEdmType) ~ `/>` ~ "\n";
    x ~= "      </Action>\n";
  }

  x ~= `      <EntityContainer Name=` ~ attr(model.containerName) ~ `>` ~ "\n";
  foreach (set; model.entitySets) {
    if (set.singleton)
      x ~= `        <Singleton Name=` ~ attr(set.name) ~ ` Type=` ~ attr(model.qualified(set.entityType)) ~ `/>` ~ "\n";
    else
      x ~= `        <EntitySet Name=` ~ attr(set.name) ~ ` EntityType=` ~ attr(model.qualified(set.entityType)) ~ `/>` ~ "\n";
  }
  foreach (action; model.actions)
    x ~= `        <ActionImport Name=` ~ attr(action.name) ~ ` Action=` ~ attr(model.qualified(action.name)) ~ `/>` ~ "\n";
  x ~= "      </EntityContainer>\n";

  annotations(x, model);

  x ~= "    </Schema>\n";
  x ~= "  </edmx:DataServices>\n";
  x ~= "</edmx:Edmx>\n";
  return x.data;
}

private void reference(ref Appender!string x, string uri, string alias_, string namespace_) {
  x ~= `  <edmx:Reference Uri=` ~ attr(uri) ~ `><edmx:Include Alias=` ~ attr(alias_)
    ~ ` Namespace=` ~ attr(namespace_) ~ `/></edmx:Reference>` ~ "\n";
}

private void annotations(ref Appender!string x, const ODataServiceModel model) {
  void propertyAnnotations(string typeName, const ODataPropertyDef[] props) {
    foreach (prop; props) {
      if (prop.label.length == 0 && !prop.computed && !prop.immutable_)
        continue;
      x ~= `      <Annotations Target=` ~ attr(model.qualified(typeName) ~ "/" ~ prop.name) ~ `>`;
      if (prop.label.length > 0)
        x ~= `<Annotation Term="Common.Label" String=` ~ attr(prop.label) ~ `/>`;
      if (prop.computed)
        x ~= `<Annotation Term="Core.Computed" Bool="true"/>`;
      if (prop.immutable_)
        x ~= `<Annotation Term="Core.Immutable" Bool="true"/>`;
      x ~= "</Annotations>\n";
    }
  }

  foreach (ct; model.complexTypes)
    propertyAnnotations(ct.name, ct.properties);

  foreach (set; model.entitySets) {
    propertyAnnotations(set.entityType, set.properties);

    // ── UI annotations on the entity type ───────────────────────────────
    auto typeTarget = model.qualified(set.entityType);
    auto columns = set.listColumns;
    x ~= `      <Annotations Target=` ~ attr(typeTarget) ~ `>` ~ "\n";
    x ~= `        <Annotation Term="UI.HeaderInfo"><Record Type="UI.HeaderInfoType">`;
    x ~= `<PropertyValue Property="TypeName" String=` ~ attr(set.typeName.length ? set.typeName : set.entityType) ~ `/>`;
    x ~= `<PropertyValue Property="TypeNamePlural" String=` ~ attr(set.displayName) ~ `/>`;
    auto title = set.titleProperty.length ? set.titleProperty : set.key;
    x ~= `<PropertyValue Property="Title"><Record Type="UI.DataField"><PropertyValue Property="Value" Path=`
      ~ attr(title) ~ `/></Record></PropertyValue>`;
    if (set.descriptionProperty.length)
      x ~= `<PropertyValue Property="Description"><Record Type="UI.DataField"><PropertyValue Property="Value" Path=`
        ~ attr(set.descriptionProperty) ~ `/></Record></PropertyValue>`;
    x ~= "</Record></Annotation>\n";

    if (columns.length > 0) {
      x ~= `        <Annotation Term="UI.LineItem"><Collection>`;
      foreach (c; columns)
        x ~= `<Record Type="UI.DataField"><PropertyValue Property="Value" Path=` ~ attr(c) ~ `/></Record>`;
      x ~= "</Collection></Annotation>\n";
    }
    if (set.selectionFields.length > 0) {
      x ~= `        <Annotation Term="UI.SelectionFields"><Collection>`;
      foreach (c; set.selectionFields)
        x ~= `<PropertyPath>` ~ odataXmlEscape(c) ~ `</PropertyPath>`;
      x ~= "</Collection></Annotation>\n";
    }
    x ~= "      </Annotations>\n";

    if (set.singleton)
      continue;

    // ── Capabilities on the entity set ──────────────────────────────────
    auto target = model.qualified(model.containerName) ~ "/" ~ set.name;
    x ~= `      <Annotations Target=` ~ attr(target) ~ `>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.InsertRestrictions"><Record><PropertyValue Property="Insertable" Bool="`
      ~ boolText(set.insertable) ~ `"/></Record></Annotation>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.UpdateRestrictions"><Record><PropertyValue Property="Updatable" Bool="`
      ~ boolText(set.updatable) ~ `"/></Record></Annotation>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.DeleteRestrictions"><Record><PropertyValue Property="Deletable" Bool="`
      ~ boolText(set.deletable) ~ `"/></Record></Annotation>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.SearchRestrictions"><Record><PropertyValue Property="Searchable" Bool="`
      ~ boolText(set.searchable) ~ `"/></Record></Annotation>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.CountRestrictions"><Record><PropertyValue Property="Countable" Bool="true"/></Record></Annotation>` ~ "\n";
    x ~= `        <Annotation Term="Capabilities.NavigationRestrictions"><Record><PropertyValue Property="Navigability"><EnumMember>Capabilities.NavigationType/None</EnumMember></PropertyValue></Record></Annotation>` ~ "\n";
    x ~= "      </Annotations>\n";
  }

  auto containerTarget = model.qualified(model.containerName);
  x ~= `      <Annotations Target=` ~ attr(containerTarget) ~ `>`
    ~ `<Annotation Term="Capabilities.BatchSupported" Bool="true"/>`
    ~ `<Annotation Term="Capabilities.BatchSupport"><Record><PropertyValue Property="ReferencesAcrossChangeSetsSupported" Bool="false"/>`
    ~ `<PropertyValue Property="SupportedFormats"><Collection><String>multipart/mixed</String><String>application/json</String></Collection></PropertyValue></Record></Annotation>`
    ~ `<Annotation Term="Common.Label" String=` ~ attr(model.title) ~ `/>`
    ~ "</Annotations>\n";
}

/// The OData service document (JSON) listing all entity sets and singletons
/// (action imports are not listed, as required by the OData JSON format).
Json buildODataServiceDocument(const ODataServiceModel model, string metadataUrl) {
  auto value = Json.emptyArray;
  foreach (set; model.entitySets) {
    auto entry = Json.emptyObject;
    entry["name"] = set.name;
    entry["kind"] = set.singleton ? "Singleton" : "EntitySet";
    entry["url"] = set.name;
    if (set.typeNamePlural.length > 0)
      entry["title"] = set.typeNamePlural;
    value ~= entry;
  }
  auto doc = Json.emptyObject;
  doc["@odata.context"] = metadataUrl;
  doc["value"] = value;
  return doc;
}

///
unittest {
  mixin(ShowTest!("buildODataMetadata"));

  auto m = new ODataServiceModel("uim.demo", "DemoService");
  m.entitySet("Products", "Product").tenantAware().property("name", Edm.string_, "Name <short>", false)
    .writable(true, false, false).columns("name").filters("name");
  m.singletonSet("Statistics", "Statistic").keyed("total").property("total", Edm.int32);
  m.complexType("Result").property("count", Edm.int32);
  m.action("Recalculate", "Result").parameter("dryRun", Edm.boolean, false);

  auto xml = buildODataMetadata(m);
  assert(xml.canFind(`<EntitySet Name="Products" EntityType="uim.demo.Product"/>`));
  assert(xml.canFind(`<Singleton Name="Statistics" Type="uim.demo.Statistic"/>`));
  assert(xml.canFind(`<ActionImport Name="Recalculate" Action="uim.demo.Recalculate"/>`));
  assert(xml.canFind(`<Parameter Name="dryRun" Type="Edm.Boolean" Nullable="false"/>`));
  assert(xml.canFind(`<ReturnType Type="uim.demo.Result"/>`));
  assert(xml.canFind(`<Property Name="id" Type="Edm.String" Nullable="false"/>`));
  assert(xml.canFind(`String="Name &lt;short&gt;"`));
  assert(xml.canFind(`<Annotation Term="Core.Computed" Bool="true"/>`));
  assert(xml.canFind(`Term="UI.LineItem"`));
  assert(xml.canFind(`<PropertyPath>name</PropertyPath>`));
  assert(xml.canFind(`Property="Updatable" Bool="false"`));
  assert(odataXmlEscape(`a<b & "c"`) == "a&lt;b &amp; &quot;c&quot;");

  auto doc = buildODataServiceDocument(m, "$metadata");
  assert(doc["value"].length == 2);
  assert(doc["value"][1]["kind"].get!string == "Singleton");
}
