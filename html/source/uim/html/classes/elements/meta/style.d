/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.meta.style;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML <style> element, which is used to define CSS styles for a document.
  *
  * Example usage:
  * <head>
  *   <style>
  *     body { background-color: lightblue; }
  *     h1 { color: navy; }
  *   </style>
  * </head>
  *
  * Or with an external stylesheet:
  * <head>
  *   <style href="styles.css" target="_blank"></style>
  * </head>
  */
@StringAttribute("href")
@StringAttribute("target")
class H5Style : HtmlElement {
  mixin(H5This!("style", true));

  mixin(AttributeMethods!H5Style);

  mixin(H5Calls!("Style"));
}
///
unittest {
  assert(H5Style() == "<style />");
  assert(H5Style().href("styles.css") == "<style href=\"styles.css\" />");
  assert(H5Style().target("_blank") == "<style target=\"_blank\" />");
  assert(H5Style().target("_blank").target() == "_blank");

} 