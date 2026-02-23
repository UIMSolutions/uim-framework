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
class H5Ul : HtmlElement {
  mixin(H5Template!("Ul", "ul", false));
  mixin(AttributeMethods!H5Ul);
}
///
unittest {
  assert(H5Ul() == `<ul></ul>`);
  assert(H5Ul(["testclass"]) == `<ul class="testclass"></ul>`);
  assert(H5Ul(["a": "b"]) == `<ul a="b"></ul>`);

  assert(H5Ul("Hello") == `<ul>Hello</ul>`);
  assert(H5Ul(["testclass"], "Hello") == `<ul class="testclass">Hello</ul>`);
  assert(H5Ul(["a": "b"], "Hello") == `<ul a="b">Hello</ul>`);

  assert(H5Ul(["testclass"], ["a": "b"], "Hello") == `<ul class="testclass" a="b">Hello</ul>`);
}
