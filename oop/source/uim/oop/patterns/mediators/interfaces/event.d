module uim.oop.patterns.mediators.interfaces.event;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Event-based mediator interface.
 */
interface IEventMediator {
    /**
     * Subscribes to an event.
     * Params:
     *   eventName = The event name
     *   handler = The event handler
     */
    void subscribe(string eventName, void delegate(string eventData) @safe handler) @safe;
    
    /**
     * Unsubscribes from an event.
     * Params:
     *   eventName = The event name
     *   handler = The event handler to remove
     */
    void unsubscribe(string eventName, void delegate(string eventData) @safe handler) @safe;
    
    /**
     * Publishes an event.
     * Params:
     *   eventName = The event name
     *   eventData = The event data
     */
    void publish(string eventName, string eventData) @safe;
}