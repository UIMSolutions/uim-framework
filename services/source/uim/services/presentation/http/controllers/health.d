/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.controllers.health;

import uim.services;

mixin(ShowModule!());

@safe:
class HealthController : HttpController {
  this() {
    super();
  }

  this(string serviceName) {
    super();
    this.serviceName = serviceName;
  }

  this(string serviceName, string serviceVersion) {
    super();
    this.serviceName = serviceName;
    this.serviceVersion = serviceVersion;
  }

  protected string _serviceName = "service";
  @property string serviceName() {
    return _serviceName;
  }

  @property void serviceName(string name) {
    _serviceName = name;
  }

  protected string _serviceVersion = "1.0.0";
  @property string serviceVersion() {
    return _serviceVersion;
  }

  @property void serviceVersion(string version_) {
    _serviceVersion = version_;
  }

  override void registerRoutes(URLRouter router) {
    super.registerRoutes(router);

    router.get("/api/v1/health", &handleHealth);
  }

  protected void handleHealth(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    auto j = Json.emptyObject
    .set("status", "UP")
    .set("serviceName", serviceName)
    .set("serviceVersion", serviceVersion);
    
    res.writeJsonBody(j, 200);
  }
}
