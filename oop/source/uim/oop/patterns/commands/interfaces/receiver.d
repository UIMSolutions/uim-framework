/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.receiver;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Receiver interface for objects that perform the actual work.
 * Commands delegate to receivers to perform operations.
 */
interface IReceiver {
    /**
     * Performs an action.
     * Params:
     *   action = The action to perform
     */
    @safe void action(string action);
}