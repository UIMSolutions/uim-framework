/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.patterns.mvc.controller;

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
    protected IModel _model;
    protected IView _view;
    protected string[string] delegate(string[string]) @safe[string] _actions;

    /**
     * Constructor
     * 
     * Params:
     *   model = Optional model to control
     *   view = Optional view to control
     */
    this(IModel model = null, IView view = null) {
        if (model !is null) {
            setModel(model);
        }
        if (view !is null) {
            setView(view);
        }
        
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
    void setModel(IModel model) {
        _model = model;
    }

    /**
     * Gets the model controlled by this controller
     * 
     * Returns: The associated model
     */
    IModel getModel() {
        return _model;
    }

    /**
     * Sets the view for this controller
     * 
     * Params:
     *   view = The view to control
     */
    void setView(IView view) {
        _view = view;
        if (_view !is null) {
            _view.setController(this);
        }
    }

    /**
     * Gets the view controlled by this controller
     * 
     * Returns: The associated view
     */
    IView getView() {
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
            _model.set(key, value);
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
                _model.set(key, value);
            }
        }
    }
}

/**
 * RESTController - Controller for RESTful operations
 * 
 * Provides standard CRUD operations
 */
class RESTController : Controller {
    this(IModel model = null, IView view = null) {
        super(model, view);
    }

    /**
     * Registers RESTful actions
     */
    override protected void registerDefaultActions() {
        // Index action - list all
        registerAction("index", (params) {
            return ["result": "Index action"];
        });

        // Show action - show one
        registerAction("show", (params) {
            string id = params.get("id", "");
            return ["result": "Show action for id: " ~ id];
        });

        // Create action - create new
        registerAction("create", (params) {
            if (_model !is null) {
                foreach (key, value; params) {
                    if (key != "action") {
                        _model.set(key, value);
                    }
                }
            }
            return ["result": "Create action"];
        });

        // Update action - update existing
        registerAction("update", (params) {
            string id = params.get("id", "");
            if (_model !is null) {
                foreach (key, value; params) {
                    if (key != "action" && key != "id") {
                        _model.set(key, value);
                    }
                }
            }
            return ["result": "Update action for id: " ~ id];
        });

        // Delete action - delete existing
        registerAction("delete", (params) {
            string id = params.get("id", "");
            return ["result": "Delete action for id: " ~ id];
        });
    }
}

/**
 * ValidationController - Controller with validation support
 * 
 * Validates input before processing
 */
class ValidationController : Controller {
    alias ValidationRule = bool delegate(string[string]) @safe;
    protected ValidationRule[] _validationRules;

    this(IModel model = null, IView view = null) {
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

/**
 * AsyncController - Controller with async operation support
 * 
 * Provides hooks for before/after action execution
 */
class AsyncController : Controller {
    alias BeforeAction = void delegate(string, string[string]) @safe;
    alias AfterAction = void delegate(string, string[string], string) @safe;

    protected BeforeAction[] _beforeActions;
    protected AfterAction[] _afterActions;

    this(IModel model = null, IView view = null) {
        super(model, view);
    }

    /**
     * Registers a before action callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void before(BeforeAction callback) {
        _beforeActions ~= callback;
    }

    /**
     * Registers an after action callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void after(AfterAction callback) {
        _afterActions ~= callback;
    }

    /**
     * Executes action with before/after hooks
     * 
     * Params:
     *   action = The action name
     *   params = The parameters
     * 
     * Returns: The result
     */
    override string executeAction(string action, string[string] params = null) {
        // Execute before actions
        foreach (callback; _beforeActions) {
            callback(action, params);
        }

        // Execute the action
        auto result = super.executeAction(action, params);

        // Execute after actions
        foreach (callback; _afterActions) {
            callback(action, params, result);
        }

        return result;
    }
}

// Unit tests
unittest {
    import std.stdio : writeln;

    auto model = new Model();
    auto view = new View(model);
    auto controller = new Controller(model, view);

    assert(controller.getModel() is model);
    assert(controller.getView() is view);
}

unittest {
    auto model = new Model();
    auto controller = new RESTController(model);

    auto result = controller.executeAction("create", ["name": "Test", "value": "123"]);
    assert(model.get("name") == "Test");
}

unittest {
    auto controller = new ValidationController();
    
    controller.addValidationRule((input) {
        return ("name" in input) !is null;
    });

    assert(!controller.validateInput(["value": "test"]));
    assert(controller.validateInput(["name": "test"]));
}
