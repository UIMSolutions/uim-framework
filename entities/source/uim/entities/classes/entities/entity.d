module uim.entities.classes.entities.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

class UIMEntity : UIMObject, IEntity {
    mixin(ObjThis!("UIMEntity"));

    // Hook
    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    override Json toJson() {
        Json json = super.toJson();
        json["entityType"] = "Entity";
        return json;
    }
}
