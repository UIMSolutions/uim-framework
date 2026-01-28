module uim.entities.classes.models.model;

import uim.entities;

@safe:
class DModel : UIMObject, IModel { 
  this() { this.name("Model").className("Model"); }
  this(Json configSettings) { this().initialize(configSettings); }
  this(IModelManager aManager, Json configSettings = Json(null)) { this().manager(aManager).initialize(configSettings); }

  this(string name, Json configSettings = Json(null)) { this(configSettings).name(name); }
  this(string[string] someParameters, Json configSettings = Json(null)) { this(configSettings).parameters(someParameters); }

  this(IModelManager aManager, string name, Json configSettings = Json(null)) { this(aManager, configSettings).name(name); }
  this(IModelManager aManager, string[string] someParameters, Json configSettings = Json(null)) { this(aManager, configSettings).parameters(someParameters); }

  this(string name, string[string] someParameters, Json configSettings = Json(null)) { this(name, configSettings).parameters(someParameters); }
  this(IModelManager aManager, string name, string[string] someParameters, Json configSettings = Json(null)) { this(aManager, name, configSettings).parameters(someParameters); }
  void initialize(Json configSettings = Json(null)) {}

  protected string _name;
  string name() const { return _name; }
  auto name(string value) { _name = value; return this; }

  protected string _className;
  string className() const { return _className; }
  auto className(string value) { _className = value; return this; }

  protected string _registerPath;
  string registerPath() const { return _registerPath; }
  auto registerPath(string value) { _registerPath = value; return this; }

  protected IModelManager _manager;
  IModelManager manager() const { return _manager; }
  auto manager(IModelManager value) { _manager = value; return this; }

  protected string[string] _parameters;
  string[string] parameters() const { return _parameters; }
  auto parameters(string[string] value) { _parameters = value; return this; }

  /**
    * Default config
    * These are merged with user-provided config when the component is used.
    */
  protected IData[string] _defaultConfig;
  IData[string] defaultConfig() const { return _defaultConfig; }
  auto defaultConfig(IData[string] value) { _defaultConfig = value; return this; }

  // Configuration of model
  protected IData[string] _config;
  IData[string] config() const { return _config; }
  auto config(IData[string] value) { _config = value; return this; }

  DModel create() {
    return Model;
  }
  DModel copy() {
    auto result = create;
    // result.fromJson(this.toJson);
    return result;
  }  
}
mixin(ModelCalls!("Model", "DModel"));

version(test_uim_models) { unittest { 
  assert(Model);
  assert(Model.name == "Model");
}} 