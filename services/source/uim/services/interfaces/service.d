module uim.services.interfaces.service;

import uim.services;

mixin(ShowModule!());

@safe:
interface IService {
  void start();
  void stop();
}