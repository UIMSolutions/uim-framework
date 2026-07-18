module uim.services.interfaces.configuration;

import uim.services;

mixin(ShowModule!());

@safe:
interface IServiceConfiguration {
  string name();
  string description();
  string version_();
  string author();
  string license();
}