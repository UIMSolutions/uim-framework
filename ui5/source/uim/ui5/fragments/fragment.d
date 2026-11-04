module uim.ui5.fragments.fragment;

import uim.ui5;

mixin(ShowModule!());

@safe:

class Ui5Fragment {
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