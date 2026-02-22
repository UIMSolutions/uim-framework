/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.udas;

@safe:

import std.string : format;

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

/// UDA to generate fluent setter/getter methods for HTML attributes on an element class.
///
/// Usage:
/// @H5Attribute("sizes")
/// class H5Link : HtmlElement {
///   mixin(H5AttributeMethods!H5Link);
/// }
struct H5Attribute {
  string methodName;
  string attributeName;

  this(string methodName, string attributeName = "") {
    this.methodName = methodName;
    this.attributeName = attributeName.length > 0 ? attributeName : methodName;
  }
}

private string generateH5AttributeMethod(H5Attribute attribute) {
  return format(q{
  @safe auto %1$s(string value) {
    attribute("%2$s", value);
    return this;
  }

  @safe string %1$s() {
    auto attr = attribute("%2$s");
    return attr is null ? null : attr.value;
  }
}, attribute.methodName, attribute.attributeName);
}

private string generateH5AttributeMethods(H5Attribute[] attributes) {
  string code;

  foreach (attribute; attributes) {
    code ~= generateH5AttributeMethod(attribute);
  }

  return code;
}

/// Generates all setter/getter methods from `@H5Attribute(...)` UDAs on a class.
template H5AttributeMethods(alias symbol) {
  import std.traits : getUDAs;

  enum string H5AttributeMethods = {
    string code;

    static foreach (attribute; getUDAs!(symbol, H5Attribute)) {
      code ~= generateH5AttributeMethod(attribute);
    }

    return code;
  }();
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

unittest {
  @H5Attribute("sizes")
  @H5Attribute("crossorigin")
  class GeneratedLinkLike {
    private string[string] _attributes;

    @safe GeneratedLinkLike attribute(string name, string value) {
      _attributes[name] = value;
      return this;
    }

    private class AttributeProxy {
      string value;

      this(string v) {
        value = v;
      }
    }

    @safe AttributeProxy attribute(string name) {
      if (auto ptr = name in _attributes) {
        return new AttributeProxy(*ptr);
      }

      return null;
    }

    mixin(H5AttributeMethods!GeneratedLinkLike);
  }

  auto item = new GeneratedLinkLike();
  item.sizes("64x64");
  item.crossorigin("anonymous");

  assert(item.sizes() == "64x64");
  assert(item.crossorigin() == "anonymous");
}
