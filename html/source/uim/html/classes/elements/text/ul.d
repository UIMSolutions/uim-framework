/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.ul;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <ul> HTML element represents an unordered list of items, where the order of the items is not important. 
 * Each item in the list is typically represented by a <li> element, and the list can be styled using CSS to customize its appearance. 
 * When rendered in a web browser, the <ul> element typically displays the list items with bullet points to indicate that they are part of an unordered list.
 */
class Ul : HtmlElement {
    this() {
        super("ul");
    }

    static Ul opCall() {
        return new Ul();
    }


    static Ul opCall(string content) {
        return new Ul();
    }
}
///
unittest {
    assert(Ul() == "<ul></ul>");
}
