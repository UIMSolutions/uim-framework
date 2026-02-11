/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.value;

import uim.entities;

mixin(ShowModule!());

@safe:
class UIMValue : UIMObject, IValue {
  this() {
    initialize();
  }

  this(IAttribute attribute) {
    super();
    _attribute = attribute;
  }

  this(IAttribute attribute, Json initData) {
    super(initData);
    _attribute = attribute;
  }

  this(IAttribute attribute, Json[string] initData) {
    super(initData);
    _attribute = attribute;
  }

  // Hook
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // --- Explicit property getters and setters for marked fields ---
  protected IAttribute _attribute;
  // TODO: 
  // uim.entities.interfaces.attribute.IAttribute attribute() const {
  //   return _attribute;
  // }

  // void attribute(uim.entities.interfaces.attribute.IAttribute attribute) {
  //   _attribute = attribute;
  // }

  protected bool _isBoolean;
  bool isBoolean() const {
    return _isBoolean;
  }

  IValue isBoolean(bool v) {
    _isBoolean = v;
    return this;
  }

  protected bool _isInteger;
  bool isInteger() const {
    return _isInteger;
  }

  IValue isInteger(bool v) {
    _isInteger = v;
    return this;
  }

  protected bool _isDouble;
  bool isDouble() const {
    return _isDouble;
  }

  IValue isDouble(bool v) {
    _isDouble = v;
    return this;
  }

  protected bool _isLong;
  bool isLong() const {
    return _isLong;
  }

  IValue isLong(bool v) {
    _isLong = v;
    return this;
  }

  protected bool _isTime;
  bool isTime() const {
    return _isTime;
  }

  IValue isTime(bool v) {
    _isTime = v;
    return this;
  }

  protected bool _isDate;
  bool isDate() const {
    return _isDate;
  }

  IValue isDate(bool v) {
    _isDate = v;
    return this;
  }

  protected bool _isDatetime;
  bool isDatetime() const {
    return _isDatetime;
  }

  IValue isDatetime(bool v) {
    _isDatetime = v;
    return this;
  }

  protected bool _isTimestamp;
  bool isTimestamp() const {
    return _isTimestamp;
  }

  IValue isTimestamp(bool v) {
    _isTimestamp = v;
    return this;
  }

  protected bool _isString;
  bool isString() const {
    return _isString;
  }

  IValue isString(bool v) {
    _isString = v;
    return this;
  }

  protected bool _isScalar;
  bool isScalar() const {
    return _isScalar;
  }

  IValue isScalar(bool v) {
    _isScalar = v;
    return this;
  }

  protected bool _isArray;
  bool isArray() const {
    return _isArray;
  }

  IValue isArray(bool v) {
    _isArray = v;
    return this;
  }

  protected bool _isObject;
  bool isObject() const {
    return _isObject;
  }

  IValue isObject(bool v) {
    _isObject = v;
    return this;
  }

  protected bool _isEntity;
  bool isEntity() const {
    return _isEntity;
  }

  IValue isEntity(bool v) {
    _isEntity = v;
    return this;
  }

  protected bool _isUUID;
  bool isUUID() const {
    return _isUUID;
  }

  IValue isUUID(bool v) {
    _isUUID = v;
    return this;
  }

  protected bool _isReadOnly;
  bool isReadOnly() const {
    return _isReadOnly;
  }

  IValue isReadOnly(bool v) {
    _isReadOnly = v;
    return this;
  }

  protected bool _isNullable;
  bool isNullable() const {
    return _isNullable;
  }

  IValue isNullable(bool v) {
    _isNullable = v;
    return this;
  }

  // #region isNull
  protected bool _isNull;
  bool isNull() {
    if (isNullable)
      return isNull;
    return false;
  }

  IValue isNull(bool newNull) {
    if (isNullable)
      _isNull = newNull;
    return this;
  }
  // #endregion isNull
  // #endregion properties 

  protected void set(Json newValue) {
    // TODO
  }

  void set(string newValue) {
    // TODO
  }

