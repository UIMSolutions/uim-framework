module uim.entities.classes.attributes.helpers.factory;

import uim.entities;

mixin(ShowModule!());

@safe:

class AttributeFactory : UIMFactory!(string, IAttribute) {
    this() {
        super();
    }
}