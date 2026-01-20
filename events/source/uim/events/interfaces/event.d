/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.interfaces.event;

import uim.core;
import uim.oop;

import std.datetime : SysTime, Clock;

mixin(ShowModule!());

@safe:

/**
 * Event interface that defines the contract for all events
 */
interface IEvent {
  // Properties
  string name();
  IEvent name(string value);

  SysTime timestamp();
  IEvent timestamp(SysTime value);

  bool stopped();
  IEvent stopped(bool value);

  Json[string] data();
  IEvent data(Json[string] value);

  // Methods
  void stopPropagation();
  bool isPropagationStopped();
  IEvent setData(string key, Json value);
  Json getData(string key, Json defaultValue = Json(null));
  bool hasKey(string key);
}
