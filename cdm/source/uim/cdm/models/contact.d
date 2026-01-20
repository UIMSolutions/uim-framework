/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.models.contact;

import uim.cdm;
import std.uuid : UUID;

/**
 * Contact model representing a person or contact point
 */
class Contact : CdmModel {
    mixin(ObjThis!("Contact"));

    protected string _firstName;
    protected string _lastName;
    protected string _middleName;
    protected string _email;
    protected string _phone;
    protected string _mobile;
    protected string _title;
    protected string _department;
    protected UUID _accountId;
    protected string _addressLine1;
    protected string _addressLine2;
    protected string _city;
    protected string _state;
    protected string _postalCode;
    protected string _country;

    // Property getters
    string firstName() const { return _firstName; }
    string lastName() const { return _lastName; }
    string middleName() const { return _middleName; }
    string email() const { return _email; }
    string phone() const { return _phone; }
    string mobile() const { return _mobile; }
    string title() const { return _title; }
    string department() const { return _department; }
    UUID accountId() const { return _accountId; }
    string addressLine1() const { return _addressLine1; }
    string addressLine2() const { return _addressLine2; }
    string city() const { return _city; }
    string state() const { return _state; }
    string postalCode() const { return _postalCode; }
    string country() const { return _country; }

    // Property setters (fluent interface)
    auto firstName(string value) { _firstName = value; touch(); return this; }
    auto lastName(string value) { _lastName = value; touch(); return this; }
    auto middleName(string value) { _middleName = value; touch(); return this; }
    auto email(string value) { _email = value; touch(); return this; }
    auto phone(string value) { _phone = value; touch(); return this; }
    auto mobile(string value) { _mobile = value; touch(); return this; }
    auto title(string value) { _title = value; touch(); return this; }
    auto department(string value) { _department = value; touch(); return this; }
    auto accountId(UUID value) { _accountId = value; touch(); return this; }
    auto addressLine1(string value) { _addressLine1 = value; touch(); return this; }
    auto addressLine2(string value) { _addressLine2 = value; touch(); return this; }
    auto city(string value) { _city = value; touch(); return this; }
    auto state(string value) { _state = value; touch(); return this; }
    auto postalCode(string value) { _postalCode = value; touch(); return this; }
    auto country(string value) { _country = value; touch(); return this; }

    // Computed properties
    string fullName() const {
        string result = _firstName;
        if (_middleName.length > 0) {
            result ~= " " ~ _middleName;
        }
        if (_lastName.length > 0) {
            result ~= " " ~ _lastName;
        }
        return result;
    }

    override Json toJson() const {
        Json result = super.toJson();
        result["firstName"] = firstName;
        result["lastName"] = lastName;
        result["middleName"] = middleName;
        result["email"] = email;
        result["phone"] = phone;
        result["mobile"] = mobile;
        result["title"] = title;
        result["department"] = department;
        if (_accountId != UUID.init) {
            result["accountId"] = accountId.toString();
        }
        result["addressLine1"] = addressLine1;
        result["addressLine2"] = addressLine2;
        result["city"] = city;
        result["state"] = state;
        result["postalCode"] = postalCode;
        result["country"] = country;
        result["fullName"] = fullName;
        return result;
    }

    override bool isValid() const {
        return super.isValid() && 
               (_firstName.length > 0 || _lastName.length > 0) &&
               (_email.length > 0 || _phone.length > 0);
    }

    override string[] validationErrors() const {
        auto errors = super.validationErrors();
        if (_firstName.length == 0 && _lastName.length == 0) {
            errors ~= "Either firstName or lastName is required";
        }
        if (_email.length == 0 && _phone.length == 0) {
            errors ~= "Either email or phone is required";
        }
        return errors;
    }
}
