module uim.oop.patterns.commands.invoker;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Simple invoker that executes a command.
 */
class Invoker : IInvoker {
    private ICommand _command;

    @safe void setCommand(ICommand command) {
        _command = command;
    }

    @safe void executeCommand() {
        if (_command !is null) {
            _command.execute();
        }
    }
}
