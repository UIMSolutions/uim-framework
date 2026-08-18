/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.vibe.http.response;

import uim.core;

mixin(ShowModule!());

@safe:
void writeHtml(scope HTTPServerResponse res, string html) {
    res.writeBody(html, cast(int) HTTPStatus.ok, "text/html; charset=utf-8");
}
