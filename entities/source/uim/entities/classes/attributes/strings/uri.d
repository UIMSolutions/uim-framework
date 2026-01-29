module uim.entities.classes.attributes.strings.uri;

/* any <- char <- string <- uri
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.reference.URI */

import uim.entities;

mixin(ShowModule!());

@safe:
class UriAttribute : DStringAttribute {
  mixin(AttributeThis!("UriAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("uri");
    this.registerPath("uri");
  }
}
