/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.server;

import uim.service;

mixin(ShowModule!());

@safe:
/**
  * SAPServer - Base class for all SAP service HTTP servers
  * Provides common functionality like:
  * - Base path handling
  * - Authentication validation
  * - Common platform endpoints (health, readiness)
  * - Error handling
  * Each service-specific server (e.g. SLMServer, HARServer) will extend this class and implement the service-specific routing logic.
  * Routes:
  *   GET  /health
  *   GET  /ready  
  *   (other routes are implemented in subclasses)

  */
class UIMServer {
  this() {
    initialize();
  }

  this(Json initData) {
    if (initData.isObject) {
      initialize(initData.toMap);
    }
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  this(IUIMService service) {
    _service = service;
  }

  bool initialize(Json[string] initData = null) {
    // Initialization logic for the store
    return true;
  }

  protected IUIMService _service;
  // -- host --
  protected string _host;
  string host() const
  {
    return _host;
  }

  void host(string value) {
    _host = value;
  }

  // -- port --
  protected ushort _port;

  ushort port() const
  {
    return _port;
  }

  void port(ushort value) {
    _port = value;
  }

  // -- basePath --
  protected string _basePath;

  string basePath() const
  {
    return _basePath;
  }

  void basePath(string value) {
    _basePath = value;
  }

  // -- subPath --
  protected string _subPath;

  string subPath() const
  {
    return _subPath;
  }

  void subPath(string value) {
    _subPath = value;
  }

  // -- requireAuthToken --
  protected bool _requireAuthToken;

  bool requireAuthToken() const
  {
    return _requireAuthToken;
  }

  void requireAuthToken(bool value) {
    _requireAuthToken = value;
  }

  // -- authToken --
  protected string _authToken;

  string authToken() const
  {
    return _authToken;
  }

  void authToken(string value) {
    _authToken = value;
  }

  // -- customHeaders --
  protected string[string] _customHeaders;
  string[string] customHeaders() {
    return _customHeaders;
  }

  void customHeaders(string[string] value) {
    _customHeaders = value;
  }

  void run() {
    auto settings = new HTTPServerSettings;
    settings.port = _service.config.port;
    settings.bindAddresses = [_service.config.host];
    listenHTTP(settings, &handleRequest);
    runApplication();
  }

  void handleRequest(HTTPServerRequest req, HTTPServerResponse res) {
    foreach (key, value; _service.config.customHeaders)
      res.headers[key] = value;

    _basePath = _service.config.basePath;
    auto path = req.requestPath.toString();
    if (!path.startsWith(_basePath)) {
      respondError(res, "Not found", 404);
      return;
    }

    _subPath = path[_basePath.length .. $];
    if (_subPath.length == 0)
      _subPath = "/";

    // ---------------------------------------------------------------
    // Platform endpoints (no auth required)
    // ---------------------------------------------------------------
    // ── Health / readiness ────────────────────────────────────────────
    if (_subPath == "/health" && req.method == HTTPMethod.GET) {
      res.writeJsonBody(_service.health(), 200);
      return;
    }

    if (_subPath == "/ready" && req.method == HTTPMethod.GET) {
      res.writeJsonBody(_service.ready(), 200);
      return;
    }
  }

  Json toJson() {
    return Json.emptyObject;
  }
}
