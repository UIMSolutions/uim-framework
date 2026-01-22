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

    bool execute(Json[string] options = null) @safe {
        foreach (command; _commands) {
            if (auto undoable = cast(IUndoableCommand) command) {
                undoable.execute(options);
            } else {
                command.execute();
            }
        }
        return true;
    }

    CommandResult executeWithResult(Json[string] options = null) @safe {
        CommandResult finalResult; //  = CommandResult.success;
        /* foreach (command; _commands) {
            CommandResult result;
            if (auto undoable = cast(IUndoableCommand) command) {
                result = undoable.executeWithResult(options);
            } else {
                command.execute();
                result = CommandResult.Success;
            }
            if (result == CommandResult.Failure && finalResult != CommandResult.Failure) {
                finalResult = CommandResult.Failure;
            } else if (result == CommandResult.PartialSuccess && finalResult == CommandResult.Success) {
                finalResult = CommandResult.PartialSuccess;
            }
        } */ 
        return finalResult;
    }

    bool validateParameters(Json[string] options = null) @safe {
        return true;
    }

    bool canExecute(Json[string] options = null) @safe {
        return true;
    }

}