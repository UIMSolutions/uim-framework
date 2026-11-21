/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.ports.repositories.repository;

import uim.service;

mixin(ShowModule!());

@safe:

interface IBaseRepository(TEntity) {
  bool exists(TEntity entity);
  // TODO: bool existsAll(TEntity[] entities);
  // TODO: bool existsAny(TEntity[] entities);


  size_t countAll();
  TEntity[] findAll(size_t offset = 0, size_t limit = 0);
  void removeAll();

  void save(TEntity entity);
  void update(TEntity entity);
  void remove(TEntity entity);

  void updateAll(TEntity[] entities);
  void saveAll(TEntity[] entities);
  void removeAll(TEntity[] entities);
}


