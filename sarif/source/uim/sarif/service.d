/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.sarif.service;

import std.exception : enforce;
import std.json;

import vibe.d : runTask;

import uim.core;
import uim.sarif.model;

mixin(ShowModule!());

alias SarifDocumentHandler = void delegate(SarifLog document);
@safe:

struct SarifService {
    SarifLog parse(string source) const {
        return SarifLog.fromJson(parseJsonString(source));
    }

    bool validate(const ref SarifLog document) const pure nothrow @safe {
        return document.isValid();
    }

    string stringify(const ref SarifLog document) const @trusted {
        return document.toJsonString();
    }

    void parseAsync(string source, scope SarifDocumentHandler handler) const {
        (() @trusted {
            runTask(() nothrow{
                try {
                    auto document = parse(source);
                    handler(document);
                } catch (Exception) {
                }
            });
        })();
    }

    @trusted SarifLog parseOrThrow(string source) const {
        return parse(source);
    }
}

unittest {
    auto service = SarifService();
    auto document = SarifLog(
        SarifVersion.v2_1_0,
        [
            SarifRun(
                SarifTool(SarifToolComponent("sarif-tool", "1.0.0", "1.0.0", "", "", "", "", [
                ])),
                [
                    SarifResult("RULE001", "warning", "fail", SarifMessage("example"), [
                    ])
                ]
            )
        ]
    );

    assert(service.validate(document));
    auto payload = service.stringify(document);
    auto decoded = service.parse(payload);
    assert(decoded.runs.length == 1);
    assert(decoded.runs[0].results[0].ruleId == "RULE001");
}
