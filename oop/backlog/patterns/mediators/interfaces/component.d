module uim.oop.patterns.mediators.interfaces.component;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Component interface for mediator-managed components.
 */
interface IMediatorComponent {
    /**
     * Gets the component name.
     * Returns: The component identifier
     */
    string name() const @safe;
    
    /**
     * Sends a message through the component's mediator.
     * Params:
     *   message = The message to send
     */
    void send(string message) @safe;
    
    /**
     * Receives a message from the mediator.
     * Params:
     *   sender = The sender name
     *   message = The message content
     */
    void receive(string sender, string message) @safe;
}