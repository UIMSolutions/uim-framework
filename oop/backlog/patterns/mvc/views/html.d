/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.views.html;

import uim.oop;

@safe:

/**
 * HTMLView - View that renders data as HTML
 */
class HTMLView : View {
    protected string _cssClass;

    this(IMVCModel model = null, string cssClass = "") {
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
        
        auto data = _model.data();
        
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