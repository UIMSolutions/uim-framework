/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.attribute;

import uim.entities;

@safe:
class DAttribute : UIMObject, IAttribute {
    // --- Explicit property getters and setters for marked fields ---
    @property UUID id() const { return _id; }
    @property void id(UUID v) { _id = v; }

    @property string name() const { return _name; }
    @property void name(string v) { _name = v; }

    @property string display() const { return _display; }
    @property void display(string v) { _display = v; }

    @property string registerPath() const { return _registerPath; }
    @property void registerPath(string v) { _registerPath = v; }

    @property bool isNullable() const { return _isNullable; }
    @property void isNullable(bool v) { _isNullable = v; }

    @property string[string] descriptions() const { return _descriptions; }
    @property void descriptions(string[string] v) { _descriptions = v; }

    @property string valueType() const { return _valueType; }
    @property void valueType(string v) { _valueType = v; }

    @property string keyType() const { return _keyType; }
    @property void keyType(string v) { _keyType = v; }

    @property string dataType_display() const { return _dataType_display; }
    @property void dataType_display(string v) { _dataType_display = v; }

    @property long defaultValueLong() const { return _defaultValueLong; }
    @property void defaultValueLong(long v) { _defaultValueLong = v; }

    @property string defaultValueString() const { return _defaultValueString; }
    @property void defaultValueString(string v) { _defaultValueString = v; }

    @property string baseDynamicPropertyId() const { return _baseDynamicPropertyId; }
    @property void baseDynamicPropertyId(string v) { _baseDynamicPropertyId = v; }

    @property string overwrittenDynamicPropertyId() const { return _overwrittenDynamicPropertyId; }
    @property void overwrittenDynamicPropertyId(string v) { _overwrittenDynamicPropertyId = v; }

    @property string rootDynamicPropertyId() const { return _rootDynamicPropertyId; }
    @property void rootDynamicPropertyId(string v) { _rootDynamicPropertyId = v; }

    @property uint precision() const { return _precision; }
    @property void precision(uint v) { _precision = v; }

    @property string stateCode() const { return _stateCode; }
    @property void stateCode(string v) { _stateCode = v; }

    @property string stateCode_display() const { return _stateCode_display; }
    @property void stateCode_display(string v) { _stateCode_display = v; }

    @property string statusCode() const { return _statusCode; }
    @property void statusCode(string v) { _statusCode = v; }

    @property string statusCode_display() const { return _statusCode_display; }
    @property void statusCode_display(string v) { _statusCode_display = v; }

    @property string regardingObjectId() const { return _regardingObjectId; }
    @property void regardingObjectId(string v) { _regardingObjectId = v; }

    @property double defaultValueDouble() const { return _defaultValueDouble; }
    @property void defaultValueDouble(double v) { _defaultValueDouble = v; }

    @property double minValueDouble() const { return _minValueDouble; }
    @property void minValueDouble(double v) { _minValueDouble = v; }

    @property double maxValueDouble() const { return _maxValueDouble; }
    @property void maxValueDouble(double v) { _maxValueDouble = v; }

    @property long minValueLong() const { return _minValueLong; }
    @property void minValueLong(long v) { _minValueLong = v; }

    @property long maxValueLong() const { return _maxValueLong; }
    @property void maxValueLong(long v) { _maxValueLong = v; }

    @property bool isArray() const { return _isArray; }
    @property void isArray(bool v) { _isArray = v; }

    @property bool isDouble() const { return _isDouble; }
    @property void isDouble(bool v) { _isDouble = v; }

    @property bool isString() const { return _isString; }
    @property void isString(bool v) { _isString = v; }

    @property bool isJson() const { return _isJson; }
    @property void isJson(bool v) { _isJson = v; }

    @property bool isXML() const { return _isXML; }
    @property void isXML(bool v) { _isXML = v; }

    @property bool isAssociativeArray() const { return _isAssociativeArray; }
    @property void isAssociativeArray(bool v) { _isAssociativeArray = v; }

    @property bool isReadOnly() const { return _isReadOnly; }
    @property void isReadOnly(bool v) { _isReadOnly = v; }

    @property bool isHidden() const { return _isHidden; }
    @property void isHidden(bool v) { _isHidden = v; }

    @property bool isRequired() const { return _isRequired; }
    @property void isRequired(bool v) { _isRequired = v; }

    @property uint maxLengthString() const { return _maxLengthString; }
    @property void maxLengthString(uint v) { _maxLengthString = v; }

    @property string defaultValueOptionSet() const { return _defaultValueOptionSet; }
    @property void defaultValueOptionSet(string v) { _defaultValueOptionSet = v; }

    @property UUID attribute() const { return _attribute; }
    @property void attribute(UUID v) { _attribute = v; }
  mixin(AttributeThis!("Attribute"));

  // Initialization hook method.
  /* override  */void initialize(Json configSettings = Json(null)) { 
    /* super.initialize(configSettings); */ }

