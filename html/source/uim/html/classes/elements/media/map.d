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
  * The <map> element is used to define an image map, which is a graphical representation of a web page that allows users to interact with different areas of the image. 
  * An image map consists of one or more <area> elements, which define the clickable areas on the image and specify the actions that should be taken when those areas are clicked. 
  * The <map> element is typically used in conjunction with the <img> element, where the <img> element references the image and the <map> element defines the interactive areas on that image.
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
