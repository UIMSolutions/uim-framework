/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.tenants.tenant;

import uim.service;

mixin(ShowModule!());

@safe:
class UIMTenant : UIMEntity, IUIMTenant {
  mixin(UIMEntityTemplate!UIMTenant);

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return validate();
  }

  UUID _id; // Unique identifier for the tenant
  UUID id() {
    return _id;
  }

  void id(UUID value) {
    _id = value;
  }

  string _name; // Name of the tenant  
  string name() {
    return _name;
  }

  void name(string value) {
    _name = value;
  }

  string _description; // Optional description of the tenant
  string description() {
    return _description;
  }

  void description(string value) {
    _description = value;
  }

  string _domain; // Custom domain associated with the tenant
  string domain() {
    return _domain;
  }

  void domain(string value) {
    _domain = value;
  }

  string _owner; // Owner of the tenant
  string owner() {
    return _owner;
  }

  void owner(string value) {
    _owner = value;
  }

  Json _settings; // Tenant-specific settings in JSON format
  Json settings() {
    return _settings;
  }

  void settings(Json value) {
    _settings = value;
  }

  bool isValid() {
    return validate();
  }

  bool validate() {
    // Basic validation logic for tenant properties
    // if (id == null || name == "" || domain == "" || owner == "") {
    //   return false;
    // }
    // Additional validation can be added here (e.g., domain format)
    return true;
  }

  // Method to update tenant settings
  void update(Json settings) {
    // settings = newSettings;
    // updatedAt = SysTime.nowUTC();
  }

  override Json toJson() {
    return super.toJson()
      .set("id", id.toString())
      .set("name", name)
      .set("description", description)
      .set("domain", domain)
      .set("owner", owner)
      .set("created_at", createdAt.toISOExtString())
      .set("updated_at", updatedAt.toISOExtString())
      .set("settings", settings);
  }

  override string toString() {
    return "SAPTenant(id: " ~ id.toString() ~ ", name: " ~ name ~ ", domain: " ~ domain ~ ", owner: " ~ owner
      ~ ", createdAt: " ~ createdAt.toString() ~ ", updatedAt: " ~ updatedAt.toString() ~ ")";
  }
}