	// Data type of the attribute. 
  mixin(OProperty!("string[]", "dataFormats")); 
  bool hasDataFormat(string dataFormatName) {
    foreach(df; dataFormats) if (df == dataFormatName) { return true; }
    return false;
  }
  O addDataFormats(this O)(string[] newDataFormats) {
    foreach(df; newDataFormats) {
      if (!hasDataFormat(df)) _dataFormats ~= df;
    }
    return cast(O)this;
  }

  mixin(OProperty!("UUID", "id"));  
  mixin(OProperty!("string", "name"));  
  mixin(OProperty!("string", "display"));  
  mixin(OProperty!("string", "registerPath"));  
  mixin(OProperty!("bool", "isNullable"));
  mixin(OProperty!("string[string]", "descriptions"));
  mixin(OProperty!("string", "valueType")); // Select the data type of the property.")); // 
  mixin(OProperty!("string", "keyType")); // Select the data type of the property.")); // 
  mixin(OProperty!("string", "dataType_display")); // ")); // 
  mixin(OProperty!("long", "defaultValueLong")); // Shows the default value of the property for a whole number data type.")); // 
  mixin(OProperty!("string", "defaultValueString")); // Shows the default value of the property for a string data type.")); // 
  //mixin(OProperty!("string", "defaultValueDecimal")); // Shows the default value of the property for a decimal data type.")); // 
  mixin(OProperty!("string", "baseDynamicPropertyId")); // Shows the property in the product family that this property is being inherited from.")); // 
  mixin(OProperty!("string", "overwrittenDynamicPropertyId")); // Shows the related overwritten property.")); // 
  mixin(OProperty!("string", "rootDynamicPropertyId")); // Shows the root property that this property is derived from.")); // 
  /* mixin(OProperty!("string", "minValueDecimal")); // Shows the minimum allowed value of the property for a decimal data type.")); // 
  mixin(OProperty!("string", "maxValueDecimal")); // Shows the maximum allowed value of the property for a decimal data type.")); //  */
  mixin(OProperty!("uint", "precision")); // Shows the allowed precision of the property for a whole number data type.")); // 
  mixin(OProperty!("string", "stateCode")); // Shows the state of the property.")); // 
  mixin(OProperty!("string", "stateCode_display")); // ")); // 
  mixin(OProperty!("string", "statusCode")); // Shows whether the property is active or inactive.")); // 
  mixin(OProperty!("string", "statusCode_display")); // ")); // 
  mixin(OProperty!("string", "regardingObjectId")); // Choose the product that the property is associated with.")); // 
  mixin(OProperty!("double", "defaultValueDouble")); // Shows the default value of the property for a double data type.")); // 
  mixin(OProperty!("double", "minValueDouble")); // Shows the minimum allowed value of the property for a double data type.")); // 
  mixin(OProperty!("double", "maxValueDouble")); // Shows the maximum allowed value of the property for a double data type.")); // 
  mixin(OProperty!("long", "minValueLong")); // Shows the minimum allowed value of the property for a whole number data type.")); // 
  mixin(OProperty!("long", "maxValueLong")); // Shows the maximum allowed value of the property for a whole number data type.")); // 
  mixin(OProperty!("bool", "isArray")); 
  mixin(OProperty!("bool", "isDouble")); 
  mixin(OProperty!("bool", "isString")); 
  mixin(OProperty!("bool", "isJson")); 
  mixin(OProperty!("bool", "isXML")); 
  mixin(OProperty!("bool", "isAssociativeArray")); 
  mixin(OProperty!("bool", "isReadOnly")); // Defines whether the attribute is read-only or if it can be edited.")); // 
  mixin(OProperty!("bool", "isHidden")); // Defines whether the attribute is hidden or shown.")); // 
  mixin(OProperty!("bool", "isRequired")); // Defines whether the attribute is mandatory.")); // 
  mixin(OProperty!("uint", "maxLengthString")); // Shows the maximum allowed length of the property for a string data type.")); // 
  mixin(OProperty!("string", "defaultValueOptionSet")); // Shows the default value of the property.

  mixin(OProperty!("UUID", "attribute")); // Super attribute.

 /*  O attribute(this O)(UUID myId, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.id(myId).versionMajor(myMajor).versionMinor(myMinor);
    return cast(O)this; }

  O attribute(this O)(string myName, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.name(myName).versionMajor(myMajor).versionMinor(myMinor);
    return cast(O)this; }

  O attribute(this O)(DAttribute myAttclass) { 
    _attribute = myAttclass;     
    return cast(O)this; } */

  version(test_uim_models) { unittest {    /// TODO
    }
  }

  // Create a new attribute based on this attribute - using attribute name 
/*   auto createAttribute() {
    return createAttribute(_name); } */

  DValue createValue() {
    return NullValue; }

  /* // Create a new attribute based on this attribute an a giving name 
  auto createAttribute(string aName) {
    DAttribute result;
    switch(this.valueType) {
      case "bool": break; 
      case "byte": break; 
      case "ubyte": break; 
      case "short": break; 
      case "ushort": break; 
      case "int": break; 
      case "uint": break; 
      case "long": break; 
      case "ulong": break; 
      case "float": break; 
      case "double": break; 
      case "real": break; 
      case "ifloat": break; 
      case "idouble": break; 
      case "ireal": break; 
      case "cfloat": break; 
      case "cdouble": break; 
      case "creal": break; 
      case "char": break; 
      case "wchar": break; 
      case "dchar": break; 
      case "string": break; 
      case "uuid": break; 
      case "datetime": break; 
      default: break;
    }
    // result = new DAttribute(aName);
/ *     result.attribute(this);
    result.name(aName); * /
    return result;
  }
  version(test_uim_models) { unittest {    /// TODO
    }
  } */

