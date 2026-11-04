module uim.ui5.components.component;

import uim.ui5;

mixin(ShowModule!());

@safe:

class Ui5Component {
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