module uim.oop.patterns.mvc.controllers.rest;

import uim.oop;

@safe:
/**
 * RESTController - Controller for RESTful operations
 * 
 * Provides standard CRUD operations
 */
class RESTController : Controller {
  this(IMVCModel model = null, IView view = null) {
    super(model, view);
  }

  /**
     * Registers RESTful actions
     */
  override protected void registerDefaultActions() {
    // Index action - list all
    registerAction("index", (params) { return ["result": "Index action"]; });

    // Show action - show one
    registerAction("show", (params) {
      string id = params.get("id", "");
      return ["result": "Show action for id: " ~ id];
    });

    // Create action - create new
    registerAction("create", (params) {
      if (_model !is null) {
        foreach (key, value; params) {
          if (key != "action") {
            _model.data(key, value);
          }
        }
      }
      return ["result": "Create action"];
    });

    // Update action - update existing
    registerAction("update", (params) {
      string id = params.get("id", "");
      if (_model !is null) {
        foreach (key, value; params) {
          if (key != "action" && key != "id") {
            _model.data(key, value);
          }
        }
      }
      return ["result": "Update action for id: " ~ id];
    });

    // Delete action - delete existing
    registerAction("delete", (params) {
      string id = params.get("id", "");
      return ["result": "Delete action for id: " ~ id];
    });
  }
}
