/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.forms.inputs.image;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The H5ImageInput class represents an HTML <input> element with the type "image". It is used to create input fields that accept image values, and can include attributes such as required and pattern to validate the input.
  * This class extends the H5Input class, inheriting its properties and methods, while setting the type attribute to "image" by default.
  * Example usage:
  * auto imageInput = H5ImageInput("image");
  * assert(imageInput == `<input type="image" name="image">`);
  * assert(imageInput.type() == "image");
  * assert(imageInput.name() == "image");
  */
class H5ImageInput : H5Input {
  mixin H5InputThis!("image");

  mixin(H5Calls!("ImageInput"));
}
///
unittest {
  auto imageInput = H5ImageInput("image");
  assert(imageInput == `<input type="image" name="image">`);
  assert(imageInput.type() == "image");
  assert(imageInput.name() == "image");  
}