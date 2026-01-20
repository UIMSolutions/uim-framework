module uim.oop.patterns.mediators.interfaces.mediator;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Mediator interface defines communication between colleague objects.
 */
interface IMediator {
    /**
     * Notifies the mediator about an event from a colleague.
     * Params:
     *   sender = The colleague object sending the notification
     *   event = The event identifier
     */
    void notify(IColleague sender, string event) @safe;
}
