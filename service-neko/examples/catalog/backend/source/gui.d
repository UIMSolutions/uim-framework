/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// GtkD desktop GUI.
///
///   dub run --config=gui -- [--tenant=<id>] [--data-file=<path>] [--refresh=<seconds>]
module gui;

import uim.service;
import uim.service.presentation.cli : CliArgs;
import uim.service.presentation.gui;
import uim.catalog.infrastructure.bootstrap;

version (unittest) {
} else {
  int main(string[] argv) {
    auto a = CliArgs.parse(argv[1 .. $]);
    string[string] overrides;
    if (a.has("data-file")) {
      overrides["storage"] = "file";
      overrides["dataFile"] = a.opt("data-file");
    }
    if (a.has("storage"))
      overrides["storage"] = a.opt("storage");
    auto runtime = bootstrapCatalog(catalogConfig(overrides));
    auto tenant = a.opt("tenant", runtime.config["defaultTenant"].get!string);
    auto refresh = cast(uint) a.intOpt("refresh", runtime.config["storage"].get!string == "file" ? 10 : 0);
    return runEntityBrowser(runtime.engine, tenant, a.opt("user", "gui"), argv[0 .. 1], refresh);
  }
}
