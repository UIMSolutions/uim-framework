/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.enumerations.persistencetype;

import uim.service;

mixin(ShowModule!());

@safe:

enum PersistenceType {
  memory,
  sql,
  nosql,
  file,
}

PersistenceType toPersistenceType(string value) {
  mixin(EnumSwitch("PersistenceType", "memory"));
}
PersistenceType[] toPersistenceType(string[] values) {
  return values.map!(toPersistenceType).array;
}
string toString(PersistenceType type) {
  return type.to!string;
}
string[] toString(PersistenceType[] types) {
  return types.map!toString.array;
}
///
unittest {
  assert(PersistenceType.sql.to!string == "sql");
  assert(PersistenceType.nosql.to!string == "nosql");
  assert(PersistenceType.memory.to!string == "memory");
  assert(PersistenceType.file.to!string == "file");

  assert("sql".to!PersistenceType == PersistenceType.sql);
  assert("nosql".to!PersistenceType == PersistenceType.nosql);
  assert("memory".to!PersistenceType == PersistenceType.memory);
  assert("file".to!PersistenceType == PersistenceType.file);

  assert("sql".toPersistenceType == PersistenceType.sql);
  assert("nosql".toPersistenceType == PersistenceType.nosql);
  assert("memory".toPersistenceType == PersistenceType.memory);
  assert("file".toPersistenceType == PersistenceType.file);
  assert("noexists".toPersistenceType == PersistenceType.memory); // Default case
  assert("".toPersistenceType == PersistenceType.memory); // Default case

  assert(toString(PersistenceType.sql) == "sql");
  assert(toString(PersistenceType.nosql) == "nosql");
  assert(toString(PersistenceType.memory) == "memory");
  assert(toString(PersistenceType.file) == "file");

  assert(["sql", "nosql", "memory", "file"].toPersistenceType == [PersistenceType.sql, PersistenceType.nosql, PersistenceType.memory, PersistenceType.file]);
  assert([PersistenceType.sql, PersistenceType.nosql, PersistenceType.memory, PersistenceType.file].toString == ["sql", "nosql", "memory", "file"]);
}
