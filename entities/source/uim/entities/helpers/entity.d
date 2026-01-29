module uim.entities.helpers.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

bool isNull(UIMEntity anEntity) {
  return (anEntity is null ? true : false);
}
unittest {
  UIMEntity entity;
  assert(entity.isNull); 

  entity = new UIMEntity;
  assert(!entity.isNull); 
}

bool isNull(IEntity anEntity) {
  return (anEntity is null ? true : false);
}
unittest {
  IEntity entity;
  assert(entity.isNull); 

  entity = new UIMEntity;
  assert(!entity.isNull); 
}
