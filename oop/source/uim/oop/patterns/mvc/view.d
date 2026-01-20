/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.patterns.mvc.view;

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
    protected IModel _model;
    protected IController _controller;
    protected string _template;

    /**
     * Constructor
     * 
     * Params:
     *   model = Optional model to associate with this view
     */
    this(IModel model = null) {
        if (model !is null) {
            setModel(model);
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

        auto data = _model.getData();
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
    void update(IModel model) {
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
    void setController(IController controller) {
        _controller = controller;
    }

    /**
     * Gets the controller associated with this view
     * 
     * Returns: The associated controller
     */
    IController getController() {
        return _controller;
    }

    /**
     * Gets the model associated with this view
     * 
     * Returns: The associated model
     */
    IModel getModel() {
        return _model;
    }

    /**
     * Sets the model for this view
     * 
     * Params:
     *   model = The model to associate with this view
     */
    void setModel(IModel model) {
        _model = model;
        _model.attachView(this);
    }

    /**
     * Sets the template for this view
     * 
     * Params:
     *   templateStr = The template string
     */
    void setTemplate(string templateStr) {
        _template = templateStr;
    }

    /**
     * Gets the current template
     * 
     * Returns: The template string
     */
    string getTemplate() {
        return _template;
    }
}

/**
 * TemplateView - View with advanced template support
 * 
 * Supports placeholder replacement in templates
 */
class TemplateView : View {
    this(IModel model = null, string templateStr = null) {
        super(model);
        if (templateStr !is null) {
            _template = templateStr;
        }
    }

    /**
     * Renders the view with template variable substitution
     * 
     * Returns: The rendered output with variables replaced
     */
    override string render() {
        if (_model is null) {
            return "No model attached";
        }

        if (_template.length == 0) {
            return super.render();
        }

        import std.array : replace;
        
        string output = _template;
        auto data = _model.getData();
        
        foreach (key, value; data) {
            output = output.replace("{{" ~ key ~ "}}", value);
        }
        
        return output;
    }
}

/**
 * JSONView - View that renders data as JSON
 */
class JSONView : View {
    this(IModel model = null) {
        super(model);
    }

    /**
     * Renders the view as JSON
     * 
     * Returns: JSON formatted string
     */
    override string render() {
        if (_model is null) {
            return "{}";
        }

        import std.array : appender;
        import std.conv : to;
        
        auto result = appender!string();
        result.put("{\n");
        
        auto data = _model.getData();
        bool first = true;
        
        foreach (key, value; data) {
            if (!first) {
                result.put(",\n");
            }
            first = false;
            
            result.put("  \"");
            result.put(key);
            result.put("\": \"");
            result.put(value);
            result.put("\"");
        }
        
        result.put("\n}");
        return result.data;
    }
}

/**
 * HTMLView - View that renders data as HTML
 */
class HTMLView : View {
    protected string _cssClass;

    this(IModel model = null, string cssClass = "") {
        super(model);
        _cssClass = cssClass;
    }

    /**
     * Sets the CSS class for the HTML output
     * 
     * Params:
     *   cssClass = The CSS class name
     */
    void setCssClass(string cssClass) {
        _cssClass = cssClass;
    }

    /**
     * Renders the view as HTML
     * 
     * Returns: HTML formatted string
     */
    override string render() {
        if (_model is null) {
            return "<div>No model attached</div>";
        }

        import std.array : appender;
        
        auto result = appender!string();
        
        if (_cssClass.length > 0) {
            result.put("<div class=\"");
            result.put(_cssClass);
            result.put("\">\n");
        } else {
            result.put("<div>\n");
        }
        
        auto data = _model.getData();
        
        foreach (key, value; data) {
            result.put("  <p><strong>");
            result.put(key);
            result.put(":</strong> ");
            result.put(value);
            result.put("</p>\n");
        }
        
        result.put("</div>");
        return result.data;
    }
}

// Unit tests
unittest {
    import std.stdio : writeln;

    auto model = new Model();
    model.set("title", "Test");

    auto view = new View(model);
    auto output = view.render();
    assert(output.length > 0);
}

unittest {
    auto model = new Model();
    model.set("name", "John");
    model.set("age", "30");

    auto view = new TemplateView(model, "Hello {{name}}, you are {{age}} years old!");
    auto output = view.render();
    assert(output == "Hello John, you are 30 years old!");
}

unittest {
    auto model = new Model();
    model.set("key", "value");

    auto view = new JSONView(model);
    auto output = view.render();
    assert(output.length > 0);
}
