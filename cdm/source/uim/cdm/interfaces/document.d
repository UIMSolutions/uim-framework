/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.interfaces.document;

import std.datetime : SysTime;

import uim.cdm.types;

@safe:

interface ICdmField {
  string name();
  ICdmField name(string value);

  CdmDataType dataType();
  ICdmField dataType(CdmDataType value);

  string value();
  ICdmField value(string value);
}

interface ICdmEntity {
  string name();
  ICdmEntity name(string value);

  string description();
  ICdmEntity description(string value);

  ICdmField[] fields();
  ICdmEntity fields(ICdmField[] value);
  ICdmEntity addField(ICdmField field);

  string[string] metadata();
  ICdmEntity metadata(string[string] value);
  ICdmEntity setMetadata(string key, string value);
}

interface ICdmDocument {
  string id();
  ICdmDocument id(string value);

  string name();
  ICdmDocument name(string value);

  string namespaceUri();
  ICdmDocument namespaceUri(string value);

  string version_();
  ICdmDocument version_(string value);

  SysTime created();
  ICdmDocument created(SysTime value);

  ICdmEntity[] entities();
  ICdmDocument entities(ICdmEntity[] value);
  ICdmDocument addEntity(ICdmEntity entity);

  string[string] metadata();
  ICdmDocument metadata(string[string] value);
  ICdmDocument setMetadata(string key, string value);
}
