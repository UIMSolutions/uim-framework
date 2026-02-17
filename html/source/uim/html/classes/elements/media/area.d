/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.area;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<area>` element, which defines an area inside an image map that has predefined clickable areas.
  * 
  * The `<area>` element is used within a `<map>` element to define specific areas of an image that can be clicked on. Each `<area>` element specifies the shape and coordinates of the clickable area, as well as the link or action associated with it.
  * 
  * Browser support: All major browsers support the `<area>` element.
  *
  * Examples:
  * ```html
  * <img src="image.jpg" usemap="#image-map">
  * <map name="image-map">
  *   <area shape="rect" coords="34,44,270,350" href="link1.html" alt="Link 1">
  *   <area shape="circle" coords="337,300,44" href="link2.html" alt="Link 2">
  * </map>
  * ```
  */
class H5Area : HtmlElement {
  mixin H5This!("area", false);

  mixin(H5Calls!("Area"));
}
///
unittest {
  mixin(ShowTest!"Testing H5Area");

  assert(H5Area() == "<area></area>");
  assert(H5Area("Hello") == "<area>Hello</area>");
  assert(H5Area(["test"], "Hello") == `<area class="test">Hello</area>`);
  assert(H5Area(["a":"b"], "Hello") == `<area a="b">Hello</area>`);
  assert(H5Area(["test"], ["a":"b"], "Hello") == `<area class="test" a="b">Hello</area>`);
}
