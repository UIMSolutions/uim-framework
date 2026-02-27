/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.chains.interfaces.priority;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Priority-based handler interface.
 */
interface IPriorityHandler : IHandler {
    /**
     * Gets the handler priority.
     * Returns: The priority level (higher = processed first)
     */
    int priority() const;
}
