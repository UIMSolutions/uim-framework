/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.controllers.controller;

import uim.oop;

@safe:

/**
 * Controller - Base implementation of the Controller component in MVC pattern
 * 
 * This class provides a basic implementation of IController with support for:
 * - Request handling
 * - Action execution
 * - Model and View coordination
 */
class Controller : IController {
    protected IMVCModel _model;
    protected IView _view;
    protected string[string] delegate(string[string]) @safe[string] _actions;

    /**
     * Constructor
     * 
     * Params:
     *   model = Optional model to control
     *   view = Optional view to control
     */
    this(IMVCModel model = null, IView view = null) {
        // TODO: if (model !is null) {
        // TODO:     model(model);
        // TODO: }
        // TODO: if (view !is null) {
        // TODO:     view(view);
        // TODO: }
        
        registerDefaultActions();
    }

    /**
     * Registers default actions
     * 
     * Override this method to register custom actions
     */
    protected void registerDefaultActions() {
        // Default actions can be registered here
    }

    /**
     * Handles a user request
     * 
     * Params:
     *   input = The user input
     * 
     * Returns: The response
     */
    string handleRequest(string[string] input) {
        string action = input.get("action", "index");
        
        // Execute the action
        auto result = executeAction(action, input);
        
        // Return the view rendering if available
        if (_view !is null) {
            return _view.render();
        }
        
        return result;
    }

    /**
     * Executes an action
     * 
     * Params:
     *   action = The name of the action to execute
     *   params = Parameters for the action
     * 
     * Returns: The result of the action
     */
    string executeAction(string action, string[string] params = null) {
        if (action in _actions) {
            auto result = _actions[action](params);
            return result.get("result", "Action executed");
        }
        
        return handleUnknownAction(action, params);
    }

    /**
     * Handles unknown actions
     * 
     * Override this method to customize behavior for unknown actions
     * 
     * Params:
     *   action = The unknown action name
     *   params = The parameters
     * 
     * Returns: Error message or result
     */
    protected string handleUnknownAction(string action, string[string] params) {
        return "Unknown action: " ~ action;
    }

    /**
     * Registers an action handler
     * 
     * Params:
     *   name = The name of the action
     *   handler = The handler delegate
     */
    void registerAction(string name, string[string] delegate(string[string]) @safe handler) {
        _actions[name] = handler;
    }

    /**
     * Sets the model for this controller
     * 
     * Params:
     *   model = The model to control
     */
    void model(IMVCModel model) {
        _model = model;
    }

    /**
     * Gets the model controlled by this controller
     * 
     * Returns: The associated model
     */
    IMVCModel model() {
        return _model;
    }

    /**
     * Sets the view for this controller
     * 
     * Params:
     *   view = The view to control
     */
    void view(IView view) {
        _view = view;
        if (_view !is null) {
            _view.controller(this);
        }
    }

    /**
     * Gets the view controlled by this controller
     * 
     * Returns: The associated view
     */
    IView view() {
        return _view;
    }

    /**
     * Updates the model with new data
     * 
     * Params:
     *   key = The key to update
     *   value = The value to set
     */
    protected void updateModel(string key, string value) {
        if (_model !is null) {
            _model.data(key, value);
        }
    }

    /**
     * Updates the model with multiple values
     * 
     * Params:
     *   data = The data to update
     */
    protected void updateModel(string[string] data) {
        if (_model !is null) {
            foreach (key, value; data) {
                _model.data(key, value);
            }
        }
    }
}

// Unit tests
unittest {
    import std.stdio : writeln;

    auto model = new MVCModel();
    auto view = new View(model);
    auto controller = new Controller(model, view);

    // TODO: assert(controller.model() is model);
    // TODO: assert(controller.view() is view);
}

unittest {
    auto model = new MVCModel();
    auto controller = new RESTController(model);

    auto result = controller.executeAction("create", ["name": "Test", "value": "123"]);
    // TODO: assert(model.data("name") == "Test");
}

unittest {
    auto controller = new ValidationController();
    
    controller.addValidationRule((input) {
        return ("name" in input) !is null;
    });

    assert(!controller.validateInput(["value": "test"]));
    assert(controller.validateInput(["name": "test"]));
}
