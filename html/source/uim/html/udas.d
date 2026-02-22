/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.udas;

@safe:

/// Associates a symbol with an HTML tag name.
struct HtmlTag {
  string name;

  this(string tagName) {
    name = tagName;
  }
}

/// Marks a symbol as representing a void/self-closing HTML element.
struct VoidElement {
}

/// Associates a symbol with an HTML category (e.g. "flow", "phrasing").
struct HtmlCategory {
  string name;

  this(string categoryName) {
    name = categoryName;
  }
}

/// Declares that a symbol supports a specific attribute.
struct SupportsAttribute {
  string name;

  this(string attributeName) {
    name = attributeName;
  }
}

/// Declares deprecation metadata for an HTML symbol.
struct DeprecatedHtml {
  string reason;

  this(string deprecationReason) {
    reason = deprecationReason;
  }
}

/// Checks whether a symbol has an `HtmlTag` UDA.
template hasHtmlTagAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasHtmlTagAttribute = hasUDA!(symbol, HtmlTag);
}

/// Gets `HtmlTag` metadata for a symbol.
template getHtmlTagAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasHtmlTagAttribute!symbol) {
    alias getHtmlTagAttribute = getUDAs!(symbol, HtmlTag)[0];
  }
}

/// Checks whether a symbol has a `VoidElement` UDA.
template hasVoidElementAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasVoidElementAttribute = hasUDA!(symbol, VoidElement);
}

/// Checks whether a symbol has an `HtmlCategory` UDA.
template hasHtmlCategoryAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasHtmlCategoryAttribute = hasUDA!(symbol, HtmlCategory);
}

/// Gets `HtmlCategory` metadata for a symbol.
template getHtmlCategoryAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasHtmlCategoryAttribute!symbol) {
    alias getHtmlCategoryAttribute = getUDAs!(symbol, HtmlCategory)[0];
  }
}

/// Checks whether a symbol has a `SupportsAttribute` UDA.
template hasSupportsAttributeAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasSupportsAttributeAttribute = hasUDA!(symbol, SupportsAttribute);
}

/// Gets the first `SupportsAttribute` metadata entry for a symbol.
template getSupportsAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasSupportsAttributeAttribute!symbol) {
    alias getSupportsAttribute = getUDAs!(symbol, SupportsAttribute)[0];
  }
}

/// Gets all `SupportsAttribute` metadata entries for a symbol.
template getSupportsAttributes(alias symbol) {
  import std.traits : getUDAs;

  alias getSupportsAttributes = getUDAs!(symbol, SupportsAttribute);
}

/// Checks whether a symbol has a `DeprecatedHtml` UDA.
template hasDeprecatedHtmlAttribute(alias symbol) {
  import std.traits : hasUDA;

  enum hasDeprecatedHtmlAttribute = hasUDA!(symbol, DeprecatedHtml);
}

/// Gets `DeprecatedHtml` metadata for a symbol.
template getDeprecatedHtmlAttribute(alias symbol) {
  import std.traits : getUDAs;

  static if (hasDeprecatedHtmlAttribute!symbol) {
    alias getDeprecatedHtmlAttribute = getUDAs!(symbol, DeprecatedHtml)[0];
  }
}

unittest {
  @HtmlTag("img")
  @VoidElement
  @HtmlCategory("embedded")
  @SupportsAttribute("src")
  @SupportsAttribute("alt")
  struct ImageElement {
  }

  @HtmlTag("center")
  @DeprecatedHtml("Use CSS text-align instead")
  struct CenterElement {
  }

  assert(hasHtmlTagAttribute!ImageElement);
  assert(getHtmlTagAttribute!ImageElement.name == "img");

  assert(hasVoidElementAttribute!ImageElement);

  assert(hasHtmlCategoryAttribute!ImageElement);
  assert(getHtmlCategoryAttribute!ImageElement.name == "embedded");

  assert(hasSupportsAttributeAttribute!ImageElement);
  assert(getSupportsAttribute!ImageElement.name == "src");
  assert(getSupportsAttributes!ImageElement.length == 2);
  assert(getSupportsAttributes!ImageElement[1].name == "alt");

  assert(hasDeprecatedHtmlAttribute!CenterElement);
  assert(getDeprecatedHtmlAttribute!CenterElement.reason == "Use CSS text-align instead");
  assert(!hasDeprecatedHtmlAttribute!ImageElement);
}
