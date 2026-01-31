/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.scalars.boolean;

import uim.entities;

mixin(ShowModule!());

@safe:
class BooleanValue : UIMValue {
  this() {
    super();
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this
      .isBoolean(true);
  }

  @property int get() {
    return value;
  }
  // alias get this;

  O opCall(this O)(bool newValue) { this.value(newValue); return cast(O)this; }

  protected bool _value;
  alias value = UIMValue.value;
  O value(this O)(bool newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  bool value() {
    return _value; 
  }

  void set(bool newValue) {
    _value = newValue;
  }
  override void set(string newValue) {
    _value = (newValue.toLower == "true") || (newValue.toLower == "on") || (newValue.toLower == "1"); 
  }
  override void set(Json newValue) {
    if (newValue.isEmpty) { 
      this
        .value(false) 
        .isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!bool)
        .isNull(false);
    }
  }

  alias opEquals = UIMValue.opEquals;
  bool opEquals(bool otherValue) {
    return (_value == otherValue);
  }
  override bool opEquals(string otherValue) {
    return (_value ? otherValue.toLower == "true" : otherValue.toLower == "false");
  }

  alias opCmp = Object.opCmp;
  int opCmp(bool aValue) {
    if (_value < aValue) return -1;
    if (_value == aValue) return 0;
    return 1;
  }
  ///
  unittest {
    auto valueA = new BooleanValue(true);
    auto valueB = new BooleanValue(false);
    assert(valueA > false);
    assert(valueB < true);
  }

  int opCmp(BooleanValue aValue) {
    if (aValue) {
      return opCmp(aValue.value);
    }
    return -1;
  }

  ///
  unittest {
    auto valueA = new BooleanValue(true);
    auto valueB = new BooleanValue(false);
    assert(valueA > valueB);
    assert(valueB < valueA);

    auto valueC = (new BooleanValue).value(true);
    auto valueD = (new BooleanValue).value(false);
    assert(valueC > valueD);
    assert(valueD < valueC);
  }
  
  override UIMValue copy() {
    return new BooleanValue(attribute, toJson);
  }
  bool toBool() { 
    return _value; }

  override Json toJson() { 
    if (this.isNull) return Json(null); 
    return Json(this.value); }

  override string toString() { 
    if (isNull) return null; 
    return to!string(this.value); }
}


/* boolean

Optional<DynamicConstantDesc<Boolean>>
describeConstable()
Returns an Optional containing the nominal descriptor for this instance.
boolean
equals(Object obj)
Returns true if and only if the argument is not null and is a Boolean object that represents the same boolean value as this object.
static boolean
getBoolean(String name)
Returns true if and only if the system property named by the argument exists and is equal to, ignoring case, the string "true".
int
hashCode()
Returns a hash code for this Boolean object.
static int
hashCode(boolean value)
Returns a hash code for a boolean value; compatible with Boolean.hashCode().
static boolean
logicalAnd(boolean a, boolean b)
Returns the result of applying the logical AND operator to the specified boolean operands.
static boolean
logicalOr(boolean a, boolean b)
Returns the result of applying the logical OR operator to the specified boolean operands.
static boolean
logicalXor(boolean a, boolean b)
Returns the result of applying the logical XOR operator to the specified boolean operands.
static boolean
parseBoolean(String s)
Parses the string argument as a boolean.
String
toString()
Returns a String object representing this Boolean's value.
static String
toString(boolean b)
Returns a String object representing the specified boolean.
static Boolean
valueOf(boolean b)
Returns a Boolean instance representing the specified boolean value.
static Boolean
valueOf(String s)
Returns a Boolean with a value represented by the specified string.
 */