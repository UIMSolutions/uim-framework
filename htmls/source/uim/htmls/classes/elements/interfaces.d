/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.interfaces;

import uim.htmls;

@safe:

interface IHtmlElement {
  // Getter / Setter for content
  string content();
  IHtmlElement content(string value);

  // Getter / Setter for tagName
  string tagName();
  IHtmlElement tagName(string value);

  // Getter / Setter for selfClosing
  bool selfClosing();
  IHtmlElement selfClosing(bool value);

  // Add an attribute to the element
  IHtmlElement attribute(string name, string value);

  /// Get an attribute by name
  IHtmlAttribute attribute(string name);

  // Getter / Setter for ID
  IHtmlElement id(string value);
  string id();
  // #endregion ID

  /// Add CSS class
  IHtmlElement addClass(string className);

  /// Set style attribute
  IHtmlElement style(string styleValue);

  /// Add a child element
  IHtmlElement addChild(DHtmlElement child);
  /// Add multiple children
  IHtmlElement addChildren(DHtmlElement[] children...);
  /// Get children array
  IHtmlElement[] children();
  /// Remove all children
  IHtmlElement clearChildren();

  /// Set text content
  IHtmlElement text(string textContent);

  /// Convert element to HTML string
  string toString();
}
