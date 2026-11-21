/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Structured (one JSON object per line) logging, as expected by the SAP BTP
/// Cloud Logging / Kibana pipelines, plus a vibe.d request logging wrapper.
module uim.service.infrastructure.logging.structured;

import vibe.http.server : HTTPServerRequest, HTTPServerResponse, HTTPServerRequestDelegate;
import uim.service;

mixin(ShowModule!());

@safe:

/// Build a structured log record.
Json structuredLogRecord(string level, string component, string message, Json fields = Json(null)) @trusted {
  auto record = Json.emptyObject;
  record["written_at"] = Clock.currTime(UTC()).toISOExtString;
  record["level"] = level;
  record["logger"] = component;
  record["msg"] = message;
  if (fields.isObject)
    foreach (k, v; fields.get!(Json[string]))
      if (k !in record)
        record[k] = v;
  return record;
}

/// Write a structured log line through vibe's logger (level "info", "warn", "error", "debug").
void logStructured(string level, string component, string message, Json fields = Json(null)) @trusted {
  auto line = structuredLogRecord(level, component, message, fields).toString;
  switch (level) {
  case "error":
    logError("%s", line);
    break;
  case "warn":
    logWarn("%s", line);
    break;
  case "debug":
    logDebug("%s", line);
    break;
  default:
    logInfo("%s", line);
  }
}

/// Wrap a request handler so each request is logged with method, path, status and duration.
HTTPServerRequestDelegate withRequestLogging(HTTPServerRequestDelegate handler, string component) {
  return (HTTPServerRequest req, HTTPServerResponse res) @trusted {
    auto started = MonoTime.currTime;
    scope (exit) {
      auto fields = Json.emptyObject;
      fields["method"] = req.method.to!string;
      fields["request"] = req.requestPath.toString;
      fields["status"] = res.statusCode;
      fields["response_time_ms"] = (MonoTime.currTime - started).total!"msecs";
      if (auto cid = "X-Correlation-Id" in req.headers)
        fields["correlation_id"] = *cid;
      logStructured(res.statusCode >= 500 ? "error" : "info", component, "request", fields);
    }
    handler(req, res);
  };
}

///
unittest {
  mixin(ShowTest!("structuredLogRecord"));

  auto fields = Json.emptyObject;
  fields["status"] = 200;
  fields["level"] = "spoofed";
  auto r = structuredLogRecord("info", "demo", "hello", fields);
  assert(r["level"].get!string == "info");
  assert(r["status"].get!long == 200);
  assert(r["logger"].get!string == "demo");
}
