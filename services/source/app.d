module app;

import std.process : environment;

import uim.services;

@safe:

void main() {
  auto cfg = serviceApiConfigFromEnv();

  auto serviceConfig = new ServiceConfiguration(
    environment.get("SERVICE_NAME", "uim-services"),
    environment.get("SERVICE_DESCRIPTION", "UIM service API"),
    environment.get("SERVICE_VERSION", "1.0.0"),
    environment.get("SERVICE_AUTHOR", "UIM Solutions"),
    environment.get("SERVICE_LICENSE", "Apache-2.0")
  );

  auto service = new UIMService(serviceConfig);
  serveServiceApi(service, cfg);
}
