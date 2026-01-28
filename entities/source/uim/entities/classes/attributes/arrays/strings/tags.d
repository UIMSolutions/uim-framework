/***********************************************************************************************
*	Copyright: © 2017-2022 UI Manufaktur UG / 2022 Ozan Nuretin Süel (Sicherheitsschmiede)
*	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*	Authors: UI Manufaktur Team
************************************************************************************************/
module uim.entities.classes.attributes.arrays.strings.tags;

import uim.entities;

@safe:
class DTagsAttribute : DStringArrayAttribute {
  mixin(AttributeThis!("TagsAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("TagsAttribute");
    this.dataFormats(["string", "array"]);
    this.registerPath("TagsAttribute");
  }

  override UIMValue createValue() {
    return TagArrayValue(this); }
}
mixin(AttributeCalls!"TagsAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DTagsAttribute);
  testAttribute(TagsAttribute);
}}