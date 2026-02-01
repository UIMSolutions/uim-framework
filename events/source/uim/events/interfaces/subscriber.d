/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.events.interfaces.subscriber;

import uim.events;

mixin(ShowModule!());

@safe:

/**
 * Event subscriber interface for registering multiple event listeners at once
 */
interface IEventSubscriber {
    /**
     * Register event listeners with a dispatcher
     */
    void subscribe(UIMEventDispatcher dispatcher);
}