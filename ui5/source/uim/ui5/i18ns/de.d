module uim.ui5.i18n.de;

import uim.ui5;

@safe:
void DeI18nHandler(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    res.writeBody("DeI18nHandler response");
}