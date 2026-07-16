/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.controllers.controller;

import uim.services;

mixin(ShowModule!());

@safe:

class HttpController {
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

  bool initialize(Json[string] initData = null) {
    // Initialization logic for the controller

    _requiredTenant = initData.getBoolean("requiredTenant", true);
    return true;
  }

  void registerRoutes(URLRouter router) {
    // Register HTTP routes and handlers here
  }

  protected bool _requiredTenant = true; // Tenant is required for manage controllers
  bool requiredTenant() {
    return _requiredTenant;
  }

  Json precheckHandler(HTTPServerRequest req) {
    auto precheck = Json.emptyObject;

    // writeln("Precheck: Checking request validity for path ", req.requestPath);
    // writeln("Precheck: Request method ", req.method);
    // writeln("Precheck: Request headers ", req.headers);
    // writeln("Precheck: Request params ", req.params);
    // writeln("Precheck: Request query ", req.query);
    // writeln("Precheck: Request body ", req.json);

    if (req is null)
      return errorResponse("Request is required", 400);

    if (requiredTenant()) {
      auto tenantId = TenantId(req.headers.get("X-Tenant-Id", "default"));
      if (tenantId.isNull)
        return errorResponse("Tenant ID is required", 400);

      precheck["tenantId"] = tenantId.value;
    }

    Json params = Json.emptyObject;
    req.params.byKeyValue.each!(kv => params[kv.key] = kv.value);

    Json query = Json.emptyObject;
    req.query.byKeyValue.each!(kv => query[kv.key] = kv.value);

    return precheck
      .set("path", req.requestPath.to!string)
      .set("method", req.method.to!string) // .set("headers", req.headers.toMap)
      .set("params", params)
      .set("query", query)
      .set("data", req.json)
      .set("status", "ok")
      .set("rootDir", req.rootDir)
      .set("host", req.host)
      .set("method", req.method.to!string)
      .set("peer", req.peer)
      .set("message", "Precheck passed")
      .set("code", 200);
  }

  // #region get
  protected Json getHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    // writeln("Precheck result in listHandler: ", precheck);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    precheck["id"] = extractIdFromPath(precheck.path);

    return successResponse(precheck, "Get handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleGet", "getHandler"));

  // #endregion get

  // #region post
  protected Json headHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Head handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleHead", "headHandler"));

  // #endregion head}

  // #region post
  protected Json postHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    precheck["data"] = req.json;
    return successResponse(precheck, "Post handler not implemented", 201);
  }

  mixin(HandleTemplate!("handlePost", "postHandler"));

  // #endregion post

  // #region put
  protected Json putHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    precheck["data"] = req.json;
    return successResponse(precheck, "Put handler not implemented", 200);
  }

  mixin(HandleTemplate!("handlePut", "putHandler"));

  // #endregion put

  // #region delete
  protected Json deleteHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    precheck["path"] = req.requestPath.to!string;
    precheck["id"] = extractIdFromPath(precheck.path);
    return successResponse(precheck, "Delete handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleDelete", "deleteHandler"));

  // #endregion delete

  // #region connect
  protected Json connectHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Connect handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleConnect", "connectHandler"));

  // #endregion connect

  // #region trace
  protected Json traceHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Trace handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleTrace", "traceHandler"));

  // #endregion trace

  // #region patch
  protected Json patchHandler(HTTPServerRequest req) {
    auto precheck = precheckHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Patch handler not implemented", 200);
  }

  mixin(HandleTemplate!("handlePatch", "patchHandler"));

  // #endregion patch

}
