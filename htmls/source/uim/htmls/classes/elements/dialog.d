/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.dialog;

import uim.htmls;

@safe:

class DDialog : DHtmlElement {
  this() {
    super("dialog");
    this.selfClosing(false);
  }

  /** Specifies the conditions under which the dialog is to be closed.
   * The value must be one of the following:
   * - "escape": The dialog can be closed by pressing the Escape key.
   * - "outside": The dialog can be closed by clicking outside the dialog.
   * - "none": The dialog cannot be closed by user interaction.
   */
  IHtmlElement closedBy(string mode) {
    attribute("closedby", mode);
    return this;
  }

  IHtmlAttribute closedBy() {
    return attribute("closedby");
  }

  IHtmlElement open() {
    attribute("open", "");
    return this;
  }
}

auto Dialog() {
  return new DDialog();
}

auto Dialog(string content) {
  auto element = new DDialog();
  element.text(content);
  return element;
}

unittest {
  auto dialog = Dialog();
  assert(dialog.toString() == "<dialog></dialog>");

  auto dialogWithContent = Dialog("Hello");
  assert(dialogWithContent.toString() == "<dialog>Hello</dialog>");
}
