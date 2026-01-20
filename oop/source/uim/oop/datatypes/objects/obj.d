/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.datatypes.objects.obj;

import uim.oop;

mixin(ShowModule!());

@safe:

/// Basic implementation of the IObject interface.
class UIMObject : IObject {
  // mixin TConfigurable;

  this() {
    this.initialize;
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

  Json toJson(string[] showKeys = null, string[] hideKeys = null) {
    Json json = Json.emptyObject;
    json["objName"] = objName;
    json["objClass"] = this.classname;

    return json;
  }

  // #region debugInfom
  // Provides debug information about the object.
  Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    Json[string] info = toJson().toMap;
    info["classFullname"] = this.classFullname;

    return info;
  }
  // #region debugInfo

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

  // Creates a clone of the current object.
  IObject clone() {
    return new UIMObject(toJson().toMap);
  }
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
  //   auto obj = new IMObject;

}
