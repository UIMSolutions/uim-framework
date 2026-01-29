/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.attribute;

import uim.entities;

mixin(ShowModule!());

@safe:
class UIMAttribute : UIMObject, IAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // --- Explicit property getters and setters for marked fields ---    
  protected UUID _id;
  @property UUID id() const {
    return _id;
  }

  @property IAttribute id(UUID v) {
    _id = v;
    return this;
  }

  protected string _name;
  @property string name() const {
    return _name;
  }

  @property IAttribute name(string v) {
    _name = v;
    return this;
  }

  protected string _display;
  @property string display() const {
    return _display;
  }

  @property IAttribute display(string v) {
    _display = v;
    return this;
  }

  protected string _description;
  @property string description() const {
    return _description;
  }

  @property IAttribute description(string v) {
    _description = v;
    return this;
  }

  protected string _registerPath;
  @property string registerPath() const {
    return _registerPath;
  }

  @property IAttribute registerPath(string v) {
    _registerPath = v;
    return this;
  }

  protected bool _isNullable;
  @property bool isNullable() const {
    return _isNullable;
  }

  @property IAttribute isNullable(bool v) {
    _isNullable = v;
    return this;
  }

  /*
    protected string[string] _descriptions;
    @property string[string] descriptions() const { return _descriptions; }
    @property IAttribute descriptions(string[string] v) { _descriptions = v; return this; }
    */

  protected string _valueType;
  @property string valueType() const {
    return _valueType;
  }

  @property IAttribute valueType(string v) {
    _valueType = v;
    return this;
  }

  protected string _keyType;
  @property string keyType() const {
    return _keyType;
  }

  @property IAttribute keyType(string v) {
    _keyType = v;
    return this;
  }

  protected string _dataType_display;
  @property string dataType_display() const {
    return _dataType_display;
  }

  @property IAttribute dataType_display(string v) {
    _dataType_display = v;
    return this;
  }

  protected long _defaultValueLong;
  @property long defaultValueLong() const {
    return _defaultValueLong;
  }

  @property IAttribute defaultValueLong(long v) {
    _defaultValueLong = v;
    return this;
  }

  protected string _defaultValueString;
  @property string defaultValueString() const {
    return _defaultValueString;
  }

  @property IAttribute defaultValueString(string v) {
    _defaultValueString = v;
    return this;
  }

  protected string _baseDynamicPropertyId;
  @property string baseDynamicPropertyId() const {
    return _baseDynamicPropertyId;
  }

  @property IAttribute baseDynamicPropertyId(string v) {
    _baseDynamicPropertyId = v;
    return this;
  }

  protected string _overwrittenDynamicPropertyId;
  @property string overwrittenDynamicPropertyId() const {
    return _overwrittenDynamicPropertyId;
  }

  @property IAttribute overwrittenDynamicPropertyId(string v) {
    _overwrittenDynamicPropertyId = v;
    return this;
  }

  protected string _rootDynamicPropertyId;
  @property string rootDynamicPropertyId() const {
    return _rootDynamicPropertyId;
  }

  @property IAttribute rootDynamicPropertyId(string v) {
    _rootDynamicPropertyId = v;
    return this;
  }

  protected uint _precision;
  @property uint precision() const {
    return _precision;
  }

  @property IAttribute precision(uint v) {
    _precision = v;
    return this;
  }

  protected string _stateCode;
  @property string stateCode() const {
    return _stateCode;
  }

  @property IAttribute stateCode(string v) {
    _stateCode = v;
    return this;
  }

  protected string _stateCode_display;
  @property string stateCode_display() const {
    return _stateCode_display;
  }

  @property IAttribute stateCode_display(string v) {
    _stateCode_display = v;
    return this;
  }

  protected string _statusCode;
  @property string statusCode() const {
    return _statusCode;
  }

  @property IAttribute statusCode(string v) {
    _statusCode = v;
    return this;
  }

  protected string _statusCode_display;
  @property string statusCode_display() const {
    return _statusCode_display;
  }

  @property IAttribute statusCode_display(string v) {
    _statusCode_display = v;
    return this;
  }

  protected string _regardingObjectId;
  @property string regardingObjectId() const {
    return _regardingObjectId;
  }

  @property IAttribute regardingObjectId(string v) {
    _regardingObjectId = v;
    return this;
  }

  protected double _defaultValueDouble;
  @property double defaultValueDouble() const {
    return _defaultValueDouble;
  }

  @property IAttribute defaultValueDouble(double v) {
    _defaultValueDouble = v;
    return this;
  }

  protected double _minValueDouble;
  @property double minValueDouble() const {
    return _minValueDouble;
  }

  @property IAttribute minValueDouble(double v) {
    _minValueDouble = v;
    return this;
  }

  protected double _maxValueDouble;
  @property double maxValueDouble() const {
    return _maxValueDouble;
  }

  @property IAttribute maxValueDouble(double v) {
    _maxValueDouble = v;
    return this;
  }

  protected long _minValueLong;
  @property long minValueLong() const {
    return _minValueLong;
  }

  @property IAttribute minValueLong(long v) {
    _minValueLong = v;
    return this;
  }

  protected long _maxValueLong;
  @property long maxValueLong() const {
    return _maxValueLong;
  }

  @property IAttribute maxValueLong(long v) {
    _maxValueLong = v;
    return this;
  }

  protected bool _isArray;
  @property bool isArray() const {
    return _isArray;
  }

  @property IAttribute isArray(bool v) {
    _isArray = v;
    return this;
  }

  protected bool _isBoolean;
  @property bool isBoolean() const {
    return _isBoolean;
  }

  @property IAttribute isBoolean(bool v) {
    _isBoolean = v;
    return this;
  }

  protected bool _isDouble;
  @property bool isDouble() const {
    return _isDouble;
  }

  @property IAttribute isDouble(bool v) {
    _isDouble = v;
    return this;
  }

  protected bool _isInteger;
  @property bool isInteger() const {
    return _isInteger;
  }

  @property IAttribute isInteger(bool v) {
    _isInteger = v;
    return this;
  }

  protected bool _isString;
  @property bool isString() const {
    return _isString;
  }

  @property IAttribute isString(bool v) {
    _isString = v;
    return this;
  }

  protected bool _isDateTime;
  @property bool isDateTime() const {
    return _isDateTime;
  }

  @property IAttribute isDateTime(bool v) {
    _isDateTime = v;
    return this;
  }

  protected bool _isJson;
  @property bool isJson() const {
    return _isJson;
  }

  @property IAttribute isJson(bool v) {
    _isJson = v;
    return this;
  }

  protected bool _isXML;
  @property bool isXML() const {
    return _isXML;
  }

  @property IAttribute isXML(bool v) {
    _isXML = v;
    return this;
  }

  protected bool _isAssociativeArray;
  @property bool isAssociativeArray() const {
    return _isAssociativeArray;
  }

  @property IAttribute isAssociativeArray(bool v) {
    _isAssociativeArray = v;
    return this;
  }

  protected bool _isReadOnly;
  @property bool isReadOnly() const {
    return _isReadOnly;
  }

  @property IAttribute isReadOnly(bool v) {
    _isReadOnly = v;
    return this;
  }

  protected bool _isHidden;
  @property bool isHidden() const {
    return _isHidden;
  }

  @property IAttribute isHidden(bool v) {
    _isHidden = v;
    return this;
  }

  protected bool _isRequired;
  @property bool isRequired() const {
    return _isRequired;
  }

  @property IAttribute isRequired(bool v) {
    _isRequired = v;
    return this;
  }

  protected uint _maxLengthString;
  @property uint maxLengthString() const {
    return _maxLengthString;
  }

  @property IAttribute maxLengthString(uint v) {
    _maxLengthString = v;
    return this;
  }

  protected string _defaultValueOptionSet;
  @property string defaultValueOptionSet() const {
    return _defaultValueOptionSet;
  }

  @property IAttribute defaultValueOptionSet(string v) {
    _defaultValueOptionSet = v;
    return this;
  }

  protected UUID _attribute;
  @property UUID attribute() const {
    return _attribute;
  }

  @property IAttribute attribute(UUID v) {
    _attribute = v;
    return this;
  }

  // Initialization hook method.
  /* override  */
  void initialize(Json configSettings = Json(null)) {
    /* super.initialize(configSettings); */
  }

  // Data type of the attribute. 
  mixin(OProperty!("string[]", "dataFormats"));
  bool hasDataFormat(string dataFormatName) {
    foreach (df; dataFormats)
      if (df == dataFormatName) {
        return true;
      }
    return false;
  }

  O addDataFormats(this O)(string[] newDataFormats) {
    foreach (df; newDataFormats) {
      if (!hasDataFormat(df))
        _dataFormats ~= df;
    }
    return cast(O)this;
  }

  /*  O attribute(this O)(UUID myId, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.id(myId).versionMajor(myMajor).versionMinor(myMinor);
    return cast(O)this; }

  O attribute(this O)(string myName, size_t myMajor = 0, size_t myMinor = 0) { 
    _attribute = Attribute.name(myName).versionMajor(myMajor).versionMinor(myMinor);
    return cast(O)this; }

  O attribute(this O)(UIMAttribute myAttclass) { 
    _attribute = myAttclass;     
    return cast(O)this; } */

  // Create a new attribute based on this attribute - using attribute name 
  /*   auto createAttribute() {
    return createAttribute(_name); } */

  IValue createValue() {
    return null;
  }

  /* // Create a new attribute based on this attribute an a giving name 
  auto createAttribute(string aName) {
    UIMAttribute result;
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
  } */

  /* override  */
  void fromJson(Json json) {
    if (!json.isObject) {
      return;
    }
    /* super.fromJson(aJson); */

    foreach (key, value; json.toMap) {
      auto k = key;
      auto v = value;
      switch (k) {
      case "attribute":
        this.attribute(UUID(v.get!string));
        break;
      case "isNullable":
        this.isNullable(v.get!bool);
        break;
      case "valueType":
        this.valueType(v.get!string);
        break;
      case "keyType":
        this.keyType(v.get!string);
        break;
      case "dataType_display":
        this.dataType_display(v.get!string);
        break;
      case "defaultValueLong":
        this.defaultValueLong(v.get!long);
        break;
      case "defaultValueString":
        this.defaultValueString(v.get!string);
        break;
      case "baseDynamicPropertyId":
        this.baseDynamicPropertyId(v.get!string);
        break;
      case "overwrittenDynamicPropertyId":
        this.overwrittenDynamicPropertyId(v.get!string);
        break;
      case "rootDynamicPropertyId":
        this.rootDynamicPropertyId(v.get!string);
        break;
      case "precision":
        this.precision(v.get!int);
        break;
      case "stateCode":
        this.stateCode(v.get!string);
        break;
      case "stateCode_display":
        this.stateCode_display(v.get!string);
        break;
      case "statusCode":
        this.statusCode(v.get!string);
        break;
      case "statusCode_display":
        this.statusCode_display(v.get!string);
        break;
      case "regardingObjectId":
        this.regardingObjectId(v.get!string);
        break;
      case "defaultValueDouble":
        this.defaultValueDouble(v.get!double);
        break;
      case "minValueDouble":
        this.minValueDouble(v.get!double);
        break;
      case "maxValueDouble":
        this.maxValueDouble(v.get!double);
        break;
      case "minValueLong":
        this.minValueLong(v.get!long);
        break;
      case "maxValueLong":
        this.maxValueLong(v.get!long);
        break;
      case "isReadOnly":
        this.isReadOnly(v.get!bool);
        break;
      case "isHidden":
        this.isHidden(v.get!bool);
        break;
      case "isRequired":
        this.isRequired(v.get!bool);
        break;
      case "isArray":
        this.isArray(v.get!bool);
        break;
      case "isAssociativeArray":
        this.isAssociativeArray(v.get!bool);
        break;
      case "maxLengthString":
        this.maxLengthString(v.get!int);
        break;
      case "defaultValueOptionSet":
        this.defaultValueOptionSet(v.get!string);
        break;
      default:
        break;
      }
    }
  }

  // Convert data to json (using vibe's funcs)
  override Json toJson(string[] showFields, string[] hideFields) {
    return toJson(showFields).removeKeys(hideFields);
  }

  /* override  */
  Json toJson(string[] showFields) {
    return toJson.filterKeys(showFields);
  }

  Json toJson() {
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

  /*   alias opIndexAssign = UIMElement.opIndexAssign;
  alias opIndexAssign = UIMEntity.opIndexAssign; */
}
