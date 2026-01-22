/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.invoker;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Command invoker interface.
 * Responsible for executing commands.
 */
interface IInvoker {
    /**
     * Sets the command to execute.
     * Params:
     *   command = The command to set
     */
    @safe void setCommand(ICommand command);
    
    /**
     * Executes the current command.
     */
    @safe void executeCommand();
}