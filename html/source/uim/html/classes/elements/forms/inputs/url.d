/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.url;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5UrlInput class represents an HTML <input> element with the type "url". It is used to create input fields that accept URL values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "url" by default.
  * Example usage:
  * auto urlInput = H5UrlInput("url");
  * assert(urlInput == `<input type="url" name="url">`);
  * assert(urlInput.type() == "url");
  * assert(urlInput.name() == "url");
  */
class H5UrlInput : H5Input {
  mixin H5InputThis!("url");

  mixin(H5Calls!("UrlInput"));
}
///
unittest {
  auto urlInput = H5UrlInput("url");
  assert(urlInput == `<input type="url" />`);
  assert(urlInput.type() == "url");
}