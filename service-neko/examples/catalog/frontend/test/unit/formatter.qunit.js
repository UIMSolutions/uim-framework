/* global QUnit */
sap.ui.define(["uim/catalog/model/formatter"], function (formatter) {
  "use strict";

  QUnit.module("formatter");

  QUnit.test("statusState", function (assert) {
    assert.strictEqual(formatter.statusState("active"), "Success");
    assert.strictEqual(formatter.statusState("draft"), "Information");
    assert.strictEqual(formatter.statusState("discontinued"), "Error");
    assert.strictEqual(formatter.statusState("other"), "None");
  });

  QUnit.test("stockState", function (assert) {
    assert.strictEqual(formatter.stockState(0), "Error");
    assert.strictEqual(formatter.stockState("5"), "Warning");
    assert.strictEqual(formatter.stockState(100), "Success");
    assert.strictEqual(formatter.stockState(null), "None");
  });
});
