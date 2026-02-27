/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.interfaces.element;

import uim.html;

mixin(ShowModule!());

@safe:

interface IHtmlElement {
  // Getter / Setter for tagName
  string tagName();
  IHtmlElement tagName(string value);

  // Getter / Setter for content
  string content();

  IHtmlElement content(string[] values...);
  IHtmlElement content(string[] values);
  IHtmlElement content(IHtmlElement[] elements...);
  IHtmlElement content(IHtmlElement[] elements);

  IHtmlElement addContent(string[] values...);
  IHtmlElement addContent(string[] values);
  IHtmlElement addContent(IHtmlElement[] elements...);
  IHtmlElement addContent(IHtmlElement[] elements);

  // Getter / Setter for selfClosing
  bool selfClosing();
  IHtmlElement selfClosing(bool value);

  // #region Attributes
  IHtmlElement attributes(string[string] map);

  bool hasAttribute(string name);

  IHtmlElement attribute(string name, string value);
  IHtmlAttribute attribute(string name);

  IHtmlElement removeAttribute(string name);
  // #endregion Attributes

  // Getter / Setter for ID
  IHtmlElement id(string value);
  string id();
  // #endregion ID

  string[] classes();
  IHtmlElement classes(string[] classNames);
  
  bool hasClass(string className);
  bool hasAllClass(string[] classNames);
  bool hasAnyClass(string[] classNames);

  IHtmlElement addClasses(string[] classNames);
  IHtmlElement addClass(string className);

  IHtmlElement removeClasses(string[] classNames);
  IHtmlElement removeClass(string className);
  
  /// Set style attribute
  IHtmlElement style(string styleValue);

  // /// Add a child element
  // IHtmlElement addChild(HtmlElement child);
  // /// Add multiple children
  // IHtmlElement addChildren(HtmlElement[] children...);
  // /// Get children array
  // IHtmlElement[] children();
  // /// Remove all children
  // IHtmlElement clearChildren();

  /// Set text content
  IHtmlElement text(string textContent);

  bool opEquals(const string html);

  /// Convert element to HTML string
  string toString();
}
