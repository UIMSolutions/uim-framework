/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.interpreters.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Context holds information that is global to the interpreter.
 * It typically stores variables and their values.
 */
interface IContext {
    /**
     * Set a variable value in the context.
     */
    void setVariable(string name, Variant value);
    
    /**
     * Get a variable value from the context.
     */
    Variant getVariable(string name) const;
    
    /**
     * Check if a variable exists in the context.
     */
    @safe bool hasVariable(string name) const;
    
    /**
     * Clear all variables from the context.
     */
    @safe void clear();
    
    /**
     * Get all variable names.
     */
    @safe string[] getVariableNames() const;
}








/**
 * Interpreter evaluates expressions in a specific language.
 */
interface IInterpreter {
    /**
     * Evaluate an expression with the given context.
     */
    @safe Variant evaluate(IExpression expression, IContext context);
    
    /**
     * Parse and evaluate input string.
     */
    @safe Variant evaluate(string input, IContext context);
    
    /**
     * Get the parser used by this interpreter.
     */
    @safe IParser getParser();
}













