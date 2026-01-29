/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.arrays.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringArrayValue : ArrayValue {
  this() {
    super;
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isString(true)
      .separator(",");
  }

  mixin(OProperty!("string", "separator"));
  mixin(OProperty!("bool", "shouldTrim"));

  protected string[] _values;
  alias value = UIMValue.value;
  void set(string[] newValues) {
    _values = newValues.filter!(v => v.length > 0).array;
  }
  O value(this O)(string[] newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  string[] value() {
    return _values; 
  }

  override void set(string newValue) {
    auto myValues = newValue.split(separator);
    if (shouldTrim) {
      myValues = myValues.map!(a => a.strip).array;
    } 
    this.value(myValues);
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) this.value(cast(string[])null);
    switch(newValue.type) {
      case Json.Type.string: 
        /* return  */this.value(newValue.get!string); 
        break;
      case Json.Type.array: 
        /* return  */this.value(newValue.get!(Json[]).map!(a => a.get!string).array);
        break; 
      //case Json.Type.object: 
        /* return  this.fromJson(newValue); */
        // break; 
      default: break;
    }
    // return this;
  }

  override UIMValue copy() {
    return StringArrayValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  override Json toJson() {
    auto result = Json.emptyArray;
    _values.each!(v => result ~= Json(v));
    return result;
  }
  override string toString() {
    return this.value.join(",");
  }
}