/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.events.interfaces.dispatcher;

import uim.events;

mixin(ShowModule!());

@safe:

/**
 * Event dispatcher interface that manages event listeners and dispatches events
 */
interface IEventDispatcher {
  /**
   * Add an event listener for a specific event name
   */
  IEventDispatcher addListener(string eventName, UIMEventListener listener);

  /**
   * Remove all listeners for a specific event
   */
  IEventDispatcher removeListeners(string eventName);

  /**
   * Remove a specific listener
   */
  IEventDispatcher removeListener(string eventName, UIMEventListener listener);

  /**
   * Get all listeners for an event
   */
  UIMEventListener[] getListeners(string eventName);

  /**
   * Check if event has any listeners
   */
  bool hasListeners(string eventName);

  /**
   * Add a callback as event listener
   */
  IEventDispatcher on(string eventName, EventCallback callback, int priority = 0);

  /**
   * Add a one-time callback as event listener
   */
  IEventDispatcher once(string eventName, EventCallback callback, int priority = 0);

  /**
   * Dispatch an event synchronously
   */
  IEvent dispatch(IEvent event);

  /**
   * Dispatch an event asynchronously
   */
  void dispatchAsync(IEvent event) @trusted;

  /**
   * Clear all listeners
   */
  void clearListeners();
}
