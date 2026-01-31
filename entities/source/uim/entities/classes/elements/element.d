/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

module uim.entities.classes.elements.element;

import uim.entities;

mixin(ShowModule!());

@safe:
class UIMElement : UIMObject, IElement {
  // // static namespace = moduleName!UIMElement;

  // Constructors
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .values(new StringValueMap);

    this
      .requestPrefix("element_");

    return true;
  }

  protected StringValueMap _values;

  /// Getter for values
  /* StringValueMap values() const @property {
    return _values;
  }
  */

  /// Setter for values (chainable)
  UIMElement values(StringValueMap value) @property {
    _values = value;
    return this;
  }
  // mixin ValueMapWrapper;

  protected bool _isStatic;
  bool isStatic() const {
    return _isStatic;
  }

  auto isStatic(bool value) {
    _isStatic = value;
    return this;
  }

  protected string _className;
  string className() const {
    return _className;
  }

  auto className(string value) {
    _className = value;
    return this;
  }

  protected string _registerPath;
  string registerPath() const {
    return _registerPath;
  }

  auto registerPath(string value) {
    _registerPath = value;
    return this;
  }

  protected string _requestPrefix;
  string requestPrefix() const {
    return _requestPrefix;
  }

  auto requestPrefix(string value) {
    _requestPrefix = value;
    return this;
  }

  // Every element can have a name like an identifier. 
  string _name;
  O name(this O)(string newName) {
    _name = newName.strip.replace(" ", "_");
    return cast(O)this;
  }

  string name() {
    return _name;
  }
  ///
  unittest {
    assert(Entity.name("name1").name == "name1");
    assert(Entity.name("name1").name("name2").name == "name2");
    assert(Entity.name("name name").name == "name_name");
  }

  protected string[string] _parameters;
  string[string] parameters() const {
    return _parameters;
  }

  auto parameters(string[string] value) {
    _parameters = value;
    return this;
  }

  /*   // Display of entity 
  mixin(OProperty!("string", "display"));

  //	Description about the entity and more
  mixin(OProperty!("string", "description")); */

  string[string] selector(string[string] parameters) {
    string[string] results;

    foreach (key, val; parameters) {
      if (key.indexOf(requestPrefix) == 0) {
        results[key.replace(requestPrefix, "")] = val;
      } else {
        results[key] = val;
      }
    }

    return results;
  }
  ///
  unittest {
    // auto element = new UIMElement;
    // assert(element.selector(["x": "y", "element_id": "1234"]) == [
    //     "id": "1234",
    //     "x": "y"
    //   ]);
  }

  // Read data from string[string]
  // Implement IElement interface functions
  override void readFromMap(string[string] reqParameters, bool usePrefix = false) {
    reqParameters.byKeyValue.each!(kv => this[kv.key] = kv.value);
  }

  override void readFromRequest(string[string] requestValues, bool usePrefix = true) {
    auto myData = selector(requestValues);
    foreach (key, value; myData) {
      this[key] = value;
    }
  }

  // Returns data in string format (HTML compatible)
  string opIndex(string key) {
    switch (key) {
    case "className":
      return className;
    case "requestPrefix":
      return requestPrefix;
    case "registerPath":
      return registerPath;
    default:
      if (auto value = valueOfKey(key)) {
        return value.toString;
      }
      break;
    }
    return null;
  }

  // Set data 
  void opIndexAssign(UIMValue newValue, string key) {
    if (!isStatic) { // can add new values and change datatypes
      values[key] = newValue;
    } else { // Not dynamic
      if (auto myValue = valueOfKey(key)) {
        myValue.value(newValue.toJson);
      }
    }
  }
  ///
  unittest {
    auto value = (new StringAttribute).createValue;
    value.set("aValue");
    assert(value.toString == "aValue");

    auto element = new UIMElement;
    element["test"] = value;

    assert(element["test"] == "aValue");
  }

  // Set data 
  void opIndexAssign(Json newValue, string key) {
    if (auto myValue = valueOfKey(key)) {
      // TODO myValue.set(newValue);
      return;
    }

    /*     if (!isStatic) { // can add new values
      switch(newValue.type) {
        case Json.Type.string: 
          this.value(newValue.get!string); 
        break;

              auto myValue = StringAttribute.createValue;
      myValue.set(newValue);
      values[key] = myValue;
    }
 */
  }
  ///
  unittest {
    auto element = new UIMElement;
    element.addValues(["test": StringAttribute]);
    element["test"] = "something";
    assert(element["test"] == "something");
    assert(element["test"] != "a thing");
  }

  // Set data 
  void opIndexAssign(string newValue, string key) {
    switch (key) {
    case "className":
      this.className(newValue);
      break;
    case "name":
      this.name(newValue);
      break;
    case "requestPrefix":
      this.requestPrefix(newValue);
      break;
    case "registerPath":
      this.registerPath(newValue);
      break;
    default:
      if (auto myValue = valueOfKey(key)) {
        myValue.set(newValue);
        return;
      }

      if (!isStatic) { // can add new values
        auto myValue = new StringAttribute.createValue;
        myValue.set(newValue);
        values[key] = myValue;
      }
      break;
    }
  }
  ///
  unittest {
    // auto element = new UIMElement;
    // element.addValues(["test": StringAttribute]);
    // element["test"] = "something";
    // assert(element["test"] == "something");
    // assert(element["test"] != "a thing");
  }

  UIMValue valueOfKey(string key) {
    if (auto myValue = values[key]) {
      return myValue;
    }

    if (auto keys = key.split(".")) {
      if (keys.length == 1) {
        return values[key];
      }

      UIMValue myValue = values[keys[0]];
      if (auto myElementValue = cast(ElementValue)myValue) {
        myValue = myElementValue.value.valueOfKey(keys[1 .. $].join("."));
      }
      return myValue;
    }

    return null;
  }
  ///
  unittest {
    auto element2 = new UIMElement;
    element2.addValues(["level2": StringAttribute]);
    element2["level2"] = "valueLevel2";

    auto value2 = new ElementValue;
    value2.set(element2);

    auto element1 = new UIMElement;
    element1["level1"] = value2;

    assert(element1["level1.level2"] == "valueLevel2");
  }

  // Set UUID value
  void opIndexAssign(UUID value, string key) {
    if (auto myValue = cast(UUIDValue)valueOfKey(key)) {
      // values[key] exists and value of DUUIDValue
      myValue.value = value;
    }
  }

  // Set long value
  void opIndexAssign(long value, string key) {
    if (auto myValue = cast(LongValue)valueOfKey(key)) {
      // values[key] exists and value of LongValue
      myValue.value = value;
    }
  }

  // Set bool value
  void opIndexAssign(bool value, string key) {
    if (auto myValue = cast(BooleanValue)valueOfKey(key)) {
      // values[key] exists and value of BooleanValue
      myValue.value = value;
    }
  }

  // Set field(key) if type Entity
  void opIndexAssign(UIMElement value, string key) {
    if (auto myValue = cast(ElementValue)valueOfKey(key)) {
      // values[key] exists and value of ElementValue
      myValue.value = value;
    }
  }

  UIMElement create() {
    return new UIMElement;
  }

  UIMElement create(Json data) {
    auto myElement = create;
    myElement.fromJson(data);
    return myElement;
  }

  override UIMElement clone() {
    return create(toJson);
  }

  UIMElement clone(Json data) {
    auto myElement = create(toJson);
    myElement.fromJson(data);
    return myElement;
  }

  UIMElement copyTo(UIMElement targetOfCopy) {
    if (targetOfCopy) {
      targetOfCopy.fromJson(this.toJson);
    }
    return targetOfCopy;
  }

  UIMElement copyFrom(UIMElement targetOfCopy) {
    if (targetOfCopy) {
      fromJson(targetOfCopy.toJson);
    }
    return this;
  }

  Bson toBson() {
    return Bson(toJson);
  }

  void fromJson(Json json) {
    if (!json.isObject) {
      return;
    }

    foreach (key, value; json.toMap) {
      switch (key) {
      case "className":
        this.className(value.getString);
        break;
      case "name":
        this.name(value.getString);
        break;
      case "requestPrefix":
        this.requestPrefix(value.getString);
        break;
      case "registerPath":
        this.registerPath(value.getString);
        break;
      default:
        this.values[key].value(value);
        break;
      }
    }
  }

  override Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = Json.emptyObject;

    result["name"] = this.name;

    values.keys.each!(k => result[k] = this.values[k].toJson);

    return result;
  }

  override string toString() {
    return toJson.toString;
  }
}

auto createElement() {
  return new UIMElement;
}

auto createElement(string name) {
  return new UIMElement(name);
}

auto createElement(Json json) {
  return new UIMElement(json);
}
/// 
unittest {
  auto element = createElement();
  assert(element.name("test").name == "test");
  assert(element.name("testName").name == "testname");
}
