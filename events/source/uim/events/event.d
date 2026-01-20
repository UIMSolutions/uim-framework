/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.event;

import uim.core;
import uim.oop;
import uim.events.interfaces;

import std.datetime : SysTime, Clock;

@safe:

/**
 * Base event class that all events should inherit from.
 * Provides common event functionality including name, timestamp, and propagation control.
 */
class DEvent : UIMObject, IEvent {
  this() {
    super();
    this.timestamp(Clock.currTime());
  }

  this(string eventName) {
    this();
    this.name(eventName);
  }

  // #region name
  // Getter and setter for name
  private string _name;
  string name() {
    return _name;
  }

  IEvent name(string value) {
    _name = value;
    return this;
  }
  // #endregion name

  // #region timestamp
  // Getter and setter for timestamp
  private SysTime _timestamp;
  SysTime timestamp() {
    return _timestamp;
  }

  IEvent timestamp(SysTime value) {
    _timestamp = value;
    return this;
  }
  // #endregion timestamp

  // #region stopped
  private bool _stopped;
  // Getter for stopped
  bool stopped() {
    return _stopped;
  }

  // Setter for stopped
  IEvent stopped(bool value) {
    _stopped = value;
    return this;
  }
  // #endregion stopped

  // #region data
  private Json[string] _data;
  // Getter and setter for data
  Json[string] data() {
    return _data;
  }

  IEvent data(Json[string] value) {
    _data = value;
    return this;
  }
  // #endregion data

  protected bool _propagationStopped = false;

  /**
     * Stop event propagation to subsequent listeners
     */
  void stopPropagation() {
    _propagationStopped = true;
    this.stopped(true);
  }

  /**
     * Check if propagation has been stopped
     */
  bool isPropagationStopped() {
    return _propagationStopped;
  }

  /**
     * Set event data
     */
  IEvent setData(string key, Json value) {
    auto currentData = this.data();
    currentData[key] = value;
    this.data(currentData);
    return this;
  }

  /**
     * Get event data
     */
  Json getData(string key, Json defaultValue = Json(null)) {
    auto currentData = this.data();
    return (key in currentData) ? currentData[key] : defaultValue;
  }

  /**
     * Check if event has data key
     */
  bool hasKey(string key) {
    auto currentData = this.data();
    return (key in currentData) !is null;
  }
}

// Factory function
auto Event(string name = "") {
  return new DEvent(name);
}

unittest {
  mixin(ShowTest!"Testing DEvent class...");

  auto event = Event("test.event");
  assert(event.name() == "test.event");
  assert(!event.isPropagationStopped());

  event.stopPropagation();
  assert(event.isPropagationStopped());

  event.setData("key1", Json("value1"));
  assert(event.hasKey("key1"));
  assert(event.getData("key1") == Json("value1"));
  assert(event.getData("nonexistent", Json("default")) == Json("default"));

  writeln("DEvent tests passed!");
}
