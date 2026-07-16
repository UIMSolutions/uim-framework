/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.controllers.manage;

import uim.services;

mixin(ShowModule!());

@safe:

class ManageHttpController : HttpController {
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

    precheck["id"] = extractIdFromPath(precheck.path);
    auto id = precheck.id;
    if (id.isEmpty)
      return errorResponse("ID is required", 400);

    return successResponse(precheck, "Update handler not implemented", 200);
  }

  mixin(HandleTemplate!("handleUpdate", "updateHandler"));
  // #endregion update

  // #region delete
  override protected Json deleteHandler(HTTPServerRequest req) {
    auto precheck = super.deleteHandler(req);
    if (precheck.hasError)
      return precheck; // Return error response from precheck

    auto id = precheck.id;
    if (id.isEmpty)
      return errorResponse("ID is required", 400);

    return successResponse(precheck, "Delete handler not implemented", 200);
  }

  // #endregion delete
}
///
unittest {
  auto controller = new ManageHttpController();
  assert(controller.requiredTenant() == true);
  // 
  auto controllerWithInit = new ManageHttpController(Json.emptyObject.set("requiredTenant", false));
  assert(controllerWithInit.requiredTenant() == false);
  // 
  Json[string] initData = ["requiredTenant": Json(true)];
  auto controllerWithInit2 = new ManageHttpController(initData);
  assert(controllerWithInit2.requiredTenant() == true);

  // Test listHandler
  auto listResponse = controller.listHandler(null);
  assert(listResponse.getString("status") == "error");
  // // assert(listResponse.getString("message") == "Tenant ID is required");

  // // Make a List request
  // // auto response = requestHTTP("http://localhost:8080/api/users",
  // //     (scope req) {
  // //         req.method = HTTPMethod.GET;
  // //     }
  // // );

  listResponse = controllerWithInit.listHandler(null);
  // // assert(listResponse.getString("status") == "ok");
  // // assert(listResponse.getString("message") == "Precheck passed");

  // // Test createHandler
  auto createResponse = controller.createHandler(null);
  assert(createResponse.getString("status") == "error");
  // // assert(createResponse.getString("message") == "Tenant ID is required");

  createResponse = controllerWithInit.createHandler(null);
  // // assert(createResponse.getString("status") == "error");
  // // assert(createResponse.getString("message") == "Request body is required");

  // // Test getHandler
  auto getResponse = controller.getHandler(null);
  assert(getResponse.getString("status") == "error");
  // // assert(getResponse.getString("message") == "Tenant ID is required");

  // getResponse = controllerWithInit.getHandler(null);
  // // assert(getResponse.getString("status") == "ok");
  // // assert(getResponse.getString("message") == "Get handler not implemented");

  // // Test updateHandler
  auto updateResponse = controller.updateHandler(null);
  assert(updateResponse.getString("status") == "error");
  // // assert(updateResponse.getString("message") == "Tenant ID is required");

  updateResponse = controllerWithInit.updateHandler(null);
  assert(updateResponse.getString("status") == "error");
  // // assert(updateResponse.getString("message") == "Request body is required");

  // // Test deleteHandler
  // auto deleteResponse = controller.deleteHandler(null);
  // // assert(deleteResponse.getString("status") == "error");
  // // assert(deleteResponse.getString("message") == "Tenant ID is required");

  // deleteResponse = controllerWithInit.deleteHandler(null);
  // // assert(deleteResponse.getString("status") == "ok");
  // // assert(deleteResponse.getString("message") == "Delete handler not implemented");

  // HTTPServerRequest req;
  // // req.headers["X-Tenant-Id"] = "tenant1";

  // // writeln(req);

  // listResponse = controller.listHandler(req);
  // //  assert(listResponse.getString("status") == "ok");
  // //  assert(listResponse.getString("message") == "Precheck passed");

}
