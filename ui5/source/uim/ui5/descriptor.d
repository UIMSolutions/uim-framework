/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.descriptor;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// A routing target of the app descriptor.
struct Ui5RouteTarget {
  string name;
  string viewName;
  string viewPath;
  string viewLevel; // empty = not set
  string controlId; // empty = not set
  string controlAggregation; // empty = not set
}

/// Creates a routing target, e.g. ui5RouteTarget("home", "Home")
Ui5RouteTarget ui5RouteTarget(string name, string viewName, string viewPath = null) {
  return Ui5RouteTarget(name, viewName, viewPath);
}

/// A route pattern of the app descriptor.
struct Ui5Route {
  string pattern;
  string[] targets;
}

/// Creates a route, e.g. ui5Route("detail/{id}", ["detail"])
Ui5Route ui5Route(string pattern, string[] targets...) {
  return Ui5Route(pattern, targets.dup);
}

/// The UI5 app descriptor (manifest.json, "sap.app" + "sap.ui5" sections).
class Ui5AppManifest {
  this(string id) {
    _id = id;
  }

  /// The application id, e.g. "my.app"
  string id() const {
    return _id;
  }

  /// Sets the application title (fluent interface)
  auto title(string value) {
    _title = value;
    return this;
  }

  /// Sets the application description (fluent interface)
  auto description(string value) {
    _description = value;
    return this;
  }

  /// Sets the application version, e.g. "1.0.0" (fluent interface)
  auto appVersion(string value) {
    _appVersion = value;
    return this;
  }

  /// Sets the minimum UI5 version, e.g. "1.120.0" (fluent interface)
  auto minUi5Version(string value) {
    _minUi5Version = value;
    return this;
  }

  /// Sets the root view name, e.g. "my.app.view.App" (fluent interface)
  auto rootView(string value) {
    _rootView = value;
    return this;
  }

  /// Adds a dependent UI5 library, e.g. dependency("sap.ui.layout") (fluent interface)
  auto dependency(string library) {
    _dependencies ~= library;
    return this;
  }

  /// Adds a data source, e.g. dataSource("mainService", "/odata/v2/main/") (fluent interface)
  auto dataSource(string name, string uri, string type = "OData") {
    _dataSources[name] = uri;
    _dataSourceTypes[name] = type;
    if (!_dataSourceOrder.canFind(name)) {
      _dataSourceOrder ~= name;
    }
    return this;
  }

  /// Adds a model, e.g. model("i18n", "sap.ui.model.resource.ResourceModel") (fluent interface)
  auto model(string name, string type, string dataSource = null) {
    _models[name] = type;
    if (dataSource.length > 0) {
      _modelDataSources[name] = dataSource;
    }
    if (!_modelOrder.canFind(name)) {
      _modelOrder ~= name;
    }
    return this;
  }

  /// Adds a route (fluent interface)
  auto route(Ui5Route value) {
    _routes ~= value;
    return this;
  }

  /// Adds a routing target (fluent interface)
  auto target(Ui5RouteTarget value) {
    _targets ~= value;
    return this;
  }

  /// All routes
  Ui5Route[] routes() {
    return _routes.dup;
  }

  /// All routing targets
  Ui5RouteTarget[] targets() {
    return _targets.dup;
  }

  /// Renders the descriptor as a Json object
  // @trusted: Json construction is memory-safe here
  @trusted Json toJson() const {
    auto sapApp = Json.emptyObject;
    sapApp["id"] = _id;
    sapApp["type"] = "application";
    if (_title.length > 0) {
      sapApp["title"] = _title;
    }
    if (_description.length > 0) {
      sapApp["description"] = _description;
    }
    if (_appVersion.length > 0) {
      sapApp["applicationVersion"] = Json.emptyObject;
      sapApp["applicationVersion"]["version"] = _appVersion;
    }
    if (_dataSourceOrder.length > 0) {
      auto dataSources = Json.emptyObject;
      foreach (name; _dataSourceOrder) {
        auto source = Json.emptyObject;
        source["uri"] = _dataSources[name];
        source["type"] = _dataSourceTypes[name];
        dataSources[name] = source;
      }
      sapApp["dataSources"] = dataSources;
    }

    auto sapUi5 = Json.emptyObject;
    if (_minUi5Version.length > 0) {
      sapUi5["minUI5Version"] = _minUi5Version;
    }
    if (_rootView.length > 0) {
      auto rootView = Json.emptyObject;
      rootView["viewName"] = _rootView;
      rootView["type"] = "XML";
      rootView["id"] = "app";
      sapUi5["rootView"] = rootView;
    }
    if (_dependencies.length > 0) {
      auto libs = Json.emptyObject;
      foreach (library; _dependencies) {
        libs[library] = Json.emptyObject;
      }
      auto dependencies = Json.emptyObject;
      dependencies["libs"] = libs;
      sapUi5["dependencies"] = dependencies;
    }
    if (_modelOrder.length > 0) {
      auto models = Json.emptyObject;
      foreach (name; _modelOrder) {
        auto modelJson = Json.emptyObject;
        modelJson["type"] = _models[name];
        if (auto dataSource = name in _modelDataSources) {
          modelJson["dataSource"] = *dataSource;
        }
        models[name] = modelJson;
      }
      sapUi5["models"] = models;
    }
    if (_routes.length > 0 || _targets.length > 0) {
      auto routing = Json.emptyObject;
      auto routes = Json.emptyArray;
      foreach (route; _routes) {
        auto routeJson = Json.emptyObject;
        routeJson["pattern"] = route.pattern;
        auto targetArray = Json.emptyArray;
        foreach (target; route.targets) {
          targetArray ~= Json(target);
        }
        routeJson["target"] = targetArray;
        routes ~= routeJson;
      }
      routing["routes"] = routes;

      auto targets = Json.emptyObject;
      foreach (target; _targets) {
        auto targetJson = Json.emptyObject;
        targetJson["viewName"] = target.viewName;
        if (target.viewPath.length > 0) {
          targetJson["viewPath"] = target.viewPath;
        }
        if (target.viewLevel.length > 0) {
          targetJson["viewLevel"] = target.viewLevel.to!int;
        }
        if (target.controlId.length > 0) {
          targetJson["controlId"] = target.controlId;
        }
        if (target.controlAggregation.length > 0) {
          targetJson["controlAggregation"] = target.controlAggregation;
        }
        targets[target.name] = targetJson;
      }
      routing["targets"] = targets;
      sapUi5["routing"] = routing;
    }

    auto json = Json.emptyObject;
    json["_version"] = "1.58.0";
    json["sap.app"] = sapApp;
    json["sap.ui5"] = sapUi5;
    return json;
  }

