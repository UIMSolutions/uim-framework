module uim.service.ports.repositories.id;

import uim.service;

mixin(ShowModule!());

@safe:

interface IIdRepository(TEntity, TId) : IBaseRepository!(TEntity) {

  // #region byId
  bool existsById(TId id);
  TEntity findById(TId id);
  void removeById(TId id);

  bool existsAllById(TId[] ids);
  TEntity[] findAllById(TId[] ids, bool onlyExisting = true);
  void removeAllById(TId[] ids);
  // #endregion byId
  
}
