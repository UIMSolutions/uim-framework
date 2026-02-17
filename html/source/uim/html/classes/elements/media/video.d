/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.video;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
  * The <video> element is used to embed video content in a web page. It provides a standard way to include video files and allows for various attributes and controls to customize the playback experience. 
  * The <video> element can contain one or more <source> elements, which specify the video file(s) to be played, along with their respective formats. 
  * Additionally, the <video> element supports attributes such as controls, autoplay, loop, muted, and more, which allow developers to control the behavior of the video player and enhance user interaction.
  *
  * Example usage:
  * <video controls>
  *   <source src="video.mp4" type="video/mp4">
  *   <source src="video.webm" type="video/webm">
  *   Your browser does not support the video tag.
  * </video>
  */
class H5Video : HtmlElement {
  mixin H5This!("video", false);

  mixin(H5Calls!("video"));
}
///
unittest {
  assert(H5Video() == "<video></video>");
  assert(H5Video("Hello") == "<video>Hello</video>");
  assert(H5Video(["test"], "Hello") == `<video class="test">Hello</video>`);
  assert(H5Video(["a": "b"], "Hello") == `<video a="b">Hello</video>`);
  assert(H5Video(["test"], ["a": "b"], "Hello") == `<video class="test" a="b">Hello</video>`);
}
