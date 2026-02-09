/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.hr;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <hr> HTML element represents a thematic break between paragraph-level elements. 
 * It is typically rendered as a horizontal rule or line, and it is used to visually separate content on a web page. 
 * The <hr> element can be used to indicate a change in topic, a shift in tone, or to create a visual break between sections of content. 
 * It is a self-closing element, meaning that it does not require a closing tag, and it can be styled using CSS to customize its appearance.
 */
class Hr : HtmlElement {
    this() {
        super("hr");
        this.selfClosing(true);
    }

    static Hr opCall() {
        return new Hr();
    }
}
///
unittest {
    assert(Hr() == "<hr />");
}
