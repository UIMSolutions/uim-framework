module uim.service.mixins.entities.resource;

import uim.service;

mixin(ShowModule!());

@safe:

mixin template ResourceEntity(TId) {
    ResourceGroupId resourceGroupId; // required for multi-tenancy support
    TId id; // unique identifier for the entity
    UserId createdBy; // user who created the entity
    long createdAt; // timestamp of when the entity was created
    UserId updatedBy; // user who last updated the entity
    long updatedAt; // timestamp of when the entity was last updated

    // Helper method to check if the entity is new (i.e. has no ID assigned yet)
    bool isNull() const {
        return id.isNull;
    }

    void initEntity(ResourceGroupId resourceGroupId) {
        this.id = randomUUID();
        this.resourceGroupId = resourceGroupId;
        this.createdAt = Clock.currStdTime();
        this.updatedAt = createdAt;
    }

    void initEntity(ResourceGroupId resourceGroupId, UserId userId) {
        this.id = randomUUID();
        this.resourceGroupId = resourceGroupId;
        this.createdAt = Clock.currStdTime();
        this.createdBy = userId;
        this.updatedAt = this.createdAt;
        this.updatedBy = this.createdBy;
    }

    // Call this method when creating a new entity to initialize ID, resourceGroupId, and timestamps
    void createEntity(ResourceGroupId resourceGroupId) {
        id = randomUUID();
        this.resourceGroupId = resourceGroupId;
        createdAt = Clock.currStdTime();
        updatedAt = createdAt;
    }

    // Call this method when updating an existing entity to update timestamps
    void updateEntity(ResourceGroupId newResourceGroupId, TId newId) {
        id = newId;
        resourceGroupId = newResourceGroupId;
        updatedAt = Clock.currStdTime();
    }

    // Convert the entity to a JSON object, excluding internal fields like createdBy/createdAt
    Json entityToJson() const {
        return Json.emptyObject
            .set("id", id)
            .set("resourceGroupId", resourceGroupId)
            .set("createdBy", createdBy)
            .set("createdAt", createdAt)
            .set("updatedBy", updatedBy)
            .set("updatedAt", updatedAt);
    }
}
