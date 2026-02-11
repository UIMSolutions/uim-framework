/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.datatypes.objects.classes.obj;

import uim.oop;

mixin(ShowModule!());

@safe:

/// Basic implementation of the IObject interface.
class UIMObject : IObject {
  // mixin TConfigurable;

  this() {
    this.initialize;
  }

  this(Json initData) {
    if (!initData.isObject)
      return;

    this.initialize(initData.toMap);
  }

  this(Json[string] initData) {
    this.initialize(initData);
  }

  this(string newName, Json[string] initData = null) {
    this.initialize(initData);
    objName(newName);
  }

  bool initialize(Json[string] initData = null) {
    objId(initData.hasKey("objId") ? UUID(initData["objId"].to!string) : randomUUID);
    objName(initData.hasKey("objName") ? initData["objName"].to!string : "Object");

    /* auto config = ConfigurationFactory.create("memory");
    configuration(config);
    configuration.entries(initData is null ? new Json[string] : initData);
    */
    return true;
  }

  // #region Object ID
  protected UUID _objId;
  /// Get the unique object ID.
  UUID objId() {
    return _objId;
  }
  /// 
  unittest {
    auto obj = new UIMObject;
    assert(obj.objId != NULLUUID);
  }

  /// Set the unique object ID.
  void objId(UUID newId) {
    _objId = newId;
  }
  ///
  unittest {
    // Test objId setter with valid UUID
    auto obj = new UIMObject;
    auto newId = randomUUID;
    obj.objId(newId);
    assert(obj.objId == newId);
  }
  // #endregion Object ID

  // #region object member
  /// Get the names of all members of the object.
  string[] objMemberNames() {
    return [__traits(allMembers, typeof(this))];
  }
  ///
  unittest {
    // Test memberNames returns non-empty array
    auto obj1 = new UIMObject;
    auto members1 = obj1.objMemberNames();
    assert(members1.length > 0);

    // Test memberNames contains expected base members
    auto obj2 = new UIMObject;
    auto members2 = obj2.objMemberNames();
    assert(members2.canFind("objName"));
    assert(members2.canFind("objId"));
    assert(members2.canFind("initialize"));
  }

  /** 
  Check if the object has all specified members. 
  
  Params: 
    names = The names to check 

  Returns: 
    Returns 'true' if all members exist, 'false' otherwise
  */
  bool hasAllMember(string[] names) {
    return names.all!(name => hasMember(name));
  }
  /// 
  unittest {
    // Test hasAllMembers with all existing members
    auto obj1 = new UIMObject;
    assert(obj1.hasAllMember(["objName", "objId"]), "Expected hasAllMember to return true when all members exist");

    // Test hasAllMember with some non-existing members
    auto obj2 = new UIMObject;
    assert(!obj2.hasAllMember(["objName", "nonExistentMember"]), "Expected hasAllMember to return false when at least one member does not exist");
  }

  /** 
  Check if the object has any of the specified members.

  Params: 
    names = The names to check

  Returns: 
    Returns 'true' if any member exists, 'false' otherwise
  */
  bool hasAnyMember(string[] names) {
    return names.any!(name => hasMember(name));
  }
  ///
  unittest {
    // Test hasAnyMember with at least one existing member
    auto obj1 = new UIMObject;
    assert(obj1.hasAnyMember(["objName", "nonExistentMember"]));

    // Test hasAnyMember with all existing members
    auto obj2 = new UIMObject;
    assert(obj2.hasAnyMember(["objName", "objId", "initialize"]));
  }

  /**
  Checks if the object has a member with the specified name.
  
  Params:
    checkName = The name of the member to search for.
  
  Returns:
    true if a member with the given name exists, false otherwise.
  */
  bool hasMember(string checkName) {
    return objMemberNames.any!(name => name == checkName);
  }
  ///
  unittest {
    auto obj1 = new UIMObject;
    assert(obj1.hasMember("objName")); // existing member
    assert(obj1.hasMember("objId")); // existing member
    assert(obj1.hasMember("initialize")); // existing member
    assert(!obj1.hasMember("nonExistentMember")); // non-existing member

    auto obj2 = new UIMObject;
    assert(!obj2.hasMember("ObjName")); // case sensitivity
    assert(obj2.hasMember("objName")); // correct case
  }
  // #region object member

  // #region object name
  protected string _objName;
  // Get the name of the object.
  string objName() {
    return _objName;
  }

  // Get or set the name of the object.
  void objName(string newName) {
    _objName = newName.dup;
  }
  // #endregion name

  void opIndexAssign(T)(T value, string key) {
    switch (key) {
    case "objId":
      this.objId(value);
    case "objName":
      this.objName(value);
    default:
      break;
    }
    return;
  }

  /* Json opIndex(string name) {
    switch (name) {
    case "objName":
      return objName.toJson;
    case "objClass":
      return this.objClass.toJson;
    case "classFullname":
      return this.classFullname.toJson;
    case "memberNames":
      return memberNames.toJson;
    default:
      return Json(null);
    }
  } */

