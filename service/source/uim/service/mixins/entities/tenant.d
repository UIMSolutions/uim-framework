/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.entities.tenant;

import uim.service;

mixin(ShowModule!());

@safe:

mixin template TenantEntity(TId) {
  TenantId tenantId; // required for multi-tenancy support
  TId id; // unique identifier for the entity
  
  UserId createdBy; // user who created the entity
  long createdAt; // timestamp of when the entity was created
  UserId updatedBy; // user who last updated the entity
  long updatedAt; // timestamp of when the entity was last updated

  this(TenantId tenantId) {
    this.tenantId = tenantId;
    this.id = TId(generateId);
    this.createdAt = Clock.currStdTime();
    this.updatedAt = createdAt;
  }

  this(TenantId tenantId, TId id) {
    this(tenantId);
    this.id = id;
  }

  this(TenantId tenantId, TId id, UserId byUser) {
    this(tenantId, id);
    this.createdBy = byUser;
    this.updatedBy = byUser;
  }

  // Helper method to check if the entity is new (i.e. has no ID assigned yet)
  bool isNull() const {
    return id.value.length == 0;
  }

  // void initEntity() {
  //   this.id = randomUUID().toString;
  //   this.createdAt = Clock.currStdTime();
  //   this.updatedAt = createdAt;
  // }

  // void initEntity(TenantId tenantId) {
  //   this.id = randomUUID().toString;
  //   this.tenantId = tenantId;
  //   this.createdAt = Clock.currStdTime();
  //   this.updatedAt = createdAt;
  // }

  // void initEntity(TenantId tenantId, TId id) {
  //   initEntity(tenantId);
  //   this.id = id;
  // }

  // void initEntity(TenantId tenantId, TId id, UserId byUser) {
  //   initEntity(tenantId, id);
  //   this.createdBy = byUser;
  //   this.updatedBy = this.createdBy;
  // }

  // Call this method when creating a new entity to initialize ID, tenantId, and timestamps
  void createEntity(TenantId tenantId) {
    id = randomUUID().toString;
    this.tenantId = tenantId;
    createdAt = Clock.currStdTime();
    updatedAt = createdAt;
  }

  // Call this method when updating an existing entity to update timestamps
  void update() {
    updatedAt = Clock.currStdTime();
  }

  void update(UserId updateUser) {
    updatedAt = Clock.currStdTime();
    updatedBy = updateUser;
  }

  // Convert the entity to a JSON object, excluding internal fields like createdBy/createdAt
  Json entityToJson() const {
    return Json.emptyObject
      .set("id", id)
      .set("tenantId", tenantId)
      .set("createdBy", createdBy)
      .set("createdAt", createdAt)
      .set("updatedBy", updatedBy)
      .set("updatedAt", updatedAt);
  }

  Json entityFromJson(Json src) {
    if (!src.isObject) {
      throw new JSONException("Expected JSON object for TenantEntity");
    }
    id = src.getString("id");
    tenantId = TenantId(src.getString("tenantId"));
    createdBy = UserId(src.getString("createdBy"));
    createdAt = src.getLong("createdAt");
    updatedBy = UserId(src.getString("updatedBy"));
    updatedAt = src.getLong("updatedAt");
    return src;
  }

  // bool opEquals(ref const TId) const {
  //   return this.id == id;
  // }

  //    bool opEquals(string anId) const {
  //        return this.id.value == anId;
  //    }


}
///
unittest {
  struct TestId {
    mixin(IdStringTemplate);
  }

  struct TestEntity {
    mixin TenantEntity!TestId;

    string name;
    string description;

    // this(TenantId tenantId, TestId id, UserId byUser, string name, string description) {
    //   initEntity(tenantId, id, byUser);
    //   this.name = name;
    //   this.description = description;
    // }
  }

  auto tenantId = TenantId("tenant1");
  auto entity = TestEntity(tenantId);
  entity.id = TestId("entity1");
  entity.createdBy = UserId("user1");
  entity.updatedBy = UserId("user1");
  entity.name = "Test Entity";
  entity.description = "This is a test entity.";

  assert(entity.id.value == "entity1");
  assert(entity.tenantId == tenantId);
  assert(entity.createdBy.value == "user1");
  assert(entity.updatedBy.value == "user1");
  assert(entity.name == "Test Entity");
  assert(entity.description == "This is a test entity.");

  auto json = entity.entityToJson();
  assert(json.getString("id") == "entity1");
  assert(json.getString("tenantId") == "tenant1");
  assert(json.getString("createdBy") == "user1");
  assert(json.getLong("createdAt") > 0);
  assert(json.getString("updatedBy") == "user1");
  assert(json.getLong("updatedAt") > 0);
}
