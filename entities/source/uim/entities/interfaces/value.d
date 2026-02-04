/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

module uim.entities.interfaces.value;

import uim.entities;

mixin(ShowModule!());

@safe:

interface IValue {
  IAttribute attribute();
  
  bool isBoolean();
  bool isInteger();
  bool isDouble();
  bool isLong();
  bool isTime();
  bool isDate();
  bool isDatetime();
  bool isTimestamp();
  bool isString();

  bool isScalar();
  bool isArray();
  bool isObject();
  bool isEntity();
  bool isUUID();

  bool isNullable();
  bool isNull();
  bool isReadOnly();

/*
  bool hasKeys(string[] keys);
  bool hasKey(string key);
  bool hasValueOfType(T)() if (is(T == class));
  bool hasValueOfType(T)() if (is(T == interface));
  bool hasValueOfType(T)() if (is(T == struct));
  bool hasValueOfType(T)() if (is(T == enum));
  bool hasValueOfType(T)() if (is(T == union));
  bool hasValueOfType(T)() if (is(T == U), U : T);
  bool hasValueOfType(T)() if (is(T == U[]), U : T);
  bool hasValueOfType(T)() if (is(T == U[string]), U : T);
  bool hasValueOfType(T)() if (is(T == U), U : T);
  */ 

  Json toJson();
  string toString();
}