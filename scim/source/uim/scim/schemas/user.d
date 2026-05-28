/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.schemas.user;

import uim.scim.schemas.resource;
import uim.scim.schemas.enterprise;

@safe:

// Structured name component (RFC 7643 §4.1.1)
struct ScimName {
  string formatted;        // full name including all parts, titles, suffixes
  string familyName;
  string givenName;
  string middleName;
  string honorificPrefix;  // Mr., Ms., Dr., etc.
  string honorificSuffix;  // Jr., III, etc.
}

// Generic multi-valued attribute (emails, phoneNumbers, ims, photos, etc.)
// RFC 7643 §2.4
struct ScimMultiValue {
  string value;     // primary value (email address, phone number, URL, …)
  string type;      // "work", "home", "other", or custom
  bool   primary;   // true = preferred/canonical value
  string display;   // human-readable label
  string ref_;      // $ref for reference types
}

// Physical mailing address (RFC 7643 §4.1.2)
struct ScimAddress {
  string formatted;      // full mailing address, may include newlines
  string streetAddress;
  string locality;       // city
  string region;         // state or province
  string postalCode;
  string country;        // ISO 3166-1 alpha-2
  string type;           // "work", "home", "other"
  bool   primary;
}

// Group membership back-reference on User (RFC 7643 §4.1.2, read-only)
struct ScimGroupRef {
  string value;    // group id
  string ref_;     // $ref — URI of the group
  string display;  // group displayName
  string type;     // "direct" or "indirect"
}

// SCIM User resource (RFC 7643 §4.1)
// Schema URN: urn:ietf:params:scim:schemas:core:2.0:User
class ScimUser : ScimResource {
  string           userName;         // unique identifier for the user
  ScimName         name;
  string           displayName;
  string           nickName;
  string           profileUrl;
  string           title;
  string           userType;
  string           preferredLanguage; // RFC 5646 language tag
  string           locale;            // RFC 5646 locale (e.g., "en-US")
  string           timezone;          // IANA timezone (e.g., "America/New_York")
  bool             active = true;
  string           password;           // write-only; never returned in responses

  ScimMultiValue[] emails;
  ScimMultiValue[] phoneNumbers;
  ScimMultiValue[] ims;
  ScimMultiValue[] photos;
  ScimAddress[]    addresses;
  ScimGroupRef[]   groups;            // read-only; populated by group store
  ScimMultiValue[] entitlements;
  ScimMultiValue[] roles;
  ScimMultiValue[] x509Certificates;

  // Enterprise User extension (optional)
  ScimEnterpriseUser enterpriseUser;

  // Convenience: return primary email value or ""
  string primaryEmail() const nothrow {
    foreach (e; emails) {
      if (e.primary) return e.value;
    }
    return emails.length > 0 ? emails[0].value : "";
  }

  unittest {
    auto u = new ScimUser();
    u.userName    = "alice";
    u.displayName = "Alice Smith";
    u.active      = true;
    u.emails      = [ScimMultiValue("alice@example.com", "work", true, "Work", "")];

    assert(u.userName == "alice");
    assert(u.primaryEmail == "alice@example.com");

    u.enterpriseUser = ScimEnterpriseUser("EMP-001", "", "Acme Corp", "", "Engineering");
    assert(!u.enterpriseUser.isEmpty);
  }
}
