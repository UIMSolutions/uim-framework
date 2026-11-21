/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// EDM model of an OData v4 service, built with a fluent API:
///
/// ---
/// auto model = new ODataServiceModel("uim.demo", "DemoService");
/// model.entitySet("Products", "Product")
///   .tenantAware()                                   // id, tenantId, createdAt, ...
///   .property("name", Edm.string_, "Name", false)
///   .property("price", Edm.decimal, "Price")
///   .property("active", Edm.boolean, "Active")
///   .writable()                                      // POST / PATCH / DELETE
///   .titled("Product", "Products", "name")           // UI.HeaderInfo
///   .columns("name", "price", "active")              // UI.LineItem
///   .filters("name", "active");                      // UI.SelectionFields
/// model.action("Recalculate", Edm.int32).parameter("dryRun", Edm.boolean);
/// ---
///
/// The model drives $metadata, payload validation and the generic CLI and GUI.
module uim.service.presentation.odata.model;

import uim.service;

mixin(ShowModule!());

@safe:

/// Primitive EDM types.
enum Edm : string {
  string_ = "Edm.String",
  boolean = "Edm.Boolean",
  int32 = "Edm.Int32",
  int64 = "Edm.Int64",
  decimal = "Edm.Decimal",
  double_ = "Edm.Double",
  date = "Edm.Date",
  timeOfDay = "Edm.TimeOfDay",
  dateTimeOffset = "Edm.DateTimeOffset",
  guid = "Edm.Guid",
  binary = "Edm.Binary",
}

/// A structural property of an entity or complex type (or an action parameter).
struct ODataPropertyDef {
  string name;
  string type = Edm.string_; /// Edm.* or a qualified complex type name
  bool nullable = true;
  bool collection;
  string label; /// Common.Label
  bool computed; /// Core.Computed — set by the server, ignored on write
  bool immutable_; /// Core.Immutable — set on create only
  size_t maxLength; /// 0 = unbounded

  string edmType() const {
    return collection ? "Collection(" ~ type ~ ")" : type;
  }

  bool isPrimitive() const {
    return type.startsWith("Edm.");
  }

  /// Int64 and Decimal are serialized as strings for IEEE754Compatible clients.
  bool isIeee754Sensitive() const {
    return type == Edm.int64 || type == Edm.decimal;
  }
}

/// A complex type (structured, no key).
class ODataComplexTypeDef {
  string name;
  ODataPropertyDef[] properties;

  this(string name) {
    this.name = name;
  }

  ODataComplexTypeDef property(string name, string type = Edm.string_, string label = "", bool nullable = true) {
    properties ~= ODataPropertyDef(name, type, nullable, false, label);
    return this;
  }
}

/// An entity type together with its entity set (or singleton).
class ODataEntitySetDef {
  string name; /// entity set name, e.g. "Products"
  string entityType; /// entity type name, e.g. "Product"
  string key = "id";
  ODataPropertyDef[] properties;
  bool insertable;
  bool updatable;
  bool deletable;
  bool singleton; /// exposed as <Singleton>
  bool searchable = true; /// Capabilities.SearchRestrictions
  string typeName; /// UI.HeaderInfo TypeName (singular label)
  string typeNamePlural; /// UI.HeaderInfo TypeNamePlural
  string titleProperty; /// UI.HeaderInfo Title
  string descriptionProperty; /// UI.HeaderInfo Description
  string[] lineItem; /// UI.LineItem columns (default: first visible properties)
  string[] selectionFields; /// UI.SelectionFields
  string readScope; /// scope required to read ("" = none)
  string writeScope; /// scope required to write ("" = none)

  this(string name, string entityType) {
    this.name = name;
    this.entityType = entityType;
  }

  // ── fluent builder ──────────────────────────────────────────────────────

  /// Add (or replace) a property.
  ODataEntitySetDef property(string name, string type = Edm.string_, string label = "", bool nullable = true) {
    return add(ODataPropertyDef(name, type, nullable, false, label));
  }

  /// Add a collection valued property, e.g. Collection(Edm.String).
  ODataEntitySetDef collection(string name, string type = Edm.string_, string label = "") {
    return add(ODataPropertyDef(name, type, true, true, label));
  }

  /// Add a fully specified property.
  ODataEntitySetDef add(ODataPropertyDef def) {
    foreach (ref p; properties)
      if (p.name == def.name) {
        p = def;
        return this;
      }
    properties ~= def;
    return this;
  }

