/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.selectedcontent;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <selectedcontent> element.
  * The <selectedcontent> element is used to define the content that is displayed when an option is selected in a <select> element.
  * It can contain any HTML content, such as text, images, or other elements.
  * Example usage:
  * auto selectedContent = H5SelectedContent("Selected option details");
  * selectedContent can be dynamically updated based on user selection in a <select> element.
  *
  * Note: The <selectedcontent> element is typically used in conjunction with JavaScript to dynamically update the displayed content based on user selection.
  */

class H5SelectedContent : HtmlElement {
  mixin H5This!("selectedcontent", false);

   /// Sets the content of the selectedcontent element.

  mixin(H5Calls!("SelectedContent"));
}
///
unittest {
  assert(H5SelectedContent() == "<selectedcontent></selectedcontent>");
  assert(H5SelectedContent("Some content") == "<selectedcontent>Some content</selectedcontent>");
  
}
