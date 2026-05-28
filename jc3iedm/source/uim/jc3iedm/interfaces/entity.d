/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jc3iedm.interfaces.entity;

@safe:

enum JC3IEDMEntityType : ubyte {
  unit = 0,
  person = 1,
  equipment = 2,
  facility = 3,
  action = 4,
  event_ = 5,
  location = 6,
  organization = 7
}

enum JC3IEDMAffiliation : ubyte {
  unknown = 0,
  friendly = 1,
  hostile = 2,
  neutral = 3
}

struct JC3IEDMPosition {
  double latitude;
  double longitude;
  double altitude;
}

interface IJC3IEDMEntity {
  string id();
  IJC3IEDMEntity id(string value);

  string name();
  IJC3IEDMEntity name(string value);

  JC3IEDMEntityType entityType();
  IJC3IEDMEntity entityType(JC3IEDMEntityType value);

  JC3IEDMAffiliation affiliation();
  IJC3IEDMEntity affiliation(JC3IEDMAffiliation value);

  JC3IEDMPosition position();
  IJC3IEDMEntity position(JC3IEDMPosition value);

  string[string] attributes();
  IJC3IEDMEntity attributes(string[string] value);
  IJC3IEDMEntity setAttribute(string key, string value);

  bool isValid();
}

alias JC3IEDMEntityHandler = void delegate(IJC3IEDMEntity entity) @safe;

interface IJC3IEDMService {
  bool connect(string endpointUrl);
  bool disconnect();
  bool connected() const;
  string endpoint() const;

  bool upsertEntity(IJC3IEDMEntity entity);
  IJC3IEDMEntity entityById(string entityId);
  IJC3IEDMEntity[] entities();

  IJC3IEDMEntity[] queryByType(JC3IEDMEntityType value);
  IJC3IEDMEntity[] queryByAffiliation(JC3IEDMAffiliation value);
  IJC3IEDMEntity[] queryByAttribute(string key, string value);

  bool streamEntities(JC3IEDMEntityHandler handler);
}
