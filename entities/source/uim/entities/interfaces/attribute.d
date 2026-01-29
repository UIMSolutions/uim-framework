/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

module uim.entities.interfaces.attribute;

import uim.entities;

mixin(ShowModule!());

@safe:

interface IAttribute {
  // Data formats of the attribute. 
  string[] dataFormats();

  // Check for data format
  bool hasDataFormat(string dataFormatName);

  UUID id() const;
  IAttribute id(UUID v);

  string name() const;
  IAttribute name(string v);

  string display() const;
  IAttribute display(string v);

  string registerPath() const;
  IAttribute registerPath(string v);

  bool isNullable() const;
  IAttribute isNullable(bool v);

  /*
     string[string] descriptions() const;
     IAttribute descriptions(string[string] v);
*/
  string valueType() const;
  IAttribute valueType(string v);

  string keyType() const;
  IAttribute keyType(string v);

  string dataType_display() const;
  IAttribute dataType_display(string v);

  long defaultValueLong() const;
  IAttribute defaultValueLong(long v);

  string defaultValueString() const;
  IAttribute defaultValueString(string v);

  string baseDynamicPropertyId() const;
  IAttribute baseDynamicPropertyId(string v);

  string overwrittenDynamicPropertyId() const;
  IAttribute overwrittenDynamicPropertyId(string v);

  string rootDynamicPropertyId() const;
  IAttribute rootDynamicPropertyId(string v);

  uint precision() const;
  IAttribute precision(uint v);

  string stateCode() const;
  IAttribute stateCode(string v);

  string stateCode_display() const;
  IAttribute stateCode_display(string v);

  string statusCode() const;
  IAttribute statusCode(string v);

  string statusCode_display() const;
  IAttribute statusCode_display(string v);

  string regardingObjectId() const;
  IAttribute regardingObjectId(string v);

  double defaultValueDouble() const;
  IAttribute defaultValueDouble(double v);

  double minValueDouble() const;
  IAttribute minValueDouble(double v);

  double maxValueDouble() const;
  IAttribute maxValueDouble(double v);

  long minValueLong() const;
  IAttribute minValueLong(long v);

  long maxValueLong() const;
  IAttribute maxValueLong(long v);

  bool isArray() const;
  IAttribute isArray(bool v);

  bool isDouble() const;
  IAttribute isDouble(bool v);

  bool isString() const;
  IAttribute isString(bool v);

  bool isJson() const;
  IAttribute isJson(bool v);

  bool isXML() const;
  IAttribute isXML(bool v);

  bool isAssociativeArray() const;
  IAttribute isAssociativeArray(bool v);

  bool isReadOnly() const;
  IAttribute isReadOnly(bool v);

  bool isHidden() const;
  IAttribute isHidden(bool v);

  bool isRequired() const;
  IAttribute isRequired(bool v);

  uint maxLengthString() const;
  IAttribute maxLengthString(uint v);

  string defaultValueOptionSet() const;
  IAttribute defaultValueOptionSet(string v);

  UUID attribute() const;
  IAttribute attribute(UUID v);
}
