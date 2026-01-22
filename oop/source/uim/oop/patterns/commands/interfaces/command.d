/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces.command;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Command interface that declares the execution method.
 * All concrete commands must implement this interface.
 */
interface ICommand {
    /**
     * Executes the command.
     */
    @safe void execute();
    
    /**
     * Gets the command name.
     * Returns: The command identifier
     */
    @safe string name() const;
}