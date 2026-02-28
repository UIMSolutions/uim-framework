module uim.services.classes.configuration;

import uim.services.interfaces.configuration;

@safe:

class ServiceConfiguration : IServiceConfiguration {
  private string name_;
  private string description_;
  private string versionValue;
  private string author_;
  private string license_;

  this() {
    this("uim-services", "UIM service", "1.0.0", "UIM Solutions", "Apache-2.0");
  }

  this(string name, string description, string version_, string author, string license) {
    name_ = name;
    description_ = description;
    versionValue = version_;
    author_ = author;
    license_ = license;
  }

  @property string name() const nothrow {
    return name_;
  }

  @property string description() const nothrow {
    return description_;
  }

  @property string version_() const nothrow {
    return versionValue;
  }

  @property string author() const nothrow {
    return author_;
  }

  @property string license() const nothrow {
    return license_;
  }
}