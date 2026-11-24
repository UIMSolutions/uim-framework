sap.ui.define([], function () {
  "use strict";

  return {
    /** Product status → sap.ui.core.ValueState */
    statusState: function (status) {
      switch (status) {
        case "active": return "Success";
        case "draft": return "Information";
        case "discontinued": return "Error";
        default: return "None";
      }
    },

    /** Stock level → ValueState (warn when low) */
    stockState: function (stock) {
      if (stock === null || stock === undefined || stock === "") {
        return "None";
      }
      return Number(stock) <= 0 ? "Error" : (Number(stock) < 10 ? "Warning" : "Success");
    }
  };
});