  /// Renders the descriptor as a JSON string (content of manifest.json)
  // @trusted: Json serialization is memory-safe here
  @trusted override string toString() const {
    return toJson.toString;
  }

  private string _id;
  private string _title;
  private string _description;
  private string _appVersion;
  private string _minUi5Version;
  private string _rootView;
  private string[] _dependencies;
  private string[string] _dataSources;
  private string[string] _dataSourceTypes;
  private string[] _dataSourceOrder;
  private string[string] _models;
  private string[string] _modelDataSources;
  private string[] _modelOrder;
  private Ui5Route[] _routes;
  private Ui5RouteTarget[] _targets;
}

/// Creates a UI5 app descriptor, e.g. ui5AppManifest("my.app")
Ui5AppManifest ui5AppManifest(string id) {
  return new Ui5AppManifest(id);
}

///
unittest {
  // route structs
  auto route = ui5Route("detail/{id}", "detail");
  assert(route.pattern == "detail/{id}");
  assert(route.targets == ["detail"]);

  auto target = ui5RouteTarget("detail", "Detail", "my.app.view");
  assert(target.name == "detail");
  assert(target.viewName == "Detail");
  assert(target.viewPath == "my.app.view");

  // minimal descriptor
  auto minimal = ui5AppManifest("my.app");
  auto minimalJson = minimal.toJson;
  assert(minimal.id == "my.app");
  assert(minimalJson["_version"].get!string == "1.58.0");
  assert(minimalJson["sap.app"]["id"].get!string == "my.app");
  assert(minimalJson["sap.app"]["type"].get!string == "application");
  assert(!("routing" in minimalJson["sap.ui5"]));

  // full descriptor
  auto manifest = ui5AppManifest("my.app")
    .title("My App")
    .description("A test app")
    .appVersion("1.0.0")
    .minUi5Version("1.120.0")
    .rootView("my.app.view.App")
    .dependency("sap.m")
    .dependency("sap.ui.layout")
    .dataSource("mainService", "/odata/v2/main/")
    .model("i18n", "sap.ui.model.resource.ResourceModel")
    .model("", "sap.ui.model.odata.v2.ODataModel", "mainService")
    .route(ui5Route("", "home"))
    .route(ui5Route("detail/{id}", "detail"))
    .target(ui5RouteTarget("home", "Home"))
    .target(ui5RouteTarget("detail", "Detail", "my.app.view"));

  assert(manifest.routes.length == 2);
  assert(manifest.targets.length == 2);

  auto json = manifest.toJson;
  assert(json["sap.app"]["title"].get!string == "My App");
  assert(json["sap.app"]["applicationVersion"]["version"].get!string == "1.0.0");
  assert(json["sap.app"]["dataSources"]["mainService"]["uri"].get!string == "/odata/v2/main/");
  assert(json["sap.app"]["dataSources"]["mainService"]["type"].get!string == "OData");

  auto sapUi5 = json["sap.ui5"];
  assert(sapUi5["minUI5Version"].get!string == "1.120.0");
  assert(sapUi5["rootView"]["viewName"].get!string == "my.app.view.App");
  assert(sapUi5["rootView"]["type"].get!string == "XML");
  assert("sap.m" in sapUi5["dependencies"]["libs"]);
  assert("sap.ui.layout" in sapUi5["dependencies"]["libs"]);
  assert(sapUi5["models"]["i18n"]["type"].get!string == "sap.ui.model.resource.ResourceModel");
  assert(sapUi5["models"][""]["dataSource"].get!string == "mainService");

  auto routing = sapUi5["routing"];
  assert(routing["routes"].length == 2);
  assert(routing["routes"][0]["pattern"].get!string == "");
  assert(routing["routes"][1]["target"].length == 1);
  assert(routing["targets"]["home"]["viewName"].get!string == "Home");
  assert(routing["targets"]["detail"]["viewPath"].get!string == "my.app.view");

  // JSON string contains the id
  assert(manifest.toString.canFind(`"id":"my.app"`));
}
