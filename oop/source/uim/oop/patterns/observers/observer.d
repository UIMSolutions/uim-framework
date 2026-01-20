/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.observers.observer;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base observer class with delegate support.
 */
class Observer(T) : IObserver!T {
  private void delegate(T, Object) @safe _callback;

  /**
   * Create an observer with a callback function.
   * Params:
   *   callback = The function to call when the subject changes
   */
  this(void delegate(T, Object) @safe callback) {
    _callback = callback;
  }

  /**
   * Called when the observed subject changes.
   * Params:
   *   subject = The subject that changed
   *   data = Optional data about the change
   */
  void update(T subject, Object data = null) {
    if (_callback) {
      _callback(subject, data);
    }
  }
}

/**
 * Event data wrapper class.
 */
class EventData : IEventData {
  private string _eventType;
  private Object _payload;

  /**
   * Create event data.
   * Params:
   *   eventType = The type of event
   *   payload = Optional payload data
   */
  this(string eventType, Object payload = null) {
    _eventType = eventType;
    _payload = payload;
  }

  string eventType() {
    return _eventType;
  }

  Object payload() {
    return _payload;
  }
}

/**
 * Multi-event observer base class.
 */
class EventObserver : IEventObserver {
  private void delegate(string, IEventData) @safe[string] _handlers;

  /**
   * Register a handler for a specific event type.
   * Params:
   *   eventType = The event type to handle
   *   handler = The handler function
   */
  void registerHandler(string eventType, void delegate(string, IEventData) @safe handler) {
    _handlers[eventType] = handler;
  }

  /**
   * Handle an event with typed data.
   * Params:
   *   eventType = The type of event
   *   data = The event data
   */
  void onEvent(string eventType, IEventData data) {
    if (auto handler = eventType in _handlers) {
      (*handler)(eventType, data);
    }
  }

  /**
   * Check if the observer handles a specific event type.
   * Params:
   *   eventType = The event type to check
   * Returns: true if the observer handles this event type
   */
  bool handlesEvent(string eventType) {
    return (eventType in _handlers) !is null;
  }
}

/**
 * Helper function to create an observer.
 */
Observer!T createObserver(T)(void delegate(T, Object) @safe callback) {
  return new Observer!T(callback);
}

// Unit tests
unittest {
  class TestSubject {}

  int callCount = 0;
  TestSubject lastSubject;

  auto observer = createObserver!TestSubject((subject, data) {
    callCount++;
    lastSubject = subject;
  });

  auto subject = new TestSubject();
  observer.update(subject);

  assert(callCount == 1);
  assert(lastSubject is subject);
}

unittest {
  auto eventData = new EventData("test.event", null);
  assert(eventData.eventType() == "test.event");
}

unittest {
  auto observer = new EventObserver();
  
  int callCount = 0;
  observer.registerHandler("test.event", (type, data) {
    callCount++;
  });

  assert(observer.handlesEvent("test.event"));
  assert(!observer.handlesEvent("other.event"));

  auto data = new EventData("test.event");
  observer.onEvent("test.event", data);
  assert(callCount == 1);
}
