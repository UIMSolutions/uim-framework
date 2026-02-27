/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.embed;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <embed> HTML element is used to embed external content, such as multimedia, interactive applications, or other resources, into a web page. 
 * It is a self-closing tag and can be used to include various types of content, such as videos, audio files, Flash animations, PDF documents, and more. 
 * The <embed> element typically requires the "src" attribute to specify the URL of the content being embedded, and it may also include attributes like "type" to specify the MIME type of the content and "width" and "height" to define the dimensions of the embedded content. 
 * When rendered in a web browser, the <embed> element displays the embedded content directly within the page.
 *
 * Example usage:
 * ```html
 * <embed src="video.mp4" type="video/mp4" width="640" height="360">
 * ```
 * This would embed a video file named "video.mp4" with a specified width of 640 pixels and height of 360 pixels.
 */
@StringAttribute("src")
@StringAttribute("type")
@StringAttribute("width")
@StringAttribute("height")
@StringAttribute("title")
class H5Embed : HtmlElement {
  mixin(H5This!("embed", false));

  mixin(AttributeMethods!H5Embed);

  mixin(H5Calls!("embed"));
}
///
unittest {
  assert(H5Embed() == "<embed></embed>");
  // assert(H5Embed("https://www.example.com/video.mp4") == "<embed src=\"https://www.example.com/video.mp4\"></embed>");
  // assert(H5Embed().src() == "https://www.example.com/audio.mp3");
  // assert(H5Embed().type() == "audio/mpeg");
  // assert(H5Embed().width() == "300");
  // assert(H5Embed().height() == "32");
  // assert(H5Embed().title() == "Audio Player");
  // assert(H5Embed().src("https://www.example.com/audio.mp3").type("audio/mpeg").width("300").height("32").title("Audio Player") == "<embed src=\"https://www.example.com/audio.mp3\" type=\"audio/mpeg\" width=\"300\" height=\"32\" title=\"Audio Player\"></embed>");
}
