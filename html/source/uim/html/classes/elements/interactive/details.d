/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.details;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <details> HTML element is used to create a disclosure widget that can be toggled open or closed by the user. 
  * It is typically used to hide additional information or content that is not immediately necessary for the user to see, allowing for a cleaner and more organized presentation of information on a webpage. 
  * The <details> element can contain any type of content, including text, images, and other HTML elements. 
  * When the <details> element is closed, only the summary content (if provided) is visible, and when it is opened, the full content is displayed. 
  * The <details> element can be styled using CSS to customize its appearance and behavior.
  *
  * Example usage:
  * <details>
  *   <summary>More information</summary>
  *   <p>This is additional information that can be toggled open or closed.</p>
  * </details>
  */
class H5Details : HtmlElement {
  mixin(HtmlTemplate!(H5Details, "Details", "details", false));
}
///
unittest {
  assert(H5Details() == "<details></details>");

  assert(H5Details("Some content") == "<details>Some content</details>");
  assert(H5Details(["testClass"]) == `<details class="testClass"></details>`);
  assert(H5Details(["a":"b"]) == `<details a="b"></details>`);

  assert(H5Details(["testClass"], "Some content") == `<details class="testClass">Some content</details>`);
  assert(H5Details(["a":"b"], "Some content") == `<details a="b">Some content</details>`);

  assert(H5Details(["testClass"], ["a":"b"], "Some content") == `<details class="testClass" a="b">Some content</details>`);
}
