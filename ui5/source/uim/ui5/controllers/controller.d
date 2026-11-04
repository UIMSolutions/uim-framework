module uim.ui5.controllers.controller;

import uim.ui5;

mixin(ShowModule!());

@safe:

class UI5Controller {
    this() {
        this.initialize();
    }

    this(string name, Json config = Json(null)) {
        this.initialize(config.set("name", name)); 
    }

    bool initialize(Json config = Json(null)) {
        return true;
    }
}