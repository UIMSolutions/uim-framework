/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.track;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <track> HTML element is used as a child of the media elements <audio> and <video>. It lets you specify timed text tracks (or time-based data), for example to automatically handle subtitles.
  * The <track> element does not have any visual representation, but it provides text tracks that can be displayed by the media element's built-in controls or by JavaScript.
  * The <track> element supports several attributes, including src, kind, srclang, label, and default, which allow you to specify the source of the track, its type, language, and other properties.
  *
  * The <track> element is typically used to provide subtitles, captions, or other types of timed text for audio and video content, making it more accessible to a wider audience.
  * It can also be used to provide additional metadata or other time-based data that can be synchronized with the media content.
  * The <track> element is supported in all modern browsers and is an important part of creating accessible multimedia content on the web.
  * When using the <track> element, it's important to ensure that the text tracks are properly synchronized with the media content and that they are accurate and well-written to provide a good user experience for all viewers.
  * 
  * Example usage:
  *
  * <video controls>
  *   <source src="movie.mp4" type="video/mp4">
  *   <track src="subtitles_en.vtt" kind="subtitles" srclang="en" label="English">
  *   <track src="subtitles_es.vtt" kind="subtitles" srclang="es" label="Spanish">
  * </video>
  *
  * The <track> element is a powerful tool for enhancing the accessibility and usability of multimedia content on the web, and it is an essential part of creating inclusive and engaging user experiences.
  */
class Track : HtmlElement {
  this() {
    super("track");
    this.selfClosing(false);
  }

  static Track opCall() {
    return new Track();
  }

  static Track opCall(string content) {
    auto element = new Track();
    element.text(content);
    return element;
  }
}
///
unittest {
  assert(Track() == "<track></track>");
  assert(Track("Hello") == "<track>Hello</track>");
}
