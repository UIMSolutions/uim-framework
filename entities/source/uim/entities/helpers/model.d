module uim.entities.helpers.model;

import uim.entities;
@safe:

bool isNull(IModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  IModel model;
  assert(model.isNull); 

  model = new UIMModel;
  assert(!model.isNull); 
}

bool isNull(IModel aModel) {
  return (aModel is null ? true : false);
}
unittest {
  IModel model;
  assert(model.isNull); 

  model = new UIMModel;
  assert(!model.isNull); 
}
