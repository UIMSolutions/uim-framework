/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.models.product;

import uim.cdm;
import std.uuid : UUID;

/**
 * Product model representing a product or service
 */
class Product : CdmModel {
    mixin(ObjThis!("Product"));

    protected string _sku;
    protected string _barcode;
    protected string _category;
    protected string _brand;
    protected double _price;
    protected string _currency;
    protected double _cost;
    protected int _stockQuantity;
    protected int _reorderLevel;
    protected string _unit;
    protected double _weight;
    protected string _weightUnit;

    // Property getters
    string sku() const { return _sku; }
    string barcode() const { return _barcode; }
    string category() const { return _category; }
    string brand() const { return _brand; }
    double price() const { return _price; }
    string currency() const { return _currency; }
    double cost() const { return _cost; }
    int stockQuantity() const { return _stockQuantity; }
    int reorderLevel() const { return _reorderLevel; }
    string unit() const { return _unit; }
    double weight() const { return _weight; }
    string weightUnit() const { return _weightUnit; }

    // Property setters (fluent interface)
    auto sku(string value) { _sku = value; touch(); return this; }
    auto barcode(string value) { _barcode = value; touch(); return this; }
    auto category(string value) { _category = value; touch(); return this; }
    auto brand(string value) { _brand = value; touch(); return this; }
    auto price(double value) { _price = value; touch(); return this; }
    auto currency(string value) { _currency = value; touch(); return this; }
    auto cost(double value) { _cost = value; touch(); return this; }
    auto stockQuantity(int value) { _stockQuantity = value; touch(); return this; }
    auto reorderLevel(int value) { _reorderLevel = value; touch(); return this; }
    auto unit(string value) { _unit = value; touch(); return this; }
    auto weight(double value) { _weight = value; touch(); return this; }
    auto weightUnit(string value) { _weightUnit = value; touch(); return this; }

    // Computed properties
    bool needsReorder() const {
        return _stockQuantity <= _reorderLevel;
    }

    double margin() const {
        if (_price == 0) return 0;
        return ((_price - _cost) / _price) * 100;
    }

    override Json toJson() const {
        Json result = super.toJson();
        result["sku"] = sku;
        result["barcode"] = barcode;
        result["category"] = category;
        result["brand"] = brand;
        result["price"] = price;
        result["currency"] = currency;
        result["cost"] = cost;
        result["stockQuantity"] = stockQuantity;
        result["reorderLevel"] = reorderLevel;
        result["unit"] = unit;
        result["weight"] = weight;
        result["weightUnit"] = weightUnit;
        result["needsReorder"] = needsReorder;
        result["margin"] = margin;
        return result;
    }

    override bool isValid() const {
        return super.isValid() && _sku.length > 0 && _price >= 0;
    }

    override string[] validationErrors() const {
        auto errors = super.validationErrors();
        if (_sku.length == 0) {
            errors ~= "SKU is required";
        }
        if (_price < 0) {
            errors ~= "Price must be non-negative";
        }
        return errors;
    }
}
