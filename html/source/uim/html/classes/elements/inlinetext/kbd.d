/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.kbd;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <kbd> HTML element represents user input and is typically displayed in a monospace font. 
  * It is used to indicate text that the user is expected to enter or has entered, such as keyboard input, voice commands, or other forms of user interaction. 
  * The <kbd> element does not affect the meaning of the text it contains, but it indicates that the text should be displayed in a way that distinguishes it from regular content.
  *
  * Example usage:
  * <p>Press <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy.</p>
  */
class H5Kbd : HtmlElement {
  mixin H5This!("kbd", false);

  mixin(H5Calls!("kbd"));
}
///
unittest {
  assert(H5Kbd() == "<kbd></kbd>");
  assert(Kbd("Hello") == "<kbd>Hello</kbd>");
}
