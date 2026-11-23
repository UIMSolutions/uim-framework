module uim.service.infrastructure.tests.repository;

import uim.service;

mixin(ShowModule!());

@safe:

bool testRepository() {
    return true;
}

bool tenantRepositoryTest(TEntity, TId)(ITenantRepository!(TEntity, TId) repo) {
    auto tenantId1 = TenantId("tenant1");
    auto tenantId2 = TenantId("tenant2");

    auto userId1 = UserId("user1");
    auto userId2 = UserId("user2");

    auto entity1 = TEntity(tenantId1, TId("entity1"), userId1);
    auto entity2 = TEntity(tenantId2, TId("entity2"), userId2);

    repo.save(entity1);
    repo.save(entity2);

    assert(repo.existsById(tenantId1, entity1.id));
    assert(repo.existsById(tenantId2, entity2.id));

    return true;
}