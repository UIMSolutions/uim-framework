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
class H5Dialog : HtmlElement {
  mixin H5This!("dialog", false);

  /** Specifies the conditions under which the dialog is to be closed.
   * The value must be one of the following:
   * - "escape": The dialog can be closed by pressing the Escape key.
   * - "outside": The dialog can be closed by clicking outside the dialog.
   * - "none": The dialog cannot be closed by user interaction.
   */
  H5Dialog closedBy(string mode) {
    attribute("closedby", mode);
    return this;
  }

  H5Dialog closedBy(bool val = true) {
    if (val) {  
      attribute("closedby", "");
    } else {
      removeAttribute("closedby");
    }
    return this;
  }

  H5Dialog open(bool val = true) {
    if (val) {
      attribute("open", "");
    } else {
      removeAttribute("open");
    }
    return this;
  }

  mixin(H5Calls!("dialog"));
}
///
unittest {
  assert(H5Dialog() == "<dialog></dialog>");
  assert(H5Dialog("Hello") == "<dialog>Hello</dialog>");
  assert(H5Dialog().closedBy("escape") == `<dialog closedby="escape"></dialog>`);
  assert(H5Dialog().closedBy("outside") == `<dialog closedby="outside"></dialog>`);
  assert(H5Dialog().closedBy("none") == `<dialog closedby="none"></dialog>`);
  assert(H5Dialog().closedBy(true) == `<dialog closedby></dialog>`);
  assert(H5Dialog().open() == `<dialog open></dialog>`);
}
