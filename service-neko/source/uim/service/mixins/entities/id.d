module uim.service.mixins.entities.id;

import uim.service;

mixin(ShowModule!());

@safe:

mixin template IdEntity(TId) {

    TId id; // unique identifier for the entity
    UserId createdBy; // user who created the entity
    long createdAt; // timestamp of when the entity was created
    UserId updatedBy; // user who last updated the entity
    long updatedAt; // timestamp of when the entity was last updated

    // Helper method to check if the entity is new (i.e. has no ID assigned yet)
    bool isNull() const {
        return id.isNull;
    }

    // Call this method when creating a new entity to initialize ID, tenantId, and timestamps
    void initEntity() {
        id = randomUUID();
        createdAt = Clock.currStdTime();
        updatedAt = createdAt;
    }

    void initEntity(UserId userId) {
        this.id = randomUUID();
        this.createdAt = Clock.currStdTime();
        this.createdBy = userId;
        this.updatedAt = this.createdAt;
        this.updatedBy = this.createdBy;
    }

    // Call this method when updating an existing entity to update timestamps
    void updateEntity(TId newId) {
        id = newId;
        updatedAt = Clock.currStdTime();
    }

    // Convert the entity to a JSON object, excluding internal fields like createdBy/createdAt
    Json entityToJson() const {
        return Json.emptyObject
            .set("id", id)
            .set("createdBy", createdBy)
            .set("createdAt", createdAt)
            .set("updatedBy", updatedBy)
            .set("updatedAt", updatedAt);
    }
}