  O value(this O)(string newValue) {
    this.set(newValue);
    return cast(O)this;
  }

  O value(this O)(Json newValue) {
    this.set(newValue);
    return cast(O)this;
  }

  alias opEquals = Object.opEquals;
  bool opEquals(string equalValue) {
    return (toString == equalValue);
  }

  bool opEquals(UIMValue equalValue) {
    return (toString == equalValue.toString);
  }

  bool opEquals(UUID equalValue) {
    return false;
  }

  O opCall(this O)(UIMAttribute newAttribute) {
    this.attribute(newAttribute);
    return cast(O)this;
  }

  O opCall(this O)(Json newData) {
    this.fromJson(newData);
    return cast(O)this;
  }

  O opCall(this O)(UIMAttribute newAttribute, Json newData) {
    this.attribute(newAttribute).fromJson(newData);
    return cast(O)this;
  }

  UIMValue copy() {
    UIMValue copy = new UIMValue();
    copy._attribute = this._attribute;
    copy._isBoolean = this._isBoolean;
    copy._isInteger = this._isInteger;
    copy._isDouble = this._isDouble;
    copy._isLong = this._isLong;
    copy._isTime = this._isTime;
    copy._isDate = this._isDate;
    copy._isDatetime = this._isDatetime;
    copy._isTimestamp = this._isTimestamp;
    copy._isString = this._isString;
    copy._isScalar = this._isScalar;
    copy._isArray = this._isArray;
    copy._isObject = this._isObject;
    copy._isEntity = this._isEntity;
    copy._isUUID = this._isUUID;
    copy._isReadOnly = this._isReadOnly;
    copy._isNullable = this._isNullable;
    copy._isNull = this._isNull;
    return copy;
  }

  override Json toJson() {
    return Json(null);
  }

  override Json toJson(string[] showKeys) {
    return Json(null);
  }

  override Json toJson(string[] showKeys, string[] hideKeys) {
    return Json(null);
  }

  override string toString() {
    return null;
  }

  void fromString(string newValue) {
  }
}
///
unittest {
  import uim.entities.classes.values.value; 

  UIMValue v = new UIMValue();
  assert(v.isBoolean == false);
  v.isBoolean = true;
  assert(v.isBoolean == true);  

  assert(v.isInteger == false);
  v.isInteger = true;
  assert(v.isInteger == true);  

  assert(v.isDouble == false);
  v.isDouble = true;
  assert(v.isDouble == true); 

  assert(v.isLong == false);
  v.isLong = true;
  assert(v.isLong == true);

  assert(v.isTime == false);
  v.isTime = true;
  assert(v.isTime == true); 

  assert(v.isDate == false);
  v.isDate = true;
  assert(v.isDate == true); 

  assert(v.isDatetime == false);
  v.isDatetime = true;
  assert(v.isDatetime == true);

  assert(v.isTimestamp == false);
  v.isTimestamp = true;
  assert(v.isTimestamp == true);  

  assert(v.isString == false);
  v.isString = true;
  assert(v.isString == true);

  assert(v.isScalar == false);
  v.isScalar = true;
  assert(v.isScalar == true);

  assert(v.isArray == false);
  v.isArray = true;
  assert(v.isArray == true);

  assert(v.isObject == false);
  v.isObject = true;
  assert(v.isObject == true);

  assert(v.isEntity == false);
  v.isEntity = true;
  assert(v.isEntity == true);

  assert(v.isUUID == false);
  v.isUUID = true;
  assert(v.isUUID == true);

  assert(v.isReadOnly == false);
  v.isReadOnly = true;
  assert(v.isReadOnly == true);

  assert(v.isNullable == false);
  v.isNullable = true;
  assert(v.isNullable == true);

  assert(v.isNull == false);
  v.isNull = true;
  assert(v.isNull == true);

  assert(v.isNull == false);
  v.isNull = true;
  assert(v.isNull == true);

  assert(v.toString == null);
  v.fromString("test");
  assert(v.toString == "test");

  UIMValue v2 = v.copy();
  assert(v2.toString == "test");
}