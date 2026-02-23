/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.address;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents the HTML `<address>` element, which provides contact information
  * for a person, organization, or owner associated with the nearest `<article>`
  * or `<body>` ancestor.
  *
  * The `<address>` element is intended for contact metadata such as postal
  * addresses, email links, phone numbers, or social profile links. It should not
  * be used for arbitrary physical locations that are unrelated to contact details.
  *
  * Typical usage includes author information in blog posts, organization contact
  * blocks in site footers, and owner metadata for content sections.
  *
  * NAFv4 Description:
  * The `<address>` element encapsulates canonical contact details for the
  * responsible party of the surrounding content scope and should be used only
  * for contact-oriented information, not generic location labeling.
  *
  * Example:
  * ```html
  * <address>
  *   123 Main St, Anytown, USA
  * </address>
  * ```
  *
  * Programmatic example:
  * ```d
  * auto contact = H5Address("123 Main St, Anytown, USA");
  * ```
  */
class H5Address : HtmlElement {
  mixin(H5Template!("Address", "address", false));
  mixin(AttributeMethods!H5Address);
}
///
unittest {
  assert(H5Address() == `<address></address>`);
  assert(H5Address(["testclass"]) == `<address class="testclass"></address>`);
  assert(H5Address(["a":"b"]) == `<address a="b"></address>`);
  assert(H5Address(["testclass"], ["a":"b"]) == `<address class="testclass" a="b"></address>`);
  
  assert(H5Address("Hello") == `<address>Hello</address>`);
  assert(H5Address(["testclass"], "Hello") == `<address class="testclass">Hello</address>`);
  assert(H5Address(["a":"b"], "Hello") == `<address a="b">Hello</address>`);

  assert(H5Address(["testclass"], ["a":"b"], "Hello") == `<address class="testclass" a="b">Hello</address>`);
}
