/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.controllers.crud;

import uim.services;

mixin(ShowModule!());

@safe:

class CrudHttpController : HttpController {
  this() {
    super();
  }

  this(Json initData) {
    super(initData);
  }

  this(Json[string] initData) {
    super(initData);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // #region list
  protected Json listHandler(HTTPServerRequest req) {
    auto precheck = super.getHandler(req);
    // writeln("Precheck result in listHandler: ", precheck);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse("List handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleList", "listHandler"));
  // #endregion list

  // #region create
  protected Json createHandler(HTTPServerRequest req) {
    auto precheck = super.postHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Create handler not implemented", 201);
  }

  mixin(HandleTemplate!("handleCreate", "createHandler"));
  // #endregion create

  // #region get
  override protected Json getHandler(HTTPServerRequest req) {
    auto precheck = super.getHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Get handler not implemented", 200);
  }
  // #endregion get

  // #region update
  protected Json updateHandler(HTTPServerRequest req) {
    auto precheck = super.putHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck 

    return successResponse(precheck, "Update handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleUpdate", "updateHandler"));
  // #endregion update

  // #region delete
  override protected Json deleteHandler(HTTPServerRequest req) {
    auto precheck = super.deleteHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    return successResponse(precheck, "Delete handler not implemented", 200);
  }

  // #endregion delete
}
///
unittest {
  import std.stdio;
  import std.json;
  import std.array;
  import std.conv;
  import std.exception;
  import std.file;
  import std.process;

  void main() {
    writeln("Running unit tests for uim.services.presentation.http.controllers.crud...");

    // Add your unit tests here
    // Example:
    auto controller = new CrudHttpController();
    assert(controller.initialize());

    writeln("All unit tests passed.");
  }
}