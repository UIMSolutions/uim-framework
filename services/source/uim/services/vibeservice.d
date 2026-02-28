/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.vibeservice;

import std.process : environment;
import std.conv : to;

import vibe.d;

import uim.services.classes.configuration;
import uim.services.classes.service;

@safe:

struct ServiceApiConfig {
  string host = "0.0.0.0";
  ushort port = 8080;
  string basePath = "/api/v1";
}

ServiceApiConfig serviceApiConfigFromEnv() {
  auto cfg = ServiceApiConfig.init;

  cfg.host = environment.get("HOST", cfg.host);
  cfg.basePath = environment.get("BASE_PATH", cfg.basePath);

  auto rawPort = environment.get("PORT", "8080");
  try {
    cfg.port = rawPort.to!ushort;
  } catch (Exception) {
    cfg.port = 8080;
  }

  return cfg;
}

void serveServiceApi(UIMService service, ServiceApiConfig cfg = ServiceApiConfig.init) {
  auto router = new URLRouter;

  auto servicePath = cfg.basePath ~ "/service";

  router.get("/health", (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
    writeJson(res, Json([
      "status": Json("ok"),
      "component": Json("uim-services"),
      "running": Json(service.isRunning)
    ]));
  });

  router.get(servicePath, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
    writeJson(res, serviceToJson(service));
  });

  router.post(servicePath ~ "/start", (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
    service.start();
    writeJson(res, serviceToJson(service));
  });

  router.post(servicePath ~ "/stop", (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
    service.stop();
    writeJson(res, serviceToJson(service));
  });

  auto settings = new HTTPServerSettings;
  settings.hostName = cfg.host;
  settings.port = cfg.port;

  listenHTTP(settings, router);
  runApplication();
}

private Json serviceToJson(UIMService service) {
  return Json([
    "name": Json(service.name),
    "description": Json(service.description),
    "version": Json(service.version_),
    "author": Json(service.author),
    "license": Json(service.license),
    "running": Json(service.isRunning)
  ]);
}

private void writeJson(scope HTTPServerResponse res, Json payload) @trusted {
  res.statusCode = 200;
  res.headers["Content-Type"] = "application/json";
  res.writeBody(payload.toString());
}
