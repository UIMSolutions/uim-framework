/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.interpreters.interfaces.interpreter;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interpreter evaluates expressions in a specific language.
 */
interface IInterpreter {
    /**
     * Evaluate an expression with the given context.
     */
    @safe Variant evaluate(IExpression expression, IInterpreterContext context);
    
    /**
     * Parse and evaluate input string.
     */
    @safe Variant evaluate(string input, IInterpreterContext context);
    
    /**
     * Get the parser used by this interpreter.
     */
    @safe IParser getParser();
}













