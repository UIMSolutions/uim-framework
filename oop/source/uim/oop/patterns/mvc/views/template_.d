module uim.oop.patterns.mvc.views.template_;

import uim.oop;

@safe:

/**
 * TemplateView - View with advanced template support
 * 
 * Supports placeholder replacement in templates
 */
class TemplateView : View {
    this(IMVCModel aModel = null, string templateStr = null) {
        super(aModel);
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
        auto data = _model.data();
        
        foreach (key, value; data) {
            output = output.replace("{{" ~ key ~ "}}", value);
        }
        
        return output;
    }
}
///
unittest {
    auto model = new MVCModel();
    model.data("name", "John");
    model.data("age", "30");

    auto view = new TemplateView(model, "Hello {{name}}, you are {{age}} years old!");
    auto output = view.render();
    assert(output == "Hello John, you are 30 years old!");
}

