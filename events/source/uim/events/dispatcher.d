/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.dispatcher;

import uim.core;
import uim.oop;
import uim.events.interfaces;
import uim.events.listener;
import uim.events.event;

mixin(ShowModule!());

@safe:

/**
 * Event dispatcher that manages event listeners and dispatches events
 */
class DEventDispatcher : UIMObject {

  this() {
    super();
  }

  // #region listeners
  protected DEventListener[][string] _listeners;
  /**
     * Add an event listener for a specific event name
     */
  DEventDispatcher addListener(string eventName, DEventListener listener) {
    if (eventName !in _listeners) {
      _listeners[eventName] = [];
    }
    _listeners[eventName] ~= listener;

    // Sort by priority (higher priority first)
    _listeners[eventName] = _listeners[eventName]
      .sort!((a, b) => a.priority() > b.priority())
      .array;

    return this;
  }
  
    /**
     * Remove all listeners for a specific event
     */
  DEventDispatcher removeListeners(string eventName) {
    _listeners.remove(eventName);
    return this;
  }
  // #endregion listeners

  /**
     * Add a callback as event listener
     */
  DEventDispatcher on(string eventName, EventCallback callback, int priority = 0) {
    return addListener(eventName, EventListener(callback, priority));
  }

  /**
     * Add a one-time callback as event listener
     */
  DEventDispatcher once(string eventName, EventCallback callback, int priority = 0) {
    return addListener(eventName, EventListenerOnce(callback, priority));
  }



  /**
     * Remove a specific listener
     */
  DEventDispatcher removeListener(string eventName, DEventListener listener) {
    if (eventName in _listeners) {
      import std.algorithm : remove;
      import std.range : enumerate;

      foreach (i, l; _listeners[eventName].enumerate) {
        if (l is listener) {
          _listeners[eventName] = _listeners[eventName].remove(i);
          break;
        }
      }
    }
    return this;
  }

  /**
     * Get all listeners for an event
     */
  DEventListener[] getListeners(string eventName) {
    if (eventName in _listeners) {
      return _listeners[eventName].dup;
    }
    return [];
  }

  /**
     * Check if event has any listeners
     */
  bool hasListeners(string eventName) {
    return (eventName in _listeners) && _listeners[eventName].length > 0;
  }

  /**
     * Dispatch an event synchronously
     */
  IEvent dispatch(IEvent event) {
    auto eventName = event.name();

    if (eventName in _listeners) {
      // Clean up executed one-time listeners
      DEventListener[] activeListeners;

      foreach (listener; _listeners[eventName]) {
        if (!listener.once() || !listener.hasExecuted()) {
          activeListeners ~= listener;
        }
      }

      _listeners[eventName] = activeListeners;

      // Execute listeners
      foreach (listener; _listeners[eventName]) {
        if (event.isPropagationStopped()) {
          break;
        }
        listener.execute(event);
      }
    }

    return event;
  }

  /**
     * Dispatch an event asynchronously using vibe.d
     */
  void dispatchAsync(IEvent event) @trusted {
    auto eventName = event.name();

    if (eventName in _listeners) {
      foreach (listener; _listeners[eventName]) {
        auto l = listener;
        auto e = event;
        runTask({
          try { l.execute(e); }
          catch (Exception ex) { /* Handle exception */ }
        });
      }
    }
  }

  /**
     * Clear all listeners
     */
  void clearListeners() {
    _listeners = null;
  }
}

// Factory function
auto EventDispatcher() {
  return new DEventDispatcher();
}

unittest {
  mixin(ShowTest!"Testing DEventDispatcher class...");

  auto dispatcher = EventDispatcher();
  int callCount = 0;

  dispatcher.on("test.event", (IEvent event) { callCount++; });

  auto event = Event("test.event");
  dispatcher.dispatch(event);
  assert(callCount == 1);

  // Test priority ordering
  string order = "";
  dispatcher.on("priority.test", (IEvent event) { order ~= "B"; }, 0);

  dispatcher.on("priority.test", (IEvent event) { order ~= "A"; }, 10);

  dispatcher.on("priority.test", (IEvent event) { order ~= "C"; }, -5);

  auto priorityEvent = Event("priority.test");
  dispatcher.dispatch(priorityEvent);
  assert(order == "ABC", "Expected ABC but got: " ~ order);

  // Test stop propagation
  string propagationOrder = "";
  dispatcher.on("stop.test", (IEvent event) {
    propagationOrder ~= "1";
    event.stopPropagation();
  }, 10);

  dispatcher.on("stop.test", (IEvent event) { propagationOrder ~= "2"; }, 0);

  auto stopEvent = Event("stop.test");
  dispatcher.dispatch(stopEvent);
  assert(propagationOrder == "1", "Propagation should have stopped after first listener");

  // Test one-time listener
  int onceCount = 0;
  dispatcher.once("once.test", (IEvent event) { onceCount++; });

  auto onceEvent = Event("once.test");
  dispatcher.dispatch(onceEvent);
  assert(onceCount == 1);

  dispatcher.dispatch(Event("once.test"));
  assert(onceCount == 1, "Once listener should only execute once");

  writeln("DEventDispatcher tests passed!");
}
