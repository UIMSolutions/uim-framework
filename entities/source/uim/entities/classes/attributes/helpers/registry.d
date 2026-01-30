module uim.entities.classes.attributes.helpers.registry;

import uim.entities;

mixin(ShowModule!());

@safe:

class AttributeRegistry : UIMRegistry!(string, IAttribute) {
    this() {
        super();
    }
}