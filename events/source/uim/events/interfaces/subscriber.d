module uim.events.interfaces.subscriber;

import uim.core;
import uim.oop;
import uim.events.dispatcher;
import std.datetime : SysTime, Clock;

mixin(ShowModule!());

@safe:

/**
 * Event subscriber interface for registering multiple event listeners at once
 */
interface IEventSubscriber {
    /**
     * Register event listeners with a dispatcher
     */
    void subscribe(DEventDispatcher dispatcher);
}