/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.schemas.enterprise;

@safe:

// Manager reference sub-attribute (RFC 7643 §4.3)
struct ScimManagerRef {
  string value;        // manager's resource id
  string ref_;         // $ref — URI of the manager resource
  string displayName;
}

// Enterprise User schema extension (RFC 7643 §4.3)
// Schema URN: urn:ietf:params:scim:schemas:extension:enterprise:2.0:User
struct ScimEnterpriseUser {
  string        employeeNumber;
  string        costCenter;
  string        organization;
  string        division;
  string        department;
  ScimManagerRef manager;

  bool isEmpty() const nothrow {
    return employeeNumber.length == 0
        && costCenter.length    == 0
        && organization.length  == 0
        && division.length      == 0
        && department.length    == 0
        && manager.value.length == 0;
  }

  unittest {
    ScimEnterpriseUser eu;
    assert(eu.isEmpty);

    eu.employeeNumber = "EMP-001";
    eu.department     = "Engineering";
    eu.manager        = ScimManagerRef("mgr-42", "/Users/mgr-42", "Jane Doe");
    assert(!eu.isEmpty);
    assert(eu.manager.displayName == "Jane Doe");
  }
}
