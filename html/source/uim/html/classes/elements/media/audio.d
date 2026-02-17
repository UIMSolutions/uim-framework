/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.media.audio;

import uim.html;

mixin(ShowModule!());

@safe:

/**   
  * Represents the HTML `<audio>` element, which is used to embed sound content in documents. It can contain one or more audio sources, represented using the `<source>` element, or it can contain a fallback content, such as a message or a link to download the audio file.
  * 
  * The `<audio>` element provides a standard way to include audio content in web pages. It supports various audio formats, such as MP3, WAV, and Ogg Vorbis, and it allows for control over playback through attributes and JavaScript.
  * 
  * Browser support: All major browsers support the `<audio>` element.
  *
  * Examples:
  * ```html
  * <audio controls>
  *   <source src="audio-file.mp3" type="audio/mpeg">
  *   <source src="audio-file.ogg" type="audio/ogg">
  *   Your browser does not support the audio element.
  * </audio>
  * ```
  */
class Audio : HtmlElement {
  mixin H5This!("audio", false);

  static Audio opCall() {
    return new Audio();
  }

  static Audio opCall(string content) {
    auto element = new Audio();
    element.content(content);
    return element;
  }
}
///
unittest {
  assert(Audio() == "<audio></audio>");
  assert(Audio("Hello") == "<audio>Hello</audio>");
}