  /* override  */void fromJson(Json aJson) {
    if (aJson.isEmpty) {return; }
    /* super.fromJson(aJson); */

    foreach (keyvalue; aJson.byKeyValue) {
      auto k = keyvalue.key;
      auto v = keyvalue.value;
      switch(k) {
        case "attribute": this.attribute(UUID(v.get!string)); break;
        case "isNullable": this.isNullable(v.get!bool); break;
        case "valueType": this.valueType(v.get!string); break;
        case "keyType": this.keyType(v.get!string); break;
        case "dataType_display": this.dataType_display(v.get!string); break;
        case "defaultValueLong": this.defaultValueLong(v.get!long); break;
        case "defaultValueString": this.defaultValueString(v.get!string); break;
        case "baseDynamicPropertyId": this.baseDynamicPropertyId(v.get!string); break;
        case "overwrittenDynamicPropertyId": this.overwrittenDynamicPropertyId(v.get!string); break;
        case "rootDynamicPropertyId": this.rootDynamicPropertyId(v.get!string); break;
        case "precision": this.precision(v.get!int); break;
        case "stateCode": this.stateCode(v.get!string); break;
        case "stateCode_display": this.stateCode_display(v.get!string); break;
        case "statusCode": this.statusCode(v.get!string); break;
        case "statusCode_display": this.statusCode_display(v.get!string); break;
        case "regardingObjectId": this.regardingObjectId(v.get!string); break;
        case "defaultValueDouble": this.defaultValueDouble(v.get!double); break;
        case "minValueDouble": this.minValueDouble(v.get!double); break;
        case "maxValueDouble": this.maxValueDouble(v.get!double); break;
        case "minValueLong": this.minValueLong(v.get!long); break;
        case "maxValueLong": this.maxValueLong(v.get!long); break;
        case "isReadOnly": this.isReadOnly(v.get!bool); break;
        case "isHidden": this.isHidden(v.get!bool); break;
        case "isRequired": this.isRequired(v.get!bool); break;
        case "isArray": this.isArray(v.get!bool); break;
        case "isAssociativeArray": this.isAssociativeArray(v.get!bool); break;
        case "maxLengthString": this.maxLengthString(v.get!int); break;
        case "defaultValueOptionSet": this.defaultValueOptionSet(v.get!string); break;
        default: break;
      }      
    }
  }

  // Convert data to json (using vibe's funcs)
  /* override  */Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = Json.emptyObject;

    // Fields
    result["isNullable"] = this.isNullable;
    result["valueType"] = this.valueType;
    result["keyType"] = this.keyType;
    result["dataType_display"] = this.dataType_display; 
    result["defaultValueLong"] = this.defaultValueLong; 
    result["defaultValueString"] = this.defaultValueString; 
    result["baseDynamicPropertyId"] = this.baseDynamicPropertyId; 
    result["overwrittenDynamicPropertyId"] = this.overwrittenDynamicPropertyId; 
    result["rootDynamicPropertyId"] = this.rootDynamicPropertyId; 
    result["precision"] = this.precision; 
    result["stateCode"] = this.stateCode; 
    result["stateCode_display"] = this.stateCode_display; 
    result["statusCode"] = this.statusCode; 
    result["statusCode_display"] = this.statusCode_display; 
    result["regardingObjectId"] = this.regardingObjectId; 
    result["defaultValueDouble"] = this.defaultValueDouble; 
    result["minValueDouble"] = this.minValueDouble;
    result["maxValueDouble"] = this.maxValueDouble;
    result["minValueLong"] = this.minValueLong;
    result["maxValueLong"] = this.maxValueLong;
    result["isReadOnly"] = this.isReadOnly;
    result["isHidden"] = this.isHidden;
    result["isRequired"] = this.isRequired;
    result["isArray"] = this.isArray;
    result["isAssociativeArray"] = this.isAssociativeArray;
    result["maxLengthString"] = this.maxLengthString;
    result["defaultValueOptionSet"] = this.defaultValueOptionSet;

    result["attribute"] = this.attribute.toString;

    return result;
  }
  version(test_uim_models) { unittest {    /// TODO
    }
  }

/*   alias opIndexAssign = DElement.opIndexAssign;
  alias opIndexAssign = UIMEntity.opIndexAssign; */
}
auto Attribute() { return new DAttribute; }
auto Attribute(UUID id) { return new DAttribute(id); }
auto Attribute(string name) { return new DAttribute(name); }
auto Attribute(UUID id, string name) { return new DAttribute(id, name); }
auto Attribute(Json json) { return new DAttribute(json); }
// auto Attribute(UIMEntityCollection aCollection, Json json) { return (new DAttribute(json)).collection(aCollection); }