sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/m/MessageToast",
  "sap/m/MessageBox",
  "uim/catalog/model/formatter"
], function (Controller, MessageToast, MessageBox, formatter) {
  "use strict";

  return Controller.extend("uim.catalog.controller.App", {
    formatter: formatter,

    _text: function (key, args) {
      return this.getOwnerComponent().getModel("i18n").getResourceBundle().getText(key, args);
    },

    _showError: function (error) {
      MessageBox.error(error && error.message ? error.message : String(error));
    },

    /** Refresh list and statistics (both are read via $batch). */
    onRefresh: function () {
      this.byId("products").getBinding("items").refresh();
      this.byId("statistics").getElementBinding().refresh();
    },

    /** Free text search → OData $search */
    onSearch: function (event) {
      var query = event.getParameter("query");
      this.byId("products").getBinding("items").changeParameters({ $search: query || undefined });
    },

    onOpenCreate: function () {
      this.getView().getModel("view").setProperty("/newProduct",
        { sku: "", name: "", price: "", currency: "EUR", stock: 0, status: "draft" });
      this.byId("createDialog").open();
    },

    onCreate: function () {
      var data = Object.assign({}, this.getView().getModel("view").getProperty("/newProduct"));
      if (data.price === "") {
        delete data.price;
      }
      data.stock = parseInt(data.stock, 10) || 0;
      var context = this.byId("products").getBinding("items").create(data);
      this.byId("createDialog").close();
      context.created().then(function () {
        MessageToast.show(this._text("created"));
        this.byId("statistics").getElementBinding().refresh();
      }.bind(this), function (error) {
        if (!error.canceled) {
          this._showError(error);
        }
      }.bind(this));
    },

    onDelete: function () {
      var contexts = this.byId("products").getSelectedContexts();
      if (contexts.length === 0) {
        MessageToast.show(this._text("noSelection"));
        return;
      }
      MessageBox.confirm(this._text("deleteConfirm"), {
        onClose: function (action) {
          if (action !== MessageBox.Action.OK) {
            return;
          }
          Promise.all(contexts.map(function (c) { return c.delete(); })).then(function () {
            MessageToast.show(this._text("deleted"));
            this.byId("products").removeSelections(true);
            this.byId("statistics").getElementBinding().refresh();
          }.bind(this), this._showError.bind(this));
        }.bind(this)
      });
    },

    onOpenReprice: function () {
      this.byId("repriceDialog").open();
    },

    /** Invoke the unbound action Reprice(percent) */
    onReprice: function () {
      var percent = Number(this.getView().getModel("view").getProperty("/repricePercent"));
      var action = this.getView().getModel().bindContext("/Reprice(...)");
      action.setParameter("percent", percent);
      this.byId("repriceDialog").close();
      action.execute().then(function () {
        MessageToast.show(this._text("repriced", [action.getBoundContext().getProperty("changed")]));
        this.onRefresh();
      }.bind(this), this._showError.bind(this));
    },

    onCloseDialog: function (event) {
      event.getSource().getParent().close();
    }
  });
});
