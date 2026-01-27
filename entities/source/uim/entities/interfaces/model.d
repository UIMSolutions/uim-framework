module uim.entities.interfaces.model;

import uim.entities;
@safe:

interface IModel {
  IModelManager manager();
  
  string registerPath();

  DModel create();
  DModel copy(); 
}