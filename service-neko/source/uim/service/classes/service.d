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

class UIMService : IUIMService {
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

  bool initialize(Json[string] initData = null) {
    // Initialization logic for the store

    return true;
  }

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
    healthInfo["service"] = _config.serviceName;
    healthInfo["version"] = _config.serviceVersion;
    return healthInfo;
  }

  Json ready() {
    Json readyInfo = Json.emptyObject;
    readyInfo["ready"] = true;
    readyInfo["status"] = "READY";
    readyInfo["timestamp"] = Clock.currTime().toISOExtString();

    return readyInfo;
  }

}
