module uim.oop.patterns.mvc.views.json;

import uim.oop;

@safe:

/**
 * JsonView - View that renders data as Json
 */
class JsonView : View {
    this(IMVCModel model = null) {
        super(model);
    }

    /**
     * Renders the view as Json
     * 
     * Returns: Json formatted string
     */
    override string render() {
        if (_model is null) {
            return "{}";
        }

        import std.array : appender;
        import std.conv : to;
        
        auto result = appender!string();
        result.put("{\n");
        
        bool first = true;
        foreach (key, value; _model.data()) {
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
///
unittest {
    auto model = new MVCModel();
    model.data("key", "value");

    auto view = new JsonView(model);
    auto output = view.render();
    assert(output.length > 0);
}
