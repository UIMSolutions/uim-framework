/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.map;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * Represents the HTML `<map>` element, which is used to define an image map. An image map is a graphical element that allows you to define clickable areas on an image, which can link to different destinations or trigger specific actions when clicked.
  * 
  * The `<map>` element is typically used in conjunction with the `<area>` element, which defines the individual clickable areas within the image map. Each `<area>` element specifies the shape and coordinates of the clickable area, as well as the destination URL or action associated with it.
  * 
  * Browser support: All major browsers support the `<map>` element.
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
class H5Map : HtmlElement {
  mixin H5This!("map", false);

  mixin(H5Calls!("Map"));
}
///
unittest {
  mixin(ShowTest!"Testing H5Map");

  assert(H5Map() == "<map></map>");
  assert(H5Map("Hello") == "<map>Hello</map>");
  assert(H5Map(["test"], "Hello") == `<map class="test">Hello</map>`);
  assert(H5Map(["a":"b"], "Hello") == `<map a="b">Hello</map>`);
  assert(H5Map(["test"], ["a":"b"], "Hello") == `<map class="test" a="b">Hello</map>`);
}
