/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.base;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Abstract base command with common functionality.
 */
abstract class BaseCommand : UIMObject, ICommand {
    protected string _name;
    
    this(string commandName) @safe {
        _name = commandName;
    }
    
    @safe string name() const {
        return _name;
    }
    
    abstract void execute();
}
