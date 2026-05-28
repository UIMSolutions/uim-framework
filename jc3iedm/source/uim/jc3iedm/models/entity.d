/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jc3iedm.models.entity;

import uim.jc3iedm;

mixin(ShowModule!());

@safe:

class UIMJC3IEDMEntity : UIMObject, IJC3IEDMEntity {
  private string _id;
  private string _name;
  private JC3IEDMEntityType _entityType = JC3IEDMEntityType.unit;
  private JC3IEDMAffiliation _affiliation = JC3IEDMAffiliation.unknown;
  private JC3IEDMPosition _position = JC3IEDMPosition(0, 0, 0);
  private string[string] _attributes;

  this(string id = "", string name = "", JC3IEDMEntityType entityType = JC3IEDMEntityType.unit) {
    _id = jc3iedmNormalizeId(id);
    _name = name;
    _entityType = entityType;
  }

  string id() {
    return _id;
  }

  IJC3IEDMEntity id(string value) {
    _id = jc3iedmNormalizeId(value);
    return this;
  }

  string name() {
    return _name;
  }

  IJC3IEDMEntity name(string value) {
    _name = value;
    return this;
  }

  JC3IEDMEntityType entityType() {
    return _entityType;
  }

  IJC3IEDMEntity entityType(JC3IEDMEntityType value) {
    _entityType = value;
    return this;
  }

  JC3IEDMAffiliation affiliation() {
    return _affiliation;
  }

  IJC3IEDMEntity affiliation(JC3IEDMAffiliation value) {
    _affiliation = value;
    return this;
  }

  JC3IEDMPosition position() {
    return _position;
  }

  IJC3IEDMEntity position(JC3IEDMPosition value) {
    _position = value;
    return this;
  }

  string[string] attributes() {
    return _attributes.dup;
  }

  IJC3IEDMEntity attributes(string[string] value) {
    _attributes = value.dup;
    return this;
  }

  IJC3IEDMEntity setAttribute(string key, string value) {
    if (key.length) {
      _attributes[key] = value;
    }

    return this;
  }

  bool isValid() {
    return _id.length > 0 && _name.length > 0;
  }
}

IJC3IEDMEntity JC3IEDMEntity(string id = "", string name = "", JC3IEDMEntityType entityType = JC3IEDMEntityType.unit) {
  return new UIMJC3IEDMEntity(id, name, entityType);
}

unittest {
  auto e = JC3IEDMEntity("unit 1", "Alpha", JC3IEDMEntityType.unit)
    .affiliation(JC3IEDMAffiliation.friendly)
    .setAttribute("nation", "DEU");

  assert(e.id() == "unit_1");
  assert(e.isValid());
  assert(e.attributes()["nation"] == "DEU");
}
