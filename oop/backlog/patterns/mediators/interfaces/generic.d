module uim.oop.patterns.mediators.interfaces.generic;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic mediator interface with typed messages.
 */
interface IGenericMediator(TMessage) {
    /**
     * Sends a typed message through the mediator.
     * Params:
     *   sender = The sender identifier
     *   message = The message to send
     */
    void send(string sender, TMessage message) @safe;
    
    /**
     * Registers a receiver for messages.
     * Params:
     *   receiver = The receiver identifier
     *   handler = The message handler callback
     */
    void register(string receiver, void delegate(string sender, TMessage message) @safe handler) @safe;
    
    /**
     * Unregisters a receiver.
     * Params:
     *   receiver = The receiver identifier
     */
    void unregister(string receiver) @safe;
}