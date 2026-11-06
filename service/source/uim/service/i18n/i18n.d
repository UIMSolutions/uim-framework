module uim.service.i18n.controller;

import uim.service;

@safe:
void I18nHandler(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    res.writeBody("I18nHandler response");
}