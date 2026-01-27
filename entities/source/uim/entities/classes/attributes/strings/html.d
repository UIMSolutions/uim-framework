/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.html;

/* A HTML fragment contained within one string value

Inheritance
any <- char <- string <- html
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.content.text.HTML
 */
 
import uim.entities;

@safe:
class DHtmlAttribute : DStringAttribute {
  mixin(AttributeThis!("HtmlAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("html")
      .registerPath("html");
  }
}
mixin(AttributeCalls!("HtmlAttribute"));

///
unittest {
  auto attribute = new DHtmlAttribute;
  assert(attribute.name == "html");
  assert(attribute.registerPath == "html");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}