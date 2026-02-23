/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.p;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <p> HTML element represents a paragraph of text. 
 * It is used to group together related sentences and to create a block of text that is visually separated from other content on the page. 
 * The <p> element can contain any flow content, such as text, images, and other HTML elements, and it is usually displayed with some vertical spacing before and after it by default. 
 * When rendered in a web browser, the <p> element typically displays the text within it as a block-level element, meaning that it takes up the full width of its container and starts on a new line.
 */
class H5P : HtmlElement {
  mixin(H5Template!("P", "p", false));
  mixin(AttributeMethods!H5P);
}
///
unittest {
  assert(H5P() == `<p></p>`);
  assert(H5P(["testclass"]) == `<p class="testclass"></p>`);
  assert(H5P(["a":"b"]) == `<p a="b"></p>`);

  assert(H5P("Hello") == `<p>Hello</p>`);
  assert(H5P(["testclass"], "Hello") == `<p class="testclass">Hello</p>`);
  assert(H5P(["a":"b"], "Hello") == `<p a="b">Hello</p>`);

  assert(H5P(["testclass"], ["a":"b"], "Hello") == `<p class="testclass" a="b">Hello</p>`);
}
