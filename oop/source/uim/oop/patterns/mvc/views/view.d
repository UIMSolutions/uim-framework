/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.views.view;

import uim.oop;

@safe:

/**
 * View - Base implementation of the View component in MVC pattern
 * 
 * This class provides a basic implementation of IView with support for:
 * - Model observation and updates
 * - Template-based rendering
 * - Controller communication
 */
class View : IView {
    protected IMVCModel _model;
    protected IController _controller;
    protected string _template;

    /**
     * Constructor
     * 
     * Params:
     *   model = Optional model to associate with this view
     */
    this(IMVCModel aModel = null) {
        if (aModel !is null) {
            model(aModel);
        }
    }

    /**
     * Renders the view with the current model data
     * 
     * Returns: The rendered output
     */
    string render() {
        if (_model is null) {
            return "No model attached";
        }

        auto data = _model.data();
        return formatOutput(data);
    }

    /**
     * Formats the output for rendering
     * 
     * Override this method to customize rendering
     * 
     * Params:
     *   data = The data to format
     * 
     * Returns: The formatted output
     */
    protected string formatOutput(string[string] data) {
        import std.array : appender;
        
        auto result = appender!string();
        
        if (_template.length > 0) {
            result.put(_template);
            result.put("\n");
        }
        
        foreach (key, value; data) {
            result.put(key);
            result.put(": ");
            result.put(value);
            result.put("\n");
        }
        
        return result.data;
    }

    /**
     * Updates the view when the model changes
     * 
     * Params:
     *   model = The model that has changed
     */
    void update(IMVCModel model) {
        // Override in subclasses for custom update behavior
        // By default, just store the reference
        _model = model;
    }

    /**
     * Sets the controller for this view
     * 
     * Params:
     *   controller = The controller to associate with this view
     */
    void controller(IController aController) {
        _controller = aController;
    }

    /**
     * Gets the controller associated with this view
     * 
     * Returns: The associated controller
     */
    IController controller() {
        return _controller;
    }

    /**
     * Gets the model associated with this view
     * 
     * Returns: The associated model
     */
    IMVCModel model() {
        return _model;
    }

    /**
     * Sets the model for this view
     * 
     * Params:
     *   model = The model to associate with this view
     */
    void model(IMVCModel model) {
        _model = model;
        _model.attachView(this);
    }

    /**
     * Sets the template for this view
     * 
     * Params:
     *   templateStr = The template string
     */
    void template_(string templateStr) {
        _template = templateStr;
    }

    /**
     * Gets the current template
     * 
     * Returns: The template string
     */
    string template_() {
        return _template;
    }
}
///
unittest {
    import std.stdio : writeln;

    auto model = new MVCModel();
    model.data("title", "Test");

    auto view = new View(model);
    auto output = view.render();
    assert(output.length > 0);
}

