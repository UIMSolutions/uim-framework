/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.interfaces.form;

import uim.html;

mixin(ShowModule!());

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