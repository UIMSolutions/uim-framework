/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.summary;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <summary> HTML element is used as a summary, caption, or legend for the content of a <details> element. 
  * It is typically used to provide a brief description or title for the content that is hidden within the <details> element. 
  * When the <details> element is closed, only the content of the <summary> element is visible, and when it is opened, the full content of the <details> element is displayed. 
  * The <summary> element can be styled using CSS to customize its appearance and behavior.
  *
  * Example usage:
  * <details>
  *   <summary>More information</summary>
  *   <p>This is additional information that can be toggled open or closed.</p>
  * </details>
  */
class H5Summary : HtmlElement {
  mixin(H5This!("summary", false));

  mixin(AttributeMethods!H5Summary);

  mixin(H5Calls!("Summary"));
}
///
unittest {
  assert(H5Summary() == "<summary></summary>");

  assert(H5Summary("Some content") == "<summary>Some content</summary>");
  assert(H5Summary(["testClass"]) == `<summary class="testClass"></summary>`);
  assert(H5Summary(["a": "b"]) == `<summary a="b"></summary>`);

  assert(H5Summary(["testClass"], "Some content") == `<summary class="testClass">Some content</summary>`);
  assert(H5Summary(["a": "b"], "Some content") == `<summary a="b">Some content</summary>`);

  assert(H5Summary(["testClass"], ["a": "b"], "Some content") == `<summary class="testClass" a="b">Some content</summary>`);
}
