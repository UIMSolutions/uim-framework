/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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
