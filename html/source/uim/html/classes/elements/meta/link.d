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
@StringAttribute("as")
@StringAttribute("blocking")
@StringAttribute("crossorigin")
@StringAttribute("fetchpriority")
@StringAttribute("href")
@StringAttribute("hreflang")
@StringAttribute("imagesizes")
@StringAttribute("imagesrcset")
@StringAttribute("integrity")
@StringAttribute("media")
@StringAttribute("referrerpolicy")
@StringAttribute("rel")
@StringAttribute("sizes")
@StringAttribute("title")
@StringAttribute("type")
class H5Link : HtmlElement {
  mixin(H5This!("link", true));

  H5Link disabled() {
    attribute("disabled", "");
    return this;
  }

  mixin(HtmlMethods!H5Link);

  // Create a new Base element
  mixin(H5Calls!("Link"));
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