  /// Use another key property (must exist; it becomes non-nullable).
  ODataEntitySetDef keyed(string propertyName) {
    key = propertyName;
    return this;
  }

  /// Standard properties of tenant aware entities (all computed).
  ODataEntitySetDef tenantAware() {
    foreach (def; [
        ODataPropertyDef("id", Edm.string_, false, false, "ID", true),
        ODataPropertyDef("tenantId", Edm.string_, true, false, "Tenant", true),
        ODataPropertyDef("createdAt", Edm.dateTimeOffset, true, false, "Created At", true),
        ODataPropertyDef("createdBy", Edm.string_, true, false, "Created By", true),
        ODataPropertyDef("updatedAt", Edm.dateTimeOffset, true, false, "Changed At", true),
        ODataPropertyDef("updatedBy", Edm.string_, true, false, "Changed By", true),
      ])
      add(def);
    return this;
  }

  /// Mark properties as computed (server managed, ignored on write).
  ODataEntitySetDef computed(string[] names...) {
    foreach (ref p; properties)
      if (names.canFind(p.name))
        p.computed = true;
    return this;
  }

  /// Mark properties as immutable (writable on create only).
  ODataEntitySetDef immutableProps(string[] names...) {
    foreach (ref p; properties)
      if (names.canFind(p.name))
        p.immutable_ = true;
    return this;
  }

  /// Mark properties as mandatory (Nullable="false").
  ODataEntitySetDef required(string[] names...) {
    foreach (ref p; properties)
      if (names.canFind(p.name))
        p.nullable = false;
    return this;
  }

  /// Allow writes (all by default).
  ODataEntitySetDef writable(bool insert = true, bool update = true, bool delete_ = true) {
    insertable = insert;
    updatable = update;
    deletable = delete_;
    return this;
  }

  /// UI.HeaderInfo
  ODataEntitySetDef titled(string typeName, string typeNamePlural, string titleProperty = "", string descriptionProperty = "") {
    this.typeName = typeName;
    this.typeNamePlural = typeNamePlural;
    this.titleProperty = titleProperty;
    this.descriptionProperty = descriptionProperty;
    return this;
  }

  /// UI.LineItem columns.
  ODataEntitySetDef columns(string[] names...) {
    lineItem = names.dup;
    return this;
  }

  /// UI.SelectionFields (filter bar).
  ODataEntitySetDef filters(string[] names...) {
    selectionFields = names.dup;
    return this;
  }

  /// Scopes required for reading / writing (checked by ODataEngine when enforced).
  ODataEntitySetDef scopes(string read, string write) {
    readScope = read;
    writeScope = write;
    return this;
  }

  // ── queries ─────────────────────────────────────────────────────────────

  bool hasProperty(string propertyName) const {
    return properties.any!(p => p.name == propertyName);
  }

  /// The property definition (ODataPropertyDef.init with empty name if unknown).
  ODataPropertyDef propertyOf(string propertyName) const {
    foreach (p; properties)
      if (p.name == propertyName)
        return p;
    return ODataPropertyDef.init;
  }

  string[] propertyNames() const {
    return properties.map!(p => p.name.idup).array;
  }

  /// Label of a property (falls back to the name).
  string labelOf(string propertyName) const {
    auto p = propertyOf(propertyName);
    return p.label.length > 0 ? p.label : propertyName;
  }

  /// Columns for list views: lineItem, or the first non-technical properties.
  string[] listColumns(size_t maxColumns = 8) const {
    if (lineItem.length > 0)
      return lineItem.dup;
    enum technical = ["tenantId", "createdAt", "createdBy", "updatedBy", "updatedAt"];
    string[] cols;
    foreach (p; properties) {
      if (p.name == key || technical.canFind(p.name) || p.collection || !p.isPrimitive)
        continue;
      cols ~= p.name;
      if (cols.length >= maxColumns)
        break;
    }
    return cols;
  }

  /// Display name of the set (TypeNamePlural or name).
  string displayName() const {
    return typeNamePlural.length > 0 ? typeNamePlural : name;
  }
}

/// An unbound action (ActionImport).
class ODataActionDef {
  string name;
  ODataPropertyDef[] parameters;
  string returnType; /// "" = no return value
  bool returnsCollection;
  string label;
  string scope_; /// scope required to invoke ("" = none)

  this(string name, string returnType = "") {
    this.name = name;
    this.returnType = returnType;
  }

  ODataActionDef parameter(string name, string type = Edm.string_, bool nullable = true) {
    parameters ~= ODataPropertyDef(name, type, nullable);
    return this;
  }

