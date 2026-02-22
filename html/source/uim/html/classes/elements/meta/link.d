/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.link;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents an HTML <link> element.
  * Provides methods to set the attributes of the link element.
  * Example usage:
  * auto link = Link().href("https://example.com").rel("stylesheet");
  */
@H5Attribute("as")
@H5Attribute("blocking")
@H5Attribute("crossorigin")
@H5Attribute("fetchpriority")
@H5Attribute("href")
@H5Attribute("hreflang")
@H5Attribute("imagesizes")
@H5Attribute("imagesrcset")
@H5Attribute("integrity")
@H5Attribute("media")
@H5Attribute("referrerpolicy")
@H5Attribute("rel")
@H5Attribute("sizes")
@H5Attribute("title")
@H5Attribute("type")
class H5Link : HtmlElement {
  mixin H5This!("link", true);

  H5Link disabled() {
    attribute("disabled", "");
    return this;
  }

  mixin(H5AttributeMethods!H5Link);

  // Create a new Base element
  mixin(H5Calls!("link"));
}
///
unittest {
  assert(H5Link() == "<link />");
  assert(H5Link().href("https://example.com") == "<link href=\"https://example.com\" />");
  assert(H5Link().rel("stylesheet") == "<link rel=\"stylesheet\" />");
  assert(H5Link().as("style") == "<link as=\"style\" />");
  assert(H5Link().crossorigin("anonymous") == "<link crossorigin=\"anonymous\" />");
  assert(H5Link().fetchpriority("high") == "<link fetchpriority=\"high\" />");
  assert(H5Link().hreflang("en") == "<link hreflang=\"en\" />");
  assert(H5Link().imagesizes("(max-width: 600px) 100vw, 50vw") == "<link imagesizes=\"(max-width: 600px) 100vw, 50vw\" />");
  assert(H5Link().imagesrcset("image-small.jpg 500w, image-large.jpg 1000w") == "<link imagesrcset=\"image-small.jpg 500w, image-large.jpg 1000w\" />");
  assert(H5Link().integrity("sha384-abc123") == "<link integrity=\"sha384-abc123\" />");
  assert(H5Link().media("screen") == "<link media=\"screen\" />");
  assert(H5Link().referrerpolicy("no-referrer") == "<link referrerpolicy=\"no-referrer\" />");
  assert(H5Link().sizes("(max-width: 600px) 100vw, 50vw") == "<link sizes=\"(max-width: 600px) 100vw, 50vw\" />");
  assert(H5Link().title("Example Link") == "<link title=\"Example Link\" />");
  assert(H5Link().type("text/css") == "<link type=\"text/css\" />");
}
