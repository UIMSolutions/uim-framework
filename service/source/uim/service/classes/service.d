/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.service;

import core.sync.mutex : Mutex;
import uim.service;

mixin(ShowModule!());

@safe:

class UIMService : IService, IUIMService {
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

  this(IUIMConfig config) {
    config.validate();
    _config = config;
    this.initialize();
  }

  this(ServiceConfiguration configuration) {
    _configuration = configuration;
    this.initialize();
  }

  bool initialize(Json[string] initData = null) {
    if (_configuration is null) {
      _configuration = new ServiceConfiguration();
    }
    return true;
  }

  // #region Lifecycle (IService)
  private bool _running;

  override void start() nothrow {
    _running = true;
  }

  override void stop() nothrow {
    _running = false;
  }

  @property bool isRunning() const nothrow {
    return _running;
  }
  // #endregion Lifecycle

  // #region Metadata (ServiceConfiguration)
  protected ServiceConfiguration _configuration;
  ServiceConfiguration configuration() {
    return _configuration;
  }

  void configuration(ServiceConfiguration value) {
    _configuration = value;
  }

  string name() const nothrow {
    return _configuration.name;
  }

  string description() const nothrow {
    return _configuration.description;
  }

  string version_() const nothrow {
    return _configuration.version_;
  }

  string author() const nothrow {
    return _configuration.author;
  }

  string license() const nothrow {
    return _configuration.license;
  }
  // #endregion Metadata

  // #region Config and probes (IUIMService)
  protected IUIMConfig _config;
  IUIMConfig config() {
    return _config;
  }

  void config(IUIMConfig cfg) {
    _config = cfg;
  }

  Json health() {
    Json healthInfo = Json.emptyObject;
    healthInfo["ok"] = true;
    healthInfo["status"] = "UP";
    healthInfo["service"] = _config !is null ? _config.serviceName : name;
    healthInfo["version"] = _config !is null ? _config.serviceVersion : version_;
    return healthInfo;
  }

  Json ready() {
    Json readyInfo = Json.emptyObject;
    readyInfo["ready"] = true;
    readyInfo["status"] = "READY";
    readyInfo["timestamp"] = Clock.currTime().toISOExtString();

    return readyInfo;
  }
  // #endregion Config and probes
}
