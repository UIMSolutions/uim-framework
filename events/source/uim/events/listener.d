/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.listener;

import uim.core;
import uim.oop;
import uim.events.interfaces;

mixin(ShowModule!());

@safe:

/**
 * Event listener callback type
 */
alias EventCallback = void delegate(IEvent event) @safe;

/**
 * Event listener with priority support
 */
class DEventListener : UIMObject {
  private int _priority;
  private bool _once;

  // #region callback
  private EventCallback _callback;
  // Getter and setter for callback
  EventCallback callback() {
    return _callback;
  }
    ///
  unittest {
    writeln("Testing DEventListener callback getter/setter...");
    int callCount = 0;
    auto listener = EventListener((IEvent event) { callCount++; });
    assert(listener.callback() !is null, "Callback should not be null");
    auto event = cast(IEvent) null;
    listener.callback()(event);
    assert(callCount == 1, "Callback should have been called once");
    writeln("DEventListener callback tests passed!");
  }
  
  DEventListener callback(EventCallback value) {
    _callback = value;
    return this;
  }
  ///
  unittest {
    mixin(ShowTest!"Testing DEventListener callback getter/setter...");

    int callCount = 0;
    auto listener = EventListener((IEvent event) { callCount++; });
    assert(listener.callback() !is null, "Callback should not be null");
    auto event = cast(IEvent) null;
    listener.callback()(event);
    assert(callCount == 1, "Callback should have been called once");
    writeln("DEventListener callback tests passed!");
  }
  // #endregion callback

  // Getter and setter for priority
  int priority() {
    return _priority;
  }
  
  DEventListener priority(int value) {
    _priority = value;
    return this;
  }

  // Getter and setter for once
  bool once() {
    return _once;
  }
  
  DEventListener once(bool value) {
    _once = value;
    return this;
  }

  protected bool _executed = false;

  this() {
    super();
    this.priority(0);
    this.once(false);
  }

  this(EventCallback callback, int priority = 0) {
    this();
    this.callback(callback);
    this.priority(priority);
  }

  /**
     * Execute the listener callback
     */
  void execute(IEvent event) {
    if (this.once() && _executed) {
      return;
    }

    auto cb = this.callback();
    if (cb !is null) {
      cb(event);
      _executed = true;
    }
  }

  /**
     * Check if this listener has been executed (for one-time listeners)
     */
  bool hasExecuted() {
    return _executed;
  }

  /**
     * Reset execution state
     */
  void reset() {
    _executed = false;
  }
}

// Factory functions
auto EventListener(EventCallback callback, int priority = 0) {
  return new DEventListener(callback, priority);
}

auto EventListenerOnce(EventCallback callback, int priority = 0) {
  auto listener = new DEventListener(callback, priority);
  listener.once(true);
  return listener;
}

unittest {
  import uim.events.event : Event;
  
  writeln("Testing DEventListener class...");

  int callCount = 0;
  auto listener = EventListener((IEvent event) { callCount++; });

  auto event = Event("test");
  listener.execute(event);
  assert(callCount == 1);

  listener.execute(event);
  assert(callCount == 2);

  // Test one-time listener
  int onceCount = 0;
  auto onceListener = EventListenerOnce((IEvent event) { onceCount++; });

  onceListener.execute(event);
  assert(onceCount == 1);

  onceListener.execute(event);
  assert(onceCount == 1, "One-time listener should only execute once");

  writeln("DEventListener tests passed!");
}
