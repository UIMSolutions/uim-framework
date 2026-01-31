/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.scalars.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringValue : UIMValue {
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
      .isString(true);
  }

  mixin(OProperty!("size_t", "maxLength"));

  protected string _value;
  @property string value(){
    if (maxLength > 0 && _value.length > maxLength) {
      return _value[0..maxLength]; }
    else {
      return _value;
    }
  }
  /// Set with string value
  O value(this O)(string newValue) {
    set(newValue);
    return cast(O)this;
  }
  ///
  unittest {    
    assert(StringValue.value("test").value == "test");
    assert(StringValue.value("test").value("test2").value == "test2");
  } 

  // Set with Json value
  O value(this O)(Json newValue) {
    set(newValue);
    return cast(O)this;
  }

  // Hooks for setting 
  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); }
    else {
      this.isNull(false);
    }
    _value = newValue;
  } 

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = null; 
      this.isNull(isNullable ? true : false); }
    else {
      _value = newValue.get!string;
      this.isNull(false);
    }
  }

  O value(this O)(DStringValue newValue) {
    if (newValue) {
      this
        .isNullable(newValue.isNullable)
        .isNull(newValue.isNull)
        .value(newValue.value);
    }
    return cast(O)this;
  }

  override UIMValue copy() {
    return StringValue(attribute, toJson);
  }

  version(test_uim_models) { unittest {    
    assert(StringValue("test").value == "test");

    assert(StringValue.value("test") == "test");
    assert(StringValue.value("test") < "xxxx");
    assert(StringValue.value("test") <= "xxxx");
    assert(StringValue.value("test") <= "test");
    assert(StringValue.value("test") > "aaaa");
    assert(StringValue.value("test") >= "aaaa");
    assert(StringValue.value("test") >= "test");    
  }}

  string opCall() { return _value; } 
  O opCall(this O)(string newValue) { 
    _value = newValue;
    return cast(O)this; }
  O opCall(this O)(Json newValue) { 
    if (newValue.type = Json.Type.string) _value = newValue.get!string;
    return cast(O)this; }
  O opCall(this O)(DStringValue newValue) {
    this.value(newValue);
    return cast(O)this; }

  ///
  unittest { 
    auto a = StringValue("aValue");
    auto b = StringValue("bValue");
    assert(a(b) == "bValue");
  }

  alias opEquals = UIMValue.opEquals;
  override bool opEquals(string otherValue) {
    return (_value == otherValue);
  }

  int opCmp(string otherValue) {
    if (_value < otherValue) return -1;
    if (_value == otherValue) return 0;
    return 1;
  }
  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(_value); }
  
  override string toString() { 
    if (isNull) return null; 
    return _value; }

  override void fromString(string newValue) { 
    this.value(newValue);
  }  
}