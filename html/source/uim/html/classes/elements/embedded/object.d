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
class H5Object : HtmlElement {
  mixin H5This!("object", false);

  /**
    * Sets the URL of the content being embedded in the <object> element. This attribute is required for the <object> element to function properly, as it specifies the source of the content to be displayed.
    *
    * Example usage:
    * ```html
    * <object data="audio.mp3" type="audio/mpeg"></object>
    * ```
    * This would embed an audio file named "audio.mp3" with a specified MIME type of "audio/mpeg".
    */
  H5Object data(string url) {
    attribute("data", url);
    return this;
  }

  /**
    * Gets the value of the "data" attribute, which specifies the URL of the content being embedded in the <object> element.
    *
    * Example usage:
    * ```html
    * <object data="document.pdf" type="application/pdf"></object>
    * ```
    * This would embed a PDF document named "document.pdf" with a specified MIME type of "application/pdf".
    */
  IHtmlAttribute data() {
    return attribute("data");
  }

  // #region type attribute
  /** 
    * Sets the MIME type of the content being embedded in the <object> element. This attribute is used to specify the type of content being embedded, such as "video/mp4" for a video file or "application/pdf" for a PDF document.
    *
    * Example usage:
    * ```html
    * <object data="presentation.pptx" type="application/vnd.openxmlformats-officedocument.presentationml.presentation"></object>
    * ```
    * This would embed a PowerPoint presentation file named "presentation.pptx" with a specified MIME type of "application/vnd.openxmlformats-officedocument.presentationml.presentation".
    */
  H5Object type(string mimeType) {
    attribute("type", mimeType);
    return this;
  }

  /** 
    * Gets the value of the "type" attribute, which specifies the MIME type of the content being embedded in the <object> element.
    *
    * Example usage:
    * ```html
    * <object data="presentation.pptx" type="application/vnd.openxmlformats-officedocument.presentationml.presentation"></object>
    * ```
    * This would embed a PowerPoint presentation file named "presentation.pptx" with a specified MIME type of "application/vnd.openxmlformats-officedocument.presentationml.presentation", and calling the type() method would return "application/vnd.openxmlformats-officedocument.presentationml.presentation".
    */
  IHtmlAttribute type() {
    return attribute("type");
  }
  // #endregion type attribute

  
  H5Object width(string width) {
    attribute("width", width);
    return this;
  }

  IHtmlAttribute width() {
    return attribute("width");
  }

  H5Object height(string height) {
    attribute("height", height);
    return this;
  }

  IHtmlAttribute height() {
    return attribute("height");
  }

  H5Object name(string name) {
    attribute("name", name);
    return this;
  }

  IHtmlAttribute name() {
    return attribute("name");
  }

  H5Object form(string formId) {
    attribute("form", formId);
    return this;
  }

  IHtmlAttribute form() {
    return attribute("form");
  }

  mixin(H5Calls!("object"));
}
///
unittest {
  assert(H5Object() == "<object></object>");
  assert(H5Object("Hello") == "<object>Hello</object>");
}
