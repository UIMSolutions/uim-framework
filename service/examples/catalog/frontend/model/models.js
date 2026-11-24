sap.ui.define([
  "sap/ui/model/json/JSONModel",
  "sap/ui/Device"
], function (JSONModel, Device) {
  "use strict";

  return {
    createDeviceModel: function () {
      var model = new JSONModel(Device);
      model.setDefaultBindingMode("OneWay");
      return model;
    },

    /** UI state: the new product form and the reprice percentage. */
    createViewModel: function () {
      return new JSONModel({
        busy: false,
        newProduct: { sku: "", name: "", price: "", currency: "EUR", stock: 0, status: "draft" },
        repricePercent: 5
      });
    }
  };
});
