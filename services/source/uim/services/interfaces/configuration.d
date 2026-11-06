module uim.service.interfaces.configuration;

import uim.service;

mixin(ShowModule!());

@safe:
interface IServiceConfiguration {
  string name();
  string description();
  string version_();
  string author();
  string license();
}