/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.text.ol;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <ol> HTML element represents an ordered list of items, where the order of the items is important. 
 * Each item in the list is typically represented by a <li> element, and the list can be styled using CSS to customize its appearance. 
 * The <ol> element can also include attributes such as "type" to specify the type of numbering for the list items, and "start" to specify the starting value for the first list item. 
 * When rendered in a web browser, the <ol> element typically displays the list items with numbers or letters to indicate their order.
 *
  * Example usage:
  * ```html
  * <ol type="A" start="3">
  *   <li>Item 1</li>
  *   <li>Item 2</li>
  *   <li>Item 3</li>
  * </ol>
  * ```
  * This would create an ordered list with uppercase letters starting from "C" for the first item, resulting in the following output:
  * C. Item 1
  * D. Item 2
  * E. Item 3
 */
 @StringAttribute("type") // Specifies the type of numbering for the list items. Possible values include "1" for decimal numbers, "A" for uppercase letters, "a" for lowercase letters, "I" for uppercase Roman numerals, and "i" for lowercase Roman numerals.
 @StringAttribute("start") // Specifies the starting value for the first list item in an ordered list. This attribute is only applicable when the "type" attribute is set to "1", "A", "a", "I", or "i".
class H5Ol : HtmlElement {
  mixin(H5Template!("Ol", "ol", false));
  mixin(AttributeMethods!H5Ol);
}
///
unittest {
  assert(H5Ol() == `<ol></ol>`);
  assert(H5Ol(["testclass"]) == `<ol class="testclass"></ol>`);
  assert(H5Ol(["a":"b"]) == `<ol a="b"></ol>`);
  assert(H5Ol(["testclass"], ["a":"b"]) == `<ol class="testclass" a="b"></ol>`);

  assert(H5Ol("Hello") == `<ol>Hello</ol>`);
  assert(H5Ol(["testclass"], "Hello") == `<ol class="testclass">Hello</ol>`);
  assert(H5Ol(["a":"b"], "Hello") == `<ol a="b">Hello</ol>`);

  assert(H5Ol(["testclass"], ["a":"b"], "Hello") == `<ol class="testclass" a="b">Hello</ol>`);

  assert(H5Ol().type("A").start("3") == `<ol start="3" type="A"></ol>`);
}
