/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.head;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <head> HTML element contains metadata about the document, including the document's title, links to stylesheets, scripts, and other meta-information. 
  * It is placed between the <html> tag and the <body> tag in an HTML document. 
  * The content of the <head> element is not displayed on the page but is used by browsers and search engines to understand the structure and content of the document.
  */
class H5Head : HtmlElement {
  mixin(H5This!("head", false));

  mixin(AttributeMethods!H5Head);

  mixin(H5Calls!("Head"));
}
///
unittest {
  assert(H5Head() == `<head></head>`);
  assert(H5Head("Hello") == `<head>Hello</head>`);
}
