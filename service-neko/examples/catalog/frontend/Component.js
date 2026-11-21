sap.ui.define([
  "sap/ui/core/UIComponent",
  "uim/catalog/model/models"
], function (UIComponent, models) {
  "use strict";

  return UIComponent.extend("uim.catalog.Component", {
    metadata: {
      manifest: "json",
      interfaces: ["sap.ui.core.IAsyncContentCreation"]
    },

    init: function () {
      UIComponent.prototype.init.apply(this, arguments);
      this.setModel(models.createDeviceModel(), "device");
      this.setModel(models.createViewModel(), "view");
    }
  });
});
