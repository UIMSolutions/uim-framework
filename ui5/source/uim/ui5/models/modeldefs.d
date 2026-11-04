/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.models.modeldefs;

import uim.ui5;

mixin(ShowModule!());

@safe:


/// A UI5 model definition for the app descriptor or component initialization.
class Ui5ModelDefinition {
  this(Ui5ModelType type) {
    _type = type;
  }

  /// The model type
  Ui5ModelType type() const {
    return _type;
  }

  /// Sets a data source reference (fluent interface)
  auto dataSource(string name) {
    _dataSource = name;
    return this;
  }

  /// Sets a data URI for JSON/XML models (fluent interface)
  auto uri(string value) {
    _uri = value;
    return this;
  }

  /// Sets the bundle name for resource models, e.g. "my.app.i18n.i18n" (fluent interface)
  auto bundleName(string value) {
    _bundleName = value;
    return this;
  }

  /// Sets a model setting, e.g. setting("defaultBindingMode", "TwoWay") (fluent interface)
  auto setting(string name, string value) {
    _settings[name] = value;
    if (!_settingOrder.canFind(name)) {
      _settingOrder ~= name;
    }
    return this;
  }

  /// Renders the model definition as a Json object (for the app descriptor)
  // @trusted: Json construction is memory-safe here
  @trusted Json toJson() const {
    auto json = Json.emptyObject;
    json["type"] = _type.toString;
    if (_dataSource.length > 0) {
      json["dataSource"] = _dataSource;
    }
    if (_uri.length > 0) {
      json["uri"] = _uri;
    }
    if (_bundleName.length > 0) {
      auto settings = Json.emptyObject;
      settings["bundleName"] = _bundleName;
      json["settings"] = settings;
    }
    if (_settingOrder.length > 0) {
      auto settings = "settings" in json ? json["settings"] : Json.emptyObject;
      foreach (name; _settingOrder) {
        settings[name] = _settings[name];
      }
      json["settings"] = settings;
    }
    return json;
  }

  private Ui5ModelType _type;
  private string _dataSource;
  private string _uri;
  private string _bundleName;
  private string[string] _settings;
  private string[] _settingOrder;
}

/// Creates a JSON model definition, e.g. ui5JsonModel("/data/items.json")
Ui5ModelDefinition ui5JsonModel(string uri = null) {
  auto model = new Ui5ModelDefinition(Ui5ModelType.json);
  if (uri.length > 0) {
    model.uri(uri);
  }
  return model;
}

/// Creates an OData V2 model definition, e.g. ui5ODataV2Model("mainService")
Ui5ModelDefinition ui5ODataV2Model(string dataSource) {
  return new Ui5ModelDefinition(Ui5ModelType.odataV2).dataSource(dataSource);
}

/// Creates an OData V4 model definition
Ui5ModelDefinition ui5ODataV4Model(string dataSource) {
  return new Ui5ModelDefinition(Ui5ModelType.odataV4).dataSource(dataSource);
}

/// Creates a resource (i18n) model definition, e.g. ui5ResourceModel("my.app.i18n.i18n")
Ui5ModelDefinition ui5ResourceModel(string bundleName) {
  return new Ui5ModelDefinition(Ui5ModelType.resource).bundleName(bundleName);
}

/// Creates an XML model definition
Ui5ModelDefinition ui5XmlModel(string uri = null) {
  auto model = new Ui5ModelDefinition(Ui5ModelType.xml);
  if (uri.length > 0) {
    model.uri(uri);
  }
  return model;
}

/// A binding path expression, e.g. bindPath("/items/0/name") -> "{/items/0/name}"
string bindPath(string path) {
  return "{" ~ path ~ "}";
}

/// An i18n binding expression, e.g. bindI18n("title") -> "{i18n>title}"
string bindI18n(string key) {
  return "{i18n>" ~ key ~ "}";
}

/// A binding with a named model, e.g. bindModel("odata", "/Products") -> "{odata>/Products}"
string bindModel(string modelName, string path) {
  return "{" ~ modelName ~ ">" ~ path ~ "}";
}

/// A binding with a formatter, e.g. bindFormatted("/price", ".formatPrice") -> "{path: '/price', formatter: '.formatPrice'}"
string bindFormatted(string path, string formatter) {
  return "{path: '%s', formatter: '%s'}".format(path, formatter);
}

///
unittest {
  // model type names
  assert(Ui5ModelType.json.toString == "sap.ui.model.json.JSONModel");
  assert(Ui5ModelType.odataV2.toString == "sap.ui.model.odata.v2.ODataModel");
  assert(Ui5ModelType.odataV4.toString == "sap.ui.model.odata.v4.ODataModel");
  assert(Ui5ModelType.resource.toString == "sap.ui.model.resource.ResourceModel");
  assert(Ui5ModelType.xml.toString == "sap.ui.model.xml.XMLModel");

  // JSON model
  auto jsonModel = ui5JsonModel("/data/items.json");
  assert(jsonModel.type == Ui5ModelType.json);
  assert(jsonModel.toJson["type"].get!string == "sap.ui.model.json.JSONModel");
  assert(jsonModel.toJson["uri"].get!string == "/data/items.json");
  assert(!("uri" in ui5JsonModel().toJson));

  // OData models
  auto v2 = ui5ODataV2Model("mainService");
  assert(v2.toJson["type"].get!string == "sap.ui.model.odata.v2.ODataModel");
  assert(v2.toJson["dataSource"].get!string == "mainService");
  assert(ui5ODataV4Model("v4Service").toJson["type"].get!string == "sap.ui.model.odata.v4.ODataModel");

  // resource model
  auto i18n = ui5ResourceModel("my.app.i18n.i18n");
  assert(i18n.toJson["settings"]["bundleName"].get!string == "my.app.i18n.i18n");

  // XML model
  assert(ui5XmlModel("/data/items.xml").toJson["uri"].get!string == "/data/items.xml");

  // settings
  auto configured = ui5ODataV2Model("mainService")
    .setting("defaultBindingMode", "TwoWay")
    .setting("defaultCountMode", "Inline");
  auto settings = configured.toJson["settings"];
  assert(settings["defaultBindingMode"].get!string == "TwoWay");
  assert(settings["defaultCountMode"].get!string == "Inline");

  // binding expressions
  assert(bindPath("/items/0/name") == "{/items/0/name}");
  assert(bindI18n("title") == "{i18n>title}");
  assert(bindModel("odata", "/Products") == "{odata>/Products}");
  assert(bindFormatted("/price", ".formatPrice") == "{path: '/price', formatter: '.formatPrice'}");
}
