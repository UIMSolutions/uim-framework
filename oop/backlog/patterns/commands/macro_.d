/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.macro_;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Macro command that executes multiple commands.
 */
class MacroCommand : BaseCommand, IMacroCommand {
    private ICommand[] _commands;
    
    this(string name) {
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

    bool execute(Json[string] options = null) {
        foreach (command; _commands) {
            if (auto undoable = cast(IUndoableCommand) command) {
                undoable.execute(options);
            } else {
                command.execute();
            }
        }
        return true;
    }

    CommandResult executeWithResult(Json[string] options = null) {
        int totalCommands = cast(int)_commands.length;
        int successCount = 0;
        bool hadFailure = false;
        
        foreach (command; _commands) {
            CommandResult result;
            if (auto undoable = cast(IUndoableCommand) command) {
                result = undoable.executeWithResult(options);
            } else {
                command.execute();
                result = CommandResult.ok("Command executed");
            }
            
            if (result.isSuccess()) {
                successCount++;
            } else {
                hadFailure = true;
            }
        }
        
        bool allSuccess = successCount == totalCommands;
        string message = allSuccess 
            ? "All commands executed successfully"
            : "Executed " ~ successCount.to!string ~ " of " ~ totalCommands.to!string ~ " commands";
        
        auto data = Json.emptyObject;
        data["totalCommands"] = totalCommands;
        data["successCount"] = successCount;
        
        return CommandResult(allSuccess, message, data);
    }

    bool validateParameters(Json[string] options = null) {
        return true;
    }

    bool canExecute(Json[string] options = null) {
        return true;
    }

}