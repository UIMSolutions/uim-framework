module uim.oop.patterns.commands.macro_;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Macro command that executes multiple commands.
 */
class MacroCommand : BaseCommand, IMacroCommand {
    private ICommand[] _commands;
    
    this(string name) @safe {
        super(name);
    }
    
    @safe void addCommand(ICommand command) {
        _commands ~= command;
    }
    
    @safe size_t commandCount() const {
        return _commands.length;
    }
    
    override @safe void execute() {
        foreach (command; _commands) {
            command.execute();
        }
    }
}