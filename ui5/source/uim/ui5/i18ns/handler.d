module uim.ui5.i18ns.handler;

import uim.ui5;

@safe:
class I18nHandler {
    this() {
        this.initialize();
    }

    this(string name, Json config = Json(null)) {
        this.initialize(config.set("name", name));
    }

    bool initialize(Json config = Json(null)) {
        _language = config.getString("language", "en");
        _path = config.getString("path", "");

        return true;
    }

    // #region Properties
    // #region language
    protected string _language;
    string language() {
        return _language;
    }

    auto language(string value) {
        _language = value;
        return this;
    }
    // #endregion language

    // #region path
    protected string _path;
    string path() {
        return _path;
    }

    auto path(string value) {
        _path = value;
        return this;
    }
    // #endregion path
    // #endregion Properties

    // #region handle
    void handle(scope HTTPServerRequest req, scope HTTPServerResponse res) {
        res.writeBody("I18nHandler response");
    }
    // #endregion handle
}
