/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.document;

import std.datetime : Clock, SysTime;

import uim.cdm;

mixin(ShowModule!());

@safe:

class UIMCdmField : UIMObject, ICdmField {
  private string _name;
  private CdmDataType _dataType;
  private string _value;

  this(string name = "", CdmDataType dataType = CdmDataType.string, string value = "") {
    _name = name;
    _dataType = dataType;
    _value = value;
  }

  string name() {
    return _name;
  }

  ICdmField name(string value) {
    _name = value;
    return this;
  }

  CdmDataType dataType() {
    return _dataType;
  }

  ICdmField dataType(CdmDataType value) {
    _dataType = value;
    return this;
  }

  string value() {
    return _value;
  }

  ICdmField value(string value) {
    _value = value;
    return this;
  }
}

class UIMCdmEntity : UIMObject, ICdmEntity {
  private string _name;
  private string _description;
  private ICdmField[] _fields;
  private string[string] _metadata;

  this(string name = "", string description = "") {
    _name = name;
    _description = description;
  }

  string name() {
    return _name;
  }

  ICdmEntity name(string value) {
    _name = value;
    return this;
  }

  string description() {
    return _description;
  }

  ICdmEntity description(string value) {
    _description = value;
    return this;
  }

  ICdmField[] fields() {
    return _fields.dup;
  }

  ICdmEntity fields(ICdmField[] value) {
    _fields = value.dup;
    return this;
  }

  ICdmEntity addField(ICdmField field) {
    if (field !is null) {
      _fields ~= field;
    }
    return this;
  }

  string[string] metadata() {
    return _metadata.dup;
  }

  ICdmEntity metadata(string[string] value) {
    _metadata = value.dup;
    return this;
  }

  ICdmEntity setMetadata(string key, string value) {
    if (key.length) {
      _metadata[key] = value;
    }
    return this;
  }
}

class UIMCdmDocument : UIMObject, ICdmDocument {
  private string _id;
  private string _name;
  private string _namespaceUri;
  private string _version_;
  private SysTime _created;
  private ICdmEntity[] _entities;
  private string[string] _metadata;

  this() {
    _created = Clock.currTime();
  }

  this(string id, string name, string namespaceUri, string version_ = "1.0") {
    this();
    _id = id;
    _name = name;
    _namespaceUri = namespaceUri;
    _version_ = version_;
  }

  string id() {
    return _id;
  }

  ICdmDocument id(string value) {
    _id = value;
    return this;
  }

  string name() {
    return _name;
  }

  ICdmDocument name(string value) {
    _name = value;
    return this;
  }

  string namespaceUri() {
    return _namespaceUri;
  }

  ICdmDocument namespaceUri(string value) {
    _namespaceUri = value;
    return this;
  }

  string version_() {
    return _version_;
  }

  ICdmDocument version_(string value) {
    _version_ = value;
    return this;
  }

  SysTime created() {
    return _created;
  }

  ICdmDocument created(SysTime value) {
    _created = value;
    return this;
  }

  ICdmEntity[] entities() {
    return _entities.dup;
  }

  ICdmDocument entities(ICdmEntity[] value) {
    _entities = value.dup;
    return this;
  }

  ICdmDocument addEntity(ICdmEntity entity) {
    if (entity !is null) {
      _entities ~= entity;
    }
    return this;
  }

  string[string] metadata() {
    return _metadata.dup;
  }

  ICdmDocument metadata(string[string] value) {
    _metadata = value.dup;
    return this;
  }

  ICdmDocument setMetadata(string key, string value) {
    if (key.length) {
      _metadata[key] = value;
    }
    return this;
  }
}

ICdmField CdmField(string name, CdmDataType dataType = CdmDataType.string, string value = "") {
  return new UIMCdmField(name, dataType, value);
}

ICdmEntity CdmEntity(string name = "", string description = "") {
  return new UIMCdmEntity(name, description);
}

ICdmDocument CdmDocument(string id, string name, string namespaceUri, string version_ = "1.0") {
  return new UIMCdmDocument(id, name, namespaceUri, version_);
}

unittest {
  auto document = CdmDocument("CDM-1", "Mission Data Model", "urn:uim:cdm:mission");
  document.setMetadata("owner", "HQ-NORTH");

  auto entity = CdmEntity("MissionReport", "Mission report container")
    .addField(CdmField("reportId", CdmDataType.identifier, "MR-001"))
    .addField(CdmField("status", CdmDataType.string, "open"));

  document.addEntity(entity);

  assert(document.name() == "Mission Data Model");
  assert(document.metadata()["owner"] == "HQ-NORTH");
  assert(document.entities().length == 1);
  assert(document.entities()[0].name() == "MissionReport");
}
