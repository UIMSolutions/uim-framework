/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.models.account;

import uim.cdm;
import std.uuid : UUID;

/**
 * Account model representing a customer or business account
 */
class Account : CdmModel {
    mixin(ObjThis!("Account"));

    protected string _accountNumber;
    protected string _email;
    protected string _phone;
    protected string _website;
    protected string _industry;
    protected string _type;
    protected UUID _parentAccountId;
    protected string _addressLine1;
    protected string _addressLine2;
    protected string _city;
    protected string _state;
    protected string _postalCode;
    protected string _country;
    protected double _revenue;
    protected int _employeeCount;

    // Property getters
    string accountNumber() const { return _accountNumber; }
    string email() const { return _email; }
    string phone() const { return _phone; }
    string website() const { return _website; }
    string industry() const { return _industry; }
    string type() const { return _type; }
    UUID parentAccountId() const { return _parentAccountId; }
    string addressLine1() const { return _addressLine1; }
    string addressLine2() const { return _addressLine2; }
    string city() const { return _city; }
    string state() const { return _state; }
    string postalCode() const { return _postalCode; }
    string country() const { return _country; }
    double revenue() const { return _revenue; }
    int employeeCount() const { return _employeeCount; }

    // Property setters (fluent interface)
    auto accountNumber(string value) { _accountNumber = value; touch(); return this; }
    auto email(string value) { _email = value; touch(); return this; }
    auto phone(string value) { _phone = value; touch(); return this; }
    auto website(string value) { _website = value; touch(); return this; }
    auto industry(string value) { _industry = value; touch(); return this; }
    auto type(string value) { _type = value; touch(); return this; }
    auto parentAccountId(UUID value) { _parentAccountId = value; touch(); return this; }
    auto addressLine1(string value) { _addressLine1 = value; touch(); return this; }
    auto addressLine2(string value) { _addressLine2 = value; touch(); return this; }
    auto city(string value) { _city = value; touch(); return this; }
    auto state(string value) { _state = value; touch(); return this; }
    auto postalCode(string value) { _postalCode = value; touch(); return this; }
    auto country(string value) { _country = value; touch(); return this; }
    auto revenue(double value) { _revenue = value; touch(); return this; }
    auto employeeCount(int value) { _employeeCount = value; touch(); return this; }

    override Json toJson() const {
        Json result = super.toJson();
        result["accountNumber"] = accountNumber;
        result["email"] = email;
        result["phone"] = phone;
        result["website"] = website;
        result["industry"] = industry;
        result["type"] = type;
        if (_parentAccountId != UUID.init) {
            result["parentAccountId"] = parentAccountId.toString();
        }
        result["addressLine1"] = addressLine1;
        result["addressLine2"] = addressLine2;
        result["city"] = city;
        result["state"] = state;
        result["postalCode"] = postalCode;
        result["country"] = country;
        result["revenue"] = revenue;
        result["employeeCount"] = employeeCount;
        return result;
    }
}
