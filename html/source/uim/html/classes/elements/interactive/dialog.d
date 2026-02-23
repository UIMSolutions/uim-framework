/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.interactive.dialog;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <dialog> HTML element represents a dialog box or other interactive component, such as a dismissible alert, inspector, or subwindow.
  * The <dialog> element makes it easy to create pop-up dialogs in a web page. It can be used to create modals, pop-ups, lightboxes, and more.
  * The <dialog> element is not displayed by default. You can use the open attribute to show the dialog.
  * The <dialog> element also has a method called showModal() that can be used to display the dialog as a modal.
  */
@StringAttribute("closedby") // Specifies the conditions under which the dialog is to be closed. The value must be one of the following: "escape", "outside", "none"
@BoolAttribute("open") // Indicates whether the dialog is open. If this attribute is not set, the dialog is closed. If this attribute is set, the dialog is open.
class H5Dialog : HtmlElement {
  mixin(H5This!("dialog", false));

  mixin(AttributeMethods!H5Dialog);

  mixin(H5Calls!("Dialog"));
}
///
unittest {
  assert(H5Dialog() == "<dialog></dialog>");
  assert(H5Dialog("Hello") == "<dialog>Hello</dialog>");
  assert(H5Dialog().closedby("escape") == `<dialog closedby="escape"></dialog>`);
  assert(H5Dialog().closedby("outside") == `<dialog closedby="outside"></dialog>`);
  assert(H5Dialog().closedby("none") == `<dialog closedby="none"></dialog>`);
  assert(H5Dialog().open() == `<dialog open></dialog>`);
}
