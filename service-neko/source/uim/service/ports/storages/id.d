/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.ports.storages.id;

import uim.service;

mixin(ShowModule!());

@safe:
interface IIdStore(TEntity, TId) : IEntityStore!(TEntity) {

    size_t countAll();
    TEntity[] findAll(size_t offset = 0, size_t limit = 0);
    void removeAll();

    bool existsById(TId id);
    TEntity findById(TId id);
    void saveById(TId id);
    void updateById(TId id);
    void removeById(TId id);

}
