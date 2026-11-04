module uim.ui5.i18ns.i18n;

import uim.ui5;

mixin(ShowModule!());

@safe:

class Ui5I18n {
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