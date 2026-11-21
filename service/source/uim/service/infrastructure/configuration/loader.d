/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Layered service configuration. Precedence (lowest → highest):
///
///   1. built-in defaults passed by the service
///   2. <configDir>/default.json
///   3. <configDir>/<profile>.json           (profile from UIM_PROFILE, e.g. "dev")
///   4. environment variables <PREFIX>_<KEY>  (camelCase key ↔ UPPER_SNAKE: basePath ↔ BASE_PATH)
///   5. Cloud Foundry: PORT, VCAP_APPLICATION, VCAP_SERVICES
///
/// VCAP_SERVICES bindings are exposed as config["services"][<name>] =
/// { "label", "plan", "tags", "credentials" } so adapters can look up e.g.
/// the XSUAA or PostgreSQL credentials by instance name or by label.
module uim.service.infrastructure.configuration.loader;

import std.file : exists, readText;
import std.path : buildPath;
import std.process : environment;
import std.ascii : isUpper, isLower, isDigit;
import uim.service;

mixin(ShowModule!());

@safe:

/// "basePath" → "BASE_PATH", "maxPageSize" → "MAX_PAGE_SIZE".
string toEnvName(string key) pure {
  string result;
  foreach (i, c; key) {
    if (isUpper(c) && i > 0 && (isLower(key[i - 1]) || isDigit(key[i - 1])))
      result ~= '_';
    result ~= c >= 'a' && c <= 'z' ? cast(char)(c - 32) : c;
  }
  return result;
}

/// Deep merge: objects are merged recursively, everything else is replaced.
Json mergeJson(Json base, Json overlay) {
  if (!base.isObject || !overlay.isObject)
    return overlay.clone;
  auto result = base.clone;
  foreach (k, v; overlay.get!(Json[string]))
    result[k] = k in result ? mergeJson(result[k], v) : v.clone;
  return result;
}

/// Convert an environment string to the JSON type of the existing value.
private Json coerce(string text, Json existing) {
  try {
    switch (existing.type) {
    case Json.Type.int_:
      return Json(text.to!long);
    case Json.Type.float_:
      return Json(text.to!double);
    case Json.Type.bool_:
      auto t = text.toLower;
      return Json(t == "true" || t == "1" || t == "yes" || t == "on");
    case Json.Type.array, Json.Type.object:
      return parseJsonString(text);
    default:
      return Json(text);
    }
  } catch (Exception) {
    return Json(text);
  }
}

/// Source of environment variables (injectable for tests).
alias EnvLookup = string delegate(string name) @safe;

/// Load the layered configuration of a service.
///   envPrefix  e.g. "AUDITLOG" → AUDITLOG_PORT, AUDITLOG_BASE_PATH
///   defaults   built-in defaults (also define which keys env vars may override)
Json loadServiceConfiguration(string envPrefix, Json defaults, string configDir = "config", EnvLookup env = null) @trusted {
  if (env is null)
    env = (string name) @trusted => environment.get(name, "");

  auto config = defaults.isObject ? defaults.clone : Json.emptyObject;

  void layerFile(string file) {
    auto path = buildPath(configDir, file);
    if (!exists(path))
      return;
    auto parsed = parseJsonString(readText(path));
    if (!parsed.isObject)
      throw new Exception("Configuration file " ~ path ~ " must contain a JSON object");
    config = mergeJson(config, parsed);
  }

  layerFile("default.json");
  auto profile = env("UIM_PROFILE");
  if (profile.length > 0)
    layerFile(profile ~ ".json");

  // environment overrides for all known top level keys
  auto prefix = envPrefix.length > 0 ? envPrefix.toUpper ~ "_" : "";
  foreach (key; config.get!(Json[string]).keys) {
    auto value = env(prefix ~ toEnvName(key));
    if (value.length > 0)
      config[key] = coerce(value, config[key]);
  }

  // Cloud Foundry
  auto port = env("PORT");
  if (port.length > 0)
    config["port"] = coerce(port, Json(0L));

  auto vcapApp = env("VCAP_APPLICATION");
  if (vcapApp.length > 0) {
    auto app = parseJsonString(vcapApp);
    config["application"] = app;
    if (app.isObject && "application_uris" in app && app["application_uris"].length > 0 && "publicUrl" !in config)
      config["publicUrl"] = "https://" ~ app["application_uris"][0].get!string;
  }

  auto vcapServices = env("VCAP_SERVICES");
  if (vcapServices.length > 0) {
    auto services = "services" in config && config["services"].isObject ? config["services"] : Json.emptyObject;
    auto vcap = parseJsonString(vcapServices);
    if (vcap.isObject)
      foreach (label, instances; vcap.get!(Json[string]))
        if (instances.type == Json.Type.array)
          foreach (instance; instances) {
            auto binding = Json.emptyObject;
            binding["label"] = label;
            binding["plan"] = instance["plan"].opt!string("");
            binding["tags"] = "tags" in instance ? instance["tags"] : Json.emptyArray;
            binding["credentials"] = "credentials" in instance ? instance["credentials"] : Json.emptyObject;
            services[instance["name"].opt!string(label)] = binding;
          }
    config["services"] = services;
  }
  return config;
}

