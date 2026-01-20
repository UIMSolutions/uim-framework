/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.forms.interfaces;

import uim.htmls;

@safe:

/// Interface for form elements with name attribute
interface IHtmlForm : IHtmlElement {
  /// Get or set the name attribute
  IHtmlAttribute name();
  IHtmlForm name(string nameValue);

  IHtmlForm action(string url);

  IHtmlForm method(string methodValue);

  IHtmlForm post();

  IHtmlForm get();

  IHtmlForm enctype(string value);
}

unittest {
  class TestFormElement : DHtmlElement, IHtmlForm {
    this() {
      super("input");
    }

    IHtmlAttribute name() {
      return attribute("name");
    }

    override IHtmlForm name(string nameValue) {
      attribute("name", nameValue);
      return this;
    }
  }

  auto element = new TestFormElement();
  element.name("testName");
  assert(element.name() == "testName");
}

interface IInput : IHtmlFormElement {
    IHtmlAttribute type();
    IInput type(string typeValue);
}

interface IHtmlFormElement : IHtmlElement {
    IHtmlAttribute form();
    IHtmlFormElement form(string formId);
}