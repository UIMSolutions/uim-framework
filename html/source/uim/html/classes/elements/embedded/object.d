/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.object;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <object> HTML element is used to embed external content, such as multimedia, interactive applications, or other resources, into a web page. 
 * It is a versatile element that can be used to include various types of content, such as videos, audio files, Flash animations, PDF documents, and more. 
 * The <object> element typically requires the "data" attribute to specify the URL of the content being embedded, and it may also include attributes like "type" to specify the MIME type of the content and "width" and "height" to define the dimensions of the embedded content. 
 * When rendered in a web browser, the <object> element displays the embedded content directly within the page.
 *
 * Example usage:
 * ```html
 * <object data="video.mp4" type="video/mp4" width="640" height="360"></object>
 * ```
 * This would embed a video file named "video.mp4" with a specified width of 640 pixels and height of 360 pixels.
 */
 @StringAttribute("data")
 @StringAttribute("type")
 @StringAttribute("width")
 @StringAttribute("height")
 @StringAttribute("name")
 @StringAttribute("form")
class H5Object : HtmlElement {
  mixin(H5This!("object", false));


  mixin(H5Calls!("object"));
}
///
unittest {
  assert(H5Object() == "<object></object>");
  assert(H5Object("Hello") == "<object>Hello</object>");
}
