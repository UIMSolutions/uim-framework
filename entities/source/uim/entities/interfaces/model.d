module uim.entities.interfaces.model;

import uim.entities;
@safe:

interface IModel {
  IModelManager manager();
  
  string registerPath();
  IModel registerPath(string path);


  IModel create();
  IModel copy(); 
}