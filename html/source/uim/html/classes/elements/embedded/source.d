/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.source;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <source> HTML element is used to specify multiple media resources for media elements like <audio> and <video>. 
  * It allows you to provide different formats of the same media content, enabling the browser to choose the most suitable one based on its capabilities. 
  * The <source> element is typically nested inside a <audio> or <video> element and includes attributes such as src (the URL of the media resource) and type (the MIME type of the media).
  *
  * Example usage:
  * <video controls>
  *   <source src="movie.mp4" type="video/mp4">
  *   <source src="movie.ogg" type="video/ogg">
  *   Your browser does not support the video tag.
  * </video>
  */
class H5Source : HtmlElement {
  mixin H5This!("source", false);

  mixin(H5Calls!("source"));
}
///
unittest {
  assert(H5Source() == "<source></source>");
  assert(H5Source("Hello") == "<source>Hello</source>");
}
