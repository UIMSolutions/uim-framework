module uim.oop.patterns.commands.interfaces.parameterized;

import uim.oop;

mixin(ShowModule!());

@safe:


/**
 * Parameterized command interface.
 * Commands that accept parameters at runtime.
 */
interface IParameterizedCommand(TParam) : ICommand {
    /**
     * Sets the command parameters.
     * Params:
     *   params = The parameters to set
     */
    @safe void setParameters(TParam params);
    
    /**
     * Gets the command parameters.
     * Returns: The current parameters
     */
    @safe TParam getParameters() const;
}