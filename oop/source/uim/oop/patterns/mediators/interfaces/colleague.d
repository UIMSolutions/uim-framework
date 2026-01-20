module uim.oop.patterns.mediators.interfaces.colleague;

import uim.oop;
import uim.oop.patterns.mediators.interfaces.mediator;

mixin(ShowModule!());

@safe:

/**
 * Colleague interface for objects that communicate through a mediator.
 */
interface IColleague {
    /**
     * Sets the mediator for this colleague.
     * Params:
     *   mediator = The mediator instance
     */
    void mediator(IMediator mediator) @safe;
    
    /**
     * Gets the current mediator.
     * Returns: The mediator instance
     */
    IMediator mediator() @safe;
}