/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.a;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * HTML anchor element
  * The anchor element is used to create hyperlinks, which allow users to navigate from one page to another or to a specific section within a page.
  * It can also be used to create links to external resources, such as email addresses or phone numbers.
  * Example usage:
  * auto link = H5A("Click here").href("https://example.com").targetBlank();
  * This creates a hyperlink with the text "Click here" that points to "https://example.com" and opens in a new tab.
*/
@StringAttribute("href") // The 'href' attribute specifies the URL of the page the link goes to.
@StringAttribute("target") // The 'target' attribute specifies where to open the linked document. 

class H5A : HtmlElement {
  mixin(H5This!("a", false));

mixin(HtmlMethods!H5A);

  // Setting target="_blank"
  H5A targetBlank() {
    return target("_blank");
  }

  mixin(H5Calls!("A"));
}
///
unittest {
  assert(H5A() == "<a></a>");
  assert(H5A("Click here") == "<a>Click here</a>");

  assert(H5A().href("https://example.com") == `<a href="https://example.com"></a>`);
  assert(H5A().href("https://example.com").href() == "https://example.com");
  
  assert(H5A().target("_self") == `<a target="_self"></a>`);
  assert(H5A().target("_self").target() == "_self");
  assert(H5A().targetBlank() == `<a target="_blank"></a>`);
  assert(H5A().targetBlank().target() == "_blank");

  assert(H5A().href("https://example.com").target("_self") == `<a href="https://example.com" target="_self"></a>`);
}