  ODataActionDef labelled(string text) {
    label = text;
    return this;
  }

  ODataActionDef requires(string scopeName) {
    scope_ = scopeName;
    return this;
  }

  string returnEdmType() const {
    return returnsCollection ? "Collection(" ~ returnType ~ ")" : returnType;
  }
}

/// The whole EDM model of a service.
class ODataServiceModel {
  string namespace_;
  string containerName;
  string title; /// human readable service title (CLI/GUI)
  ODataEntitySetDef[] entitySets;
  ODataComplexTypeDef[] complexTypes;
  ODataActionDef[] actions;

  this(string namespace_, string containerName, string title = "") {
    this.namespace_ = namespace_;
    this.containerName = containerName;
    this.title = title.length > 0 ? title : containerName;
  }

  /// Add an entity set.
  ODataEntitySetDef entitySet(string name, string entityType) {
    enforce(!has(name), "Duplicate entity set " ~ name);
    auto set = new ODataEntitySetDef(name, entityType);
    entitySets ~= set;
    return set;
  }

  /// Add a singleton (key defaults to "id" but is not addressable).
  ODataEntitySetDef singletonSet(string name, string entityType) {
    auto set = entitySet(name, entityType);
    set.singleton = true;
    return set;
  }

  /// Add a complex type.
  ODataComplexTypeDef complexType(string name) {
    auto ct = new ODataComplexTypeDef(name);
    complexTypes ~= ct;
    return ct;
  }

  /// Add an unbound action; returnType may be Edm.* or a type name of this model.
  ODataActionDef action(string name, string returnType = "") {
    enforce(findAction(name) is null, "Duplicate action " ~ name);
    auto a = new ODataActionDef(name, returnType.length > 0 && !returnType.startsWith("Edm.")
        && !returnType.canFind(".") ? qualified(returnType) : returnType);
    actions ~= a;
    return a;
  }

  /// True if an entity set or singleton with this name exists.
  bool has(string name) const {
    return entitySets.any!(s => s.name == name);
  }

  /// The entity set or singleton, or null.
  inout(ODataEntitySetDef) find(string name) inout {
    foreach (s; entitySets)
      if (s.name == name)
        return s;
    return null;
  }

  /// The action, or null.
  inout(ODataActionDef) findAction(string name) inout {
    foreach (a; actions)
      if (a.name == name)
        return a;
    return null;
  }

  /// "<namespace>.<typeName>"
  string qualified(string typeName) const {
    return namespace_ ~ "." ~ typeName;
  }

  /// Validate the model (keys exist, no unknown annotation targets). Throws on error.
  void validate() const {
    foreach (s; entitySets) {
      enforce(s.singleton || s.hasProperty(s.key), s.name ~ ": key property '" ~ s.key ~ "' is not defined");
      foreach (c; s.lineItem ~ s.selectionFields)
        enforce(s.hasProperty(c), s.name ~ ": annotated property '" ~ c ~ "' is not defined");
      if (s.titleProperty.length > 0)
        enforce(s.hasProperty(s.titleProperty), s.name ~ ": title property '" ~ s.titleProperty ~ "' is not defined");
    }
  }
}

///
unittest {
  mixin(ShowTest!("ODataServiceModel"));

  auto m = new ODataServiceModel("uim.demo", "DemoService", "Demo");
  m.entitySet("Products", "Product")
    .tenantAware()
    .property("name", Edm.string_, "Name", false)
    .property("price", Edm.decimal, "Price")
    .collection("tags", Edm.string_, "Tags")
    .writable()
    .titled("Product", "Products", "name")
    .filters("name");
  m.singletonSet("Statistics", "Statistic").property("total", Edm.int32);
  m.complexType("Result").property("count", Edm.int32);
  m.action("Recalculate", "Result").parameter("dryRun", Edm.boolean);

  m.validate();
  assert(m.has("Products") && !m.has("Unknown"));
  assert(m.find("Unknown") is null);
  auto p = m.find("Products");
  assert(p.propertyOf("id").computed);
  assert(!p.propertyOf("name").nullable);
  assert(p.listColumns == ["name", "price"]);
  assert(p.displayName == "Products");
  assert(m.findAction("Recalculate").returnType == "uim.demo.Result");
  assert(m.find("Statistics").singleton);

  bool failed;
  try
    m.entitySet("Products", "X");
  catch (Exception)
    failed = true;
  assert(failed);
}
