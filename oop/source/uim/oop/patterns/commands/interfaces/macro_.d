module uim.oop.patterns.commands.interfaces.macro_;


import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Macro command interface for composite commands.
 * Executes multiple commands as a single command.
 */
interface IMacroCommand : ICommand {
    /**
     * Adds a command to the macro.
     * Params:
     *   command = The command to add
     */
    @safe void addCommand(ICommand command);
    
    /**
     * Gets the number of commands in the macro.
     * Returns: The command count
     */
    @safe size_t commandCount() const;
}