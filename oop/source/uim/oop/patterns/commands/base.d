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