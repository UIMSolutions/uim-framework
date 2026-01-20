/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.observers.subject;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base subject implementation for the Observer pattern.
 */
class Subject(T) : ISubject!T {
  private IObserver!T[] _observers;

  /**
   * Attach an observer to the subject.
   * Params:
   *   observer = The observer to attach
   */
  void attach(IObserver!T observer) {
    if (observer is null) return;
    
    // Check if observer is already attached
    foreach (obs; _observers) {
      if (obs is observer) return;
    }
    
    _observers ~= observer;
  }

  /**
   * Detach an observer from the subject.
   * Params:
   *   observer = The observer to detach
   */
  void detach(IObserver!T observer) {
    if (observer is null) return;

    import std.algorithm : remove;
    import std.array : array;
    
    _observers = _observers.remove!(obs => obs is observer).array;
  }

  /**
   * Notify all attached observers of a state change.
   * Params:
   *   data = Optional data about the change
   */
  void notify(Object data = null) {
    T self = cast(T) this;
    foreach (observer; _observers) {
      observer.update(self, data);
    }
  }

  /**
   * Get the number of attached observers.
   * Returns: The count of observers
   */
  size_t observerCount() {
    return _observers.length;
  }

  /**
   * Clear all attached observers.
   */
  void clearObservers() {
    _observers.length = 0;
  }
}

/**
 * Event-based subject for multi-event systems.
 */
class EventSubject {
  private IEventObserver[] _observers;

  /**
   * Attach an event observer.
   * Params:
   *   observer = The observer to attach
   */
  void attach(IEventObserver observer) {
    if (observer is null) return;
    
    foreach (obs; _observers) {
      if (obs is observer) return;
    }
    
    _observers ~= observer;
  }

  /**
   * Detach an event observer.
   * Params:
   *   observer = The observer to detach
   */
  void detach(IEventObserver observer) {
    if (observer is null) return;

    import std.algorithm : remove;
    import std.array : array;
    
    _observers = _observers.remove!(obs => obs is observer).array;
  }

  /**
   * Emit an event to all interested observers.
   * Params:
   *   eventType = The type of event
   *   data = The event data
   */
  void emit(string eventType, IEventData data) {
    foreach (observer; _observers) {
      if (observer.handlesEvent(eventType)) {
        observer.onEvent(eventType, data);
      }
    }
  }

  /**
   * Get the number of attached observers.
   * Returns: The count of observers
   */
  size_t observerCount() {
    return _observers.length;
  }

  /**
   * Clear all attached observers.
   */
  void clearObservers() {
    _observers.length = 0;
  }
}

// Unit tests
unittest {
  class TestSubject : Subject!TestSubject {
    private int _value;

    @safe void setValue(int v) {
      _value = v;
      notify();
    }

    @safe int value() { return _value; }
  }

  int updateCount = 0;
  auto observer = createObserver!TestSubject((subject, data) {
    updateCount++;
  });

  auto subject = new TestSubject();
  subject.attach(observer);
  assert(subject.observerCount() == 1);

  subject.setValue(42);
  assert(updateCount == 1);

  subject.detach(observer);
  assert(subject.observerCount() == 0);

  subject.setValue(100);
  assert(updateCount == 1); // No additional update
}

unittest {
  class TestSubject : Subject!TestSubject {}

  auto subject = new TestSubject();
  auto observer1 = createObserver!TestSubject((s, d) {});
  auto observer2 = createObserver!TestSubject((s, d) {});

  subject.attach(observer1);
  subject.attach(observer2);
  assert(subject.observerCount() == 2);

  // Try attaching the same observer again
  subject.attach(observer1);
  assert(subject.observerCount() == 2); // Should still be 2

  subject.clearObservers();
  assert(subject.observerCount() == 0);
}

unittest {
  auto eventSubject = new EventSubject();
  
  int eventCount = 0;
  auto observer = new EventObserver();
  observer.registerHandler("test.event", (type, data) {
    eventCount++;
  });

  eventSubject.attach(observer);
  assert(eventSubject.observerCount() == 1);

  auto data = new EventData("test.event");
  eventSubject.emit("test.event", data);
  assert(eventCount == 1);

  // Emit a different event
  eventSubject.emit("other.event", data);
  assert(eventCount == 1); // Should not increment
}
