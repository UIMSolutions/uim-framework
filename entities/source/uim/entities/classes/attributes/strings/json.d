/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.json;

/* A JSON fragment contained within one string value

Inheritance
any <- char <- string <- json
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.content.text.JSON
 */
 
import uim.entities;

@safe:
class DJsonAttribute : DStringAttribute {
  mixin(AttributeThis!("JsonAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("json")
    this.registerPath("json");
  }
}
mixin(AttributeCalls!("JsonAttribute"));

///
unittest {
  auto attribute = new DJsonAttribute;
  assert(attribute.name == "json");
  assert(attribute.registerPath == "json");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}