module uim.services.infrastructure.persistence.tests.store;

import uim.services;

mixin(ShowModule!());

@safe:

void testStore(TEntity, TId)(IStore!(TEntity, TId) store, TEntity[] entities) {
    entities.each!((index, entity) {
        // Test save
        auto result = store.save(entity);
        assert(result.success);
        assert(store.exists(entity));
        assert(store.exists(entity.id));
    });

    assert(store.count() == 2); //
    
    // Test entities
    auto storeEntities = store.entities();
    assert(storeEntities.length == 2); // Test update
    
    storeEntities[0].name = "Updated Entity 0";
    auto updateResult = store.update(storeEntities[0]);
    assert(updateResult.success); 
    
    // Test remove
    storeEntities.each!((entity) {
        auto removeResult = store.remove(entity);
        assert(removeResult.success);
        assert(!store.exists(entity));
    });
}
