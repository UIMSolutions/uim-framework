module uim.services.mixins.handler;

import uim.services;

mixin(ShowModule!());

@safe:

string handleTemplate(string handleName, string handlerMethod) {
  return `
    protected void `
    ~ handleName ~ `(scope HTTPServerRequest req, scope HTTPServerResponse res) {
        try {
          auto response = `
    ~ handlerMethod ~ `(req);
          res.writeJsonBody(response, response.code);
        } catch (Exception e) {
          writeError(res, 500, "Internal server error");
        }
    }`;
}

template HandleTemplate(string handleName, string handlerMethod) {
  const char[] HandleTemplate = handleTemplate(handleName, handlerMethod);
}
