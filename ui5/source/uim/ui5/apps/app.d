/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.apps.app;

import uim.ui5;

mixin(ShowModule!());

@safe:

class Ui5App {
    this() {
        this.initialize();
    }

    this(string name, Json config = Json(null)) {
        this.initialize(config.set("name", name)); 
    }

    bool initialize(Json config = Json(null)) {
        return true;
    }

    protected Ui5Controller[string] _controllers;
    Ui5Controller[string] controllers() {
        return this._controllers;
    }

    Ui5App controllers(Ui5Controller[string] controllers) {
        this._controllers = controllers;
        return this;
    }

    Ui5App register(string name, Ui5Controller controller) {
        _controllers[name] = controller;
        return this;
    }

    Ui5App unregisterController(string name) {
        _controllers.remove(name);
        return this;
    }

    protected Ui5View[string] _views;
    Ui5View[string] views() {
        return this._views;
    }

    Ui5App views(Ui5View[string] views) {
        this._views = views;
        return this;
    }

    Ui5App register(string name, Ui5View view) {
        _views[name] = view;
        return this;
    }

    Ui5App unregisterView(string name) {
        _views.remove(name);
        return this;
    }

}
///
unittest {
    Ui5App app = new Ui5App();
    assert(app.controllers().length == 0);
    assert(app.views().length == 0);

    app.register("main", new Ui5Controller());
    assert(app.controllers().length == 1);

    app.register("mainView", new Ui5View());
    assert(app.views().length == 1);

    app.unregisterController("main");
    assert(app.controllers().length == 0);

    app.unregisterView("mainView");
    assert(app.views().length == 0);
}