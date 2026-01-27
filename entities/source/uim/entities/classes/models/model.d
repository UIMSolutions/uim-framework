module uim.entities.classes.model;

import uim.entities;

@safe:
class DModel : IModel { 
  this() { this.name("Model").className("Model"); }
  this(Json configSettings) { this().initialize(configSettings); }
  this(IModelManager aManager, Json configSettings = Json(null)) { this().manager(aManager).initialize(configSettings); }

  this(string aName, Json configSettings = Json(null)) { this(configSettings).name(aName); }
  this(STRINGAA someParameters, Json configSettings = Json(null)) { this(configSettings).parameters(someParameters); }

  this(IModelManager aManager, string aName, Json configSettings = Json(null)) { this(aManager, configSettings).name(aName); }
  this(IModelManager aManager, STRINGAA someParameters, Json configSettings = Json(null)) { this(aManager, configSettings).parameters(someParameters); }

  this(string aName, STRINGAA someParameters, Json configSettings = Json(null)) { this(name, configSettings).parameters(someParameters); }
  this(IModelManager aManager, string aName, STRINGAA someParameters, Json configSettings = Json(null)) { this(aManager, name, configSettings).parameters(someParameters); }

  void initialize(Json configSettings = Json(null)) {}


  private string _name;
  string name() const { return _name; }
  auto name(string value) { _name = value; return this; }

  private string _className;
  string className() const { return _className; }
  auto className(string value) { _className = value; return this; }

  private string _registerPath;
  string registerPath() const { return _registerPath; }
  auto registerPath(string value) { _registerPath = value; return this; }

  private IModelManager _manager;
  IModelManager manager() const { return _manager; }
  auto manager(IModelManager value) { _manager = value; return this; }

  private STRINGAA _parameters;
  STRINGAA parameters() const { return _parameters; }
  auto parameters(STRINGAA value) { _parameters = value; return this; }

  /**
    * Default config
    * These are merged with user-provided config when the component is used.
    */
  mixin(OProperty!("IData[string]", "defaultConfig"));

  // Configuration of model
  mixin(OProperty!("IData[string]", "config"));

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