  // #region toJson
  /** 
    * Converts the object to a JSON representation, including its name and class information
    * Returns:
    *   A JSON object representing the current object, including its name and class information.
  */
  Json toJson() {
    Json json = Json.emptyObject;
    json["objName"] = objName;
    json["objClass"] = this.classname;

    return json;
  }
  /// 
  unittest {
    auto obj = new UIMObject;
    obj.objName("TestObject");
    Json json = obj.toJson();
    assert(json["objName"] == "TestObject");
    assert(json["objClass"] == "UIMObject");
  }

  /** 
    * Converts the object to a JSON representation, allowing for selective inclusion of keys.
    *
    * Params:
    *   showKeys = An array of keys to include in the JSON output. If null, all keys are included.
    * 
    * Returns:
    *   A JSON object representing the current object, filtered according to the specified keys.

    * Behavior:
    *   - If showKeys is null, all keys from the default toJson() output are included.
    *   - If showKeys is provided, only the keys specified in showKeys are included in the output.
  */
  Json toJson(string[] showKeys) {
    return showKeys is null ? toJson() : toJson().filterKeys(showKeys);
  }
  /// 
  unittest {
    auto obj = new UIMObject;
    obj.objName("TestObject");
    Json json = obj.toJson(["objName"]);
    assert(json["objName"] == "TestObject");
    assert(!json.hasKey("objClass"));
  }

  /** 
    * Converts the object to a JSON representation, allowing for selective inclusion or exclusion of keys.
    *
    * Params:
    *   showKeys = An array of keys to include in the JSON output. If null, all keys are included.
    *   hideKeys = An array of keys to exclude from the JSON output. If null, no keys are excluded.
    * 
    * Returns:
    *   A JSON object representing the current object, filtered according to the specified keys.

    * Behavior:
    *   - If showKeys is null, all keys from the default toJson() output are included.
    *   - If showKeys is provided, only the keys specified in showKeys are included in the output.
    *   - If hideKeys is provided, the keys specified in hideKeys are removed from the output after applying the showKeys filter (if any).
    *   - If both showKeys and hideKeys are provided, the method first applies the showKeys filter and then removes any keys specified in hideKeys from the resulting JSON object.
  */  
  Json toJson(string[] showKeys, string[] hideKeys) {
    return hideKeys is null ? toJson(showKeys) : toJson(showKeys).removeKeys(hideKeys);
  }
  ///
  unittest {
    auto obj = new UIMObject;
    obj.objName("TestObject");
    Json json = obj.toJson(null, ["objClass"]);
    assert(json["objName"] == "TestObject");
    assert(!json.hasKey("objClass"));
  }
  // #endregion toJson

  // #region debugInfo
  /// Returns a JSON object containing debug information about the object, including its class name and optionally filtered properties
  Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    Json[string] info = toJson(showKeys, hideKeys).toMap;
    info["classFullname"] = this.classFullname;

    return info;
  }
  ///
  unittest {
    auto obj = new UIMObject;
    obj.objName("TestObject");
    Json[string] debugInfo = obj.debugInfo();
    assert(debugInfo["objName"] == "TestObject");
    writeln(debugInfo);
    assert(debugInfo["classFullname"] == "uim.oop.datatypes.objects.obj.UIMObject");
  }
  // #endregion debugInfo

  // #region IObject

  // Compares two IObject instances for equality based on their names.
  bool isEqual(IObject other) {
    if (this !is other) {
      return false;
    }
    if (this.objName is null || other.objName is null) {
      return false;
    }
    if (cast(IObject)other is null) {
      return false;
    }

    /*  if (this.classinfo !is other.classinfo) {
      return false;
    }
    if (other is null) {
      return false;
    } */
    return this.objName == other.objName;
    // TODO: Consider adding more properties for comparison if needed.
  }

  // Returns a string representation comparing two IObject instances.
  override string toString() {
    return "Object: " ~ this.objName;
  }

  // #region clone
  /** 
    * Creates a clone of the current object.
    *
    * Returns:
    *   A new instance of IObject that is a clone of the current object.
    *
    * Note:
    *   This implementation performs a shallow clone. If the object contains reference types (e.g., arrays, other objects), they will be shared between the original and the clone. For a deep clone, you would need to implement copying of all relevant properties to ensure that changes to the clone do not affect the original object.
  */
  IObject clone() {
    return new UIMObject(toJson().toMap);
  }
  ///
  unittest {
    auto obj1 = new UIMObject;
    obj1.objName("TestObject");
    auto obj2 = cast(UIMObject)obj1.clone();
    assert(obj2.objName == "TestObject");
    assert(obj2 !is obj1); // Ensure it's a different instance
  }
  // #endregion clone
  // #endregion IObject
}

class Test : UIMObject {
  this() {
    super();
  }

  string newMethod() {
    return null;
  }

  override string[] objMemberNames() {
    return [__traits(allMembers, typeof(this))];
  }
}

unittest {
  auto testObj = new Test;
  auto members = testObj.objMemberNames();
  assert(members.canFind("newMethod"), "Expected objMemberNames to include 'newMethod'");
  assert(members.canFind("objName"), "Expected objMemberNames to include 'objName' from UIMObject");
  assert(members.canFind("objId"), "Expected objMemberNames to include 'objId' from UIMObject");
  assert(members.canFind("initialize"), "Expected objMemberNames to include 'initialize' from UIMObject");
}
