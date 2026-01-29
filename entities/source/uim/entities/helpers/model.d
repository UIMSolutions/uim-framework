module uim.entities.helpers.model;

import uim.entities;

mixin(ShowModule!());

@safe:

bool isNull(IModel model) {
  return (model is null ? true : false);
}
unittest {
  IModel model;
  assert(model.isNull); 

  model = new UIMModel;
  assert(!model.isNull); 
}

