/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.application;

import uim.oop;

@safe:

/**
 * MVCApplication - Complete MVC application implementation
 * 
 * This class combines Model, View, and Controller into a complete application
 */
class MVCApplication : IMVCApplication {
    protected IMVCModel _model;
    protected IView _view;
    protected IController _controller;
    protected bool _initialized;

    /**
     * Constructor
     * 
     * Params:
     *   model = The model to use
     *   view = The view to use
     *   controller = The controller to use
     */
    this(IMVCModel model = null, IView view = null, IController controller = null) {
        _model = model;
        _view = view;
        _controller = controller;
    }

    /**
     * Initializes the MVC application
     * 
     * Sets up the relationships between Model, View, and Controller
     */
    void initialize() {
        if (_initialized) {
            return;
        }

        // Create default components if not provided
        if (_model is null) {
            _model = new MVCModel();
        }

        if (_view is null) {
            _view = new View(_model);
        }

        if (_controller is null) {
            _controller = new Controller(_model, _view);
        }

        // Wire up the components
        if (_controller.model() is null) {
            _controller.model(_model);
        }

        if (_controller.view() is null) {
            _controller.view(_view);
        }

        if (_view.model() is null) {
            _view.model(_model);
        }

        if (_view.controller() is null) {
            _view.controller(_controller);
        }

        _initialized = true;
    }

    /**
     * Runs the application with the given input
     * 
     * Params:
     *   input = The input to process
     * 
     * Returns: The output from the application
     */
    string run(string[string] input) {
        if (!_initialized) {
            initialize();
        }

        return _controller.handleRequest(input);
    }

    /**
     * Gets the model of the application
     * 
     * Returns: The application model
     */
    IMVCModel model() {
        return _model;
    }

    /**
     * Gets the view of the application
     * 
     * Returns: The application view
     */
    IView view() {
        return _view;
    }

    /**
     * Gets the controller of the application
     * 
     * Returns: The application controller
     */
    IController controller() {
        return _controller;
    }

    /**
     * Sets the model for the application
     * 
     * Params:
     *   model = The model to set
     */
    void setModel(IMVCModel model) {
        _model = model;
        _initialized = false;
    }

    /**
     * Sets the view for the application
     * 
     * Params:
     *   view = The view to set
     */
    void setView(IView view) {
        _view = view;
        _initialized = false;
    }

    /**
     * Sets the controller for the application
     * 
     * Params:
     *   controller = The controller to set
     */
    void setController(IController controller) {
        _controller = controller;
        _initialized = false;
    }
}

/**
 * Helper function to create a complete MVC application
 * 
 * Returns: A new initialized MVC application
 */
MVCApplication createMVCApplication() {
    auto app = new MVCApplication();
    app.initialize();
    return app;
}

/**
 * Helper function to create an MVC application with custom components
 * 
 * Params:
 *   model = The model to use
 *   view = The view to use
 *   controller = The controller to use
 * 
 * Returns: A new initialized MVC application
 */
MVCApplication createMVCApplication(IMVCModel model, IView view, IController controller) {
    auto app = new MVCApplication(model, view, controller);
    app.initialize();
    return app;
}

// Unit tests
unittest {
    import std.stdio : writeln;

    auto app = createMVCApplication();
    assert(app.model() !is null);
    assert(app.view() !is null);
    assert(app.controller() !is null);
}

unittest {
    auto model = new MVCModel();
    model.data("greeting", "Hello");
    
    auto view = new View(model);
    auto controller = new Controller(model, view);
    
    auto app = createMVCApplication(model, view, controller);
    
    auto output = app.run(["action": "index"]);
    assert(output.length > 0);
}

unittest {
    auto app = new MVCApplication();
    app.initialize();
    
    auto model = app.model();
    model.data("test", "value");
    
    assert(model.data("test") == "value");
}
