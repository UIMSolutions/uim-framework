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
    this.attribute(attribute);
  }

  this(IAttribute attribute, Json initData) {
    super(initData);
    this.attribute(attribute);
  }

  this(IAttribute attribute, Json[string] initData) {
    super(initData);
    this.attribute(attribute);
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
  @property IAttribute attribute() const {
    return _attribute;
  }

  @property void attribute(IAttribute attribute) {
    _attribute = attribute;
  }

  protected bool _isBoolean;
  @property bool isBoolean() const {
    return _isBoolean;
  }

  @property void isBoolean(bool v) {
    _isBoolean = v;
  }

  protected bool _isInteger;
  @property bool isInteger() const {
    return _isInteger;
  }

  @property void isInteger(bool v) {
    _isInteger = v;
  }

  protected bool _isDouble;
  @property bool isDouble() const {
    return _isDouble;
  }

  @property void isDouble(bool v) {
    _isDouble = v;
  }

  protected bool _isLong;
  @property bool isLong() const {
    return _isLong;
  }

  @property void isLong(bool v) {
    _isLong = v;
  }

  protected bool _isTime;
  @property bool isTime() const {
    return _isTime;
  }

  @property void isTime(bool v) {
    _isTime = v;
  }

  protected bool _isDate;
  @property bool isDate() const {
    return _isDate;
  }

  @property void isDate(bool v) {
    _isDate = v;
  }

  protected bool _isDatetime;
  @property bool isDatetime() const {
    return _isDatetime;
  }

  @property void isDatetime(bool v) {
    _isDatetime = v;
  }

  protected bool _isTimestamp;
  @property bool isTimestamp() const {
    return _isTimestamp;
  }

  @property void isTimestamp(bool v) {
    _isTimestamp = v;
  }

  protected bool _isString;
  @property bool isString() const {
    return _isString;
  }

  @property void isString(bool v) {
    _isString = v;
  }

  protected bool _isScalar;
  @property bool isScalar() const {
    return _isScalar;
  }

  @property void isScalar(bool v) {
    _isScalar = v;
  }

  protected bool _isArray;
  @property bool isArray() const {
    return _isArray;
  }

  @property void isArray(bool v) {
    _isArray = v;
  }

  protected bool _isObject;
  @property bool isObject() const {
    return _isObject;
  }

  @property void isObject(bool v) {
    _isObject = v;
  }

  protected bool _isEntity;
  @property bool isEntity() const {
    return _isEntity;
  }

  @property void isEntity(bool v) {
    _isEntity = v;
  }

  protected bool _isUUID;
  @property bool isUUID() const {
    return _isUUID;
  }

  @property void isUUID(bool v) {
    _isUUID = v;
  }

  protected bool _isReadOnly;
  @property bool isReadOnly() const {
    return _isReadOnly;
  }

  @property void isReadOnly(bool v) {
    _isReadOnly = v;
  }

  protected bool _isNullable;
  @property bool isNullable() const {
    return _isNullable;
  }

  @property void isNullable(bool v) {
    _isNullable = v;
  }

  // #region isNull
  protected bool _isNull;
  bool isNull() {
    if (isNullable)
      return isNull;
    return false;
  }

  O isNull(this O)(bool newNull) {
    if (isNullable)
      _isNull = newNull;
    return cast(O)this;
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

  abstract UIMValue copy();

  Json toJson() {
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
  auto value = new UIMValue;
  assert(!value.isNull);
  assert(!value.isString);
  assert(!value.isInteger);
  assert(!value.isBoolean);
  assert(!value.isDouble);
  assert(!value.isNullable);
  assert(!value.isObject);
  assert(!value.isArray);
}
