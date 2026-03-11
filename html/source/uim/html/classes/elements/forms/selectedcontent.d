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
  * The <selectedcontent> HTML element is a custom element that can be used to represent content that is selected or highlighted in some way. 
  * It is not a standard HTML element and may require additional styling and scripting to achieve the desired functionality.
  * The <selectedcontent> element can be used in various contexts, such as within forms, lists, or any other part of a web page where selected content needs to be visually distinguished.
  *
  * Example usage:
  * <selectedcontent>This content is selected.</selectedcontent>
  */
class H5SelectedContent : HtmlElement {
  mixin(HtmlTemplate!(H5SelectedContent, "SelectedContent", "selectedcontent", false));
}
///
unittest {
  assert(H5SelectedContent() == "<selectedcontent></selectedcontent>");
  assert(H5SelectedContent(["testclass"]) == "<selectedcontent class=\"testclass\"></selectedcontent>");
  assert(H5SelectedContent(["a":"b"]) == "<selectedcontent a=\"b\"></selectedcontent>");
  assert(H5SelectedContent(["testclass"], ["a":"b"]) == "<selectedcontent class=\"testclass\" a=\"b\"></selectedcontent>");

  assert(H5SelectedContent("Some content") == "<selectedcontent>Some content</selectedcontent>");
  assert(H5SelectedContent(["testclass"], "Some content") == "<selectedcontent class=\"testclass\">Some content</selectedcontent>");
  assert(H5SelectedContent(["a":"b"], "Some content") == "<selectedcontent a=\"b\">Some content</selectedcontent>");
  assert(H5SelectedContent(["testclass"], ["a":"b"], "Some content") == "<selectedcontent class=\"testclass\" a=\"b\">Some content</selectedcontent>");
}
