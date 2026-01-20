/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.observers.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Observer interface for the Observer pattern.
 * Observers receive notifications when the subject's state changes.
 */
interface IObserver(T) {
  /**
   * Called when the observed subject changes.
   * Params:
   *   subject = The subject that changed
   *   data = Optional data about the change
   */
  void update(T subject, Object data = null);
}

/**
 * Subject interface for the Observer pattern.
 * Maintains a list of observers and notifies them of state changes.
 */
interface ISubject(T) {
  /**
   * Attach an observer to the subject.
   * Params:
   *   observer = The observer to attach
   */
  void attach(IObserver!T observer);

  /**
   * Detach an observer from the subject.
   * Params:
   *   observer = The observer to detach
   */
  void detach(IObserver!T observer);

  /**
   * Notify all attached observers of a state change.
   * Params:
   *   data = Optional data about the change
   */
  void notify(Object data = null);

  /**
   * Get the number of attached observers.
   * Returns: The count of observers
   */
  size_t observerCount();

  /**
   * Clear all attached observers.
   */
  void clearObservers();
}

/**
 * Interface for typed event data.
 */
interface IEventData {
  /**
   * Get the event type.
   * Returns: The event type identifier
   */
  string eventType();
}

/**
 * Interface for observers that can handle multiple event types.
 */
interface IEventObserver {
  /**
   * Handle an event with typed data.
   * Params:
   *   eventType = The type of event
   *   data = The event data
   */
  void onEvent(string eventType, IEventData data);

  /**
   * Check if the observer handles a specific event type.
   * Params:
   *   eventType = The event type to check
   * Returns: true if the observer handles this event type
   */
  bool handlesEvent(string eventType);
}
