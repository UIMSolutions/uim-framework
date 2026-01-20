/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.models.organization;

import uim.cdm;
import std.uuid : UUID;

/**
 * Organization model representing a company or organizational unit
 */
class Organization : CdmModel {
    mixin(ObjThis!("Organization"));

    protected string _legalName;
    protected string _taxId;
    protected string _registrationNumber;
    protected UUID _parentOrganizationId;
    protected string _organizationType;
    protected string _email;
    protected string _phone;
    protected string _website;

    // Property getters
    string legalName() const { return _legalName; }
    string taxId() const { return _taxId; }
    string registrationNumber() const { return _registrationNumber; }
    UUID parentOrganizationId() const { return _parentOrganizationId; }
    string organizationType() const { return _organizationType; }
    string email() const { return _email; }
    string phone() const { return _phone; }
    string website() const { return _website; }

    // Property setters (fluent interface)
    auto legalName(string value) { _legalName = value; touch(); return this; }
    auto taxId(string value) { _taxId = value; touch(); return this; }
    auto registrationNumber(string value) { _registrationNumber = value; touch(); return this; }
    auto parentOrganizationId(UUID value) { _parentOrganizationId = value; touch(); return this; }
    auto organizationType(string value) { _organizationType = value; touch(); return this; }
    auto email(string value) { _email = value; touch(); return this; }
    auto phone(string value) { _phone = value; touch(); return this; }
    auto website(string value) { _website = value; touch(); return this; }

    override Json toJson() const {
        Json result = super.toJson();
        result["legalName"] = legalName;
        result["taxId"] = taxId;
        result["registrationNumber"] = registrationNumber;
        if (_parentOrganizationId != UUID.init) {
            result["parentOrganizationId"] = parentOrganizationId.toString();
        }
        result["organizationType"] = organizationType;
        result["email"] = email;
        result["phone"] = phone;
        result["website"] = website;
        return result;
    }
}
