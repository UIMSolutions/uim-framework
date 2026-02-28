module uim.services.interfaces.configuration;

interface IServiceConfiguration {
  string name();
  string description();
  string version_();
  string author();
  string license();
}