/// Credentials of the first service binding with this instance name, label or tag (Json(null) if none).
Json serviceCredentials(Json config, string nameLabelOrTag) {
  if (!config.isObject || "services" !in config || !config["services"].isObject)
    return Json(null);
  auto services = config["services"];
  if (nameLabelOrTag in services)
    return services[nameLabelOrTag]["credentials"];
  foreach (name, binding; services.get!(Json[string])) {
    if (binding["label"].opt!string("") == nameLabelOrTag)
      return binding["credentials"];
    if ("tags" in binding)
      foreach (tag; binding["tags"].get!(Json[]))
        if (tag.type == Json.Type.string && tag.get!string == nameLabelOrTag)
          return binding["credentials"];
  }
  return Json(null);
}

///
unittest {
  mixin(ShowTest!("loadServiceConfiguration"));

  assert(toEnvName("basePath") == "BASE_PATH");
  assert(toEnvName("port") == "PORT");
  assert(toEnvName("maxPageSize") == "MAX_PAGE_SIZE");

  auto merged = mergeJson(parseJsonString(`{"a":{"x":1,"y":2},"b":1}`), parseJsonString(`{"a":{"y":3},"c":4}`));
  assert(merged["a"]["x"].get!long == 1 && merged["a"]["y"].get!long == 3 && merged["c"].get!long == 4);

  string[string] vars = [
    "DEMO_PORT": "9000", "DEMO_REQUIRE_AUTH": "true", "DEMO_BASE_PATH": "/api",
    "VCAP_SERVICES": `{"xsuaa":[{"name":"demo-uaa","plan":"application","tags":["xsuaa"],"credentials":{"clientid":"c1"}}]}`,
    "VCAP_APPLICATION": `{"application_uris":["demo.cfapps.eu10.hana.ondemand.com"]}`
  ];
  auto defaults = parseJsonString(`{"port":8080,"requireAuth":false,"basePath":"/","host":"0.0.0.0"}`);
  auto cfg = loadServiceConfiguration("demo", defaults, "/nonexistent", (string n) @safe => vars.get(n, ""));
  assert(cfg["port"].get!long == 9000);
  assert(cfg["requireAuth"].get!bool);
  assert(cfg["basePath"].get!string == "/api");
  assert(cfg["host"].get!string == "0.0.0.0");
  assert(cfg["publicUrl"].get!string == "https://demo.cfapps.eu10.hana.ondemand.com");
  assert(serviceCredentials(cfg, "demo-uaa")["clientid"].get!string == "c1");
  assert(serviceCredentials(cfg, "xsuaa")["clientid"].get!string == "c1");
  assert(serviceCredentials(cfg, "postgres").type == Json.Type.null_);

  vars["PORT"] = "7777"; // CF PORT wins
  assert(loadServiceConfiguration("demo", defaults, "/nonexistent", (string n) @safe => vars.get(n, ""))["port"]
      .get!long == 7777);
}
