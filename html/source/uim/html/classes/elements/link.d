/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.link;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<link>` element, which is used to define a relationship between the current document and an external resource. The `<link>` element is commonly used to link to external stylesheets, but it can also be used for other purposes, such as linking to icons or preloading resources.
  * 
  * The `<link>` element is typically placed in the `<head>` section of an HTML document and can have various attributes, such as `rel`, `href`, and `type`, to specify the relationship and the location of the linked resource.
  * 
  * Browser support: All major browsers support the `<link>` element.
  *
  * Examples:
  * ```html
  * <link rel="stylesheet" href="styles.css">
  * <link rel="icon" href="favicon.ico" type="image/x-icon">
  * ```
  */
class H5Link : HtmlElement {
  mixin H5This!("link", true);

  H5Link rel(string relValue) {
    attribute("rel", relValue);
    return this;
  }

  IHtmlElement rel() {
    return attribute("rel");
  }

  H5Link href(string url) {
    attribute("href", url);
    return this;
  }

  IHtmlAttribute href() {
    return attribute("href");
  }

  H5Link type(string typeValue) {
    attribute("type", typeValue);
    return this;
  }

  IHtmlAttribute type() {
    return attribute("type");
  }

  mixin(H5Calls!("link"));
}
///
unittest {
  assert(H5Link() == "<link />");
}
