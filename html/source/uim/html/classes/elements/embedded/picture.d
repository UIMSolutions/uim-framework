/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.embedded.picture;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <picture> HTML element is used to provide multiple sources for an image, allowing the browser to choose the most appropriate one based on factors such as screen size, resolution, and format support. 
 * It is typically used in conjunction with the <source> element, which specifies different image sources and their associated media conditions. 
 * The <picture> element allows for responsive images, enabling developers to serve different images for different devices and screen sizes, improving performance and user experience. 
 * When rendered in a web browser, the <picture> element displays the selected image based on the specified sources and media conditions.
 *
 * Example usage:
 * ```html
 * <picture>
 *   <source srcset="image-large.jpg" media="(min-width: 800px)">
 *   <source srcset="image-medium.jpg" media="(min-width: 400px)">
 *   <img src="image-small.jpg" alt="Example Image">
 * </picture>
 * ```
 * In this example, the browser will display "image-large.jpg" if the viewport width is at least 800 pixels, "image-medium.jpg" if the viewport width is at least 400 pixels but less than 800 pixels, and "image-small.jpg" if the viewport width is less than 400 pixels.
 */
class H5Picture : HtmlElement {
  mixin H5This!("picture", false);


  H5Picture addSource(string srcset, string media) {
    auto source = new H5Source();
    source.srcset(srcset).media(media);
    addSource(source);
    return this;
  }

  H5Picture addSource(H5Source source) {
    this.add(source);
    return this;
  }

  H5Picture addImage(string src, string alt) {
    auto img = new H5Img();
    img.src(src).alt(alt);
    addImage(img);
    return this;
  }

  H5Picture addImage(H5Img img) {
    this.add(img);
    return this;
  }

  mixin(H5Calls!("picture"));
}
///
unittest {
  assert(H5Picture() == "<picture></picture>");
  assert(H5Picture("Hello") == "<picture>Hello</picture>");
}
