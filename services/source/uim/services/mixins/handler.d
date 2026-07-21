/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
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
