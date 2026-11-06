module uim.service.i18n.de;

import uim.service;

@safe:
void DeI18nHandler(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    res.writeBody("DeI18nHandler response");
}