/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.controllers.validation;

import uim.oop;

@safe:
/**
 * ValidationController - Controller with validation support
 * 
 * Validates input before processing
 */
class ValidationController : Controller {
    alias ValidationRule = bool delegate(string[string]) @safe;
    protected ValidationRule[] _validationRules;

    this(IMVCModel model = null, IView view = null) {
        super(model, view);
    }

    /**
     * Adds a validation rule
     * 
     * Params:
     *   rule = The validation rule to add
     */
    void addValidationRule(ValidationRule rule) {
        _validationRules ~= rule;
    }

    /**
     * Validates input against all rules
     * 
     * Params:
     *   input = The input to validate
     * 
     * Returns: true if valid, false otherwise
     */
    bool validateInput(string[string] input) {
        foreach (rule; _validationRules) {
            if (!rule(input)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Handles request with validation
     * 
     * Params:
     *   input = The user input
     * 
     * Returns: The response
     */
    override string handleRequest(string[string] input) {
        if (!validateInput(input)) {
            return "Validation failed";
        }
        
        return super.handleRequest(input);
    }
}
