/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.i18ns.router;

import uim.ui5;
import uim.ui5.i18ns.handler;

@safe:
class I18nRouter {
    this() {
        this.initialize();
    }

    this(string name, Json config = Json(null)) {
        this.initialize(config.set("name", name)); 
    }

    bool initialize(Json config = Json(null)) {
        return true;
    }

    protected I18nHandler[string] _handlers; 

    void register(string language, I18nHandler handler) {
        _handlers[handler.language()] = handler;
    }

    void registerRoutes(URLRouter router, string basePath = "/i18n") {
        _handlers.each!((language, handler) {
            router.get(basePath ~ "/i18n_" ~ language, &handler.handle);
        });
    }

    /// Adds POST basePath/upload for language files.
    /// This route changes server state and has no authentication of its own, so it is not part
    /// of registerRoutes: put an authentication handler in front of it on the URLRouter.
    void registerUploadRoute(URLRouter router, I18nUploadHandler handler, string basePath = "/i18n") {
        router.post(basePath ~ "/upload", &handler.handle);
    }
}
