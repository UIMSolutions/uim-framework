module uim.events.interfaces.listener;

import uim.events;

mixin(ShowModule!());

@safe:

/**
 * Event listener interface with priority support
 */
interface IEventListener {
  /**
   * Get the callback function
   */
  EventCallback callback();

  /**
   * Set the callback function
   */
  IEventListener callback(EventCallback value);

  /**
   * Get the listener priority (higher = earlier execution)
   */
  int priority();

  /**
   * Set the listener priority
   */
  IEventListener priority(int value);

  /**
   * Check if this listener should only execute once
   */
  bool once();

  /**
   * Set whether this listener should only execute once
   */
  IEventListener once(bool value);

  /**
   * Execute the listener callback
   */
  void execute(IEvent event);

  /**
   * Check if this listener has been executed (for one-time listeners)
   */
  bool hasExecuted();

  /**
   * Reset execution state
   */
  void reset();
}
