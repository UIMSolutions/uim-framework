/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Command line interface.
///
///   dub run --config=cli -- help
///   dub run --config=cli -- list Products --filter="price gt 10" --orderby="name"
module cli;

import uim.service;
import uim.service.presentation.cli;
import uim.catalog.infrastructure.bootstrap;

version (unittest) {
} else {
  int main(string[] argv) {
    // storage options must be known before the engine is built
    auto pre = CliArgs.parse(argv[1 .. $]);
    string[string] overrides;
    if (pre.has("data-file")) {
      overrides["storage"] = "file";
      overrides["dataFile"] = pre.opt("data-file");
    }
    if (pre.has("storage"))
      overrides["storage"] = pre.opt("storage");

    auto runtime = bootstrapCatalog(catalogConfig(overrides));
    auto app = new CliApplication("uim-catalog-cli", "Product catalog administration");
    app.defaultTenant = runtime.config["defaultTenant"].get!string;
    app.defaultUser = "cli";
    app.globalOption("tenant", "<id>", "tenant to operate on (default: " ~ app.defaultTenant ~ ")");
    app.globalOption("storage", "memory|file", "storage backend (default: config)");
    app.globalOption("data-file", "<path>", "JSON snapshot shared with server and GUI");

    registerEntityCommands(app, runtime.engine);
    app.command("config", "", "Show the effective configuration", (CliContext c) {
      auto cfg = runtime.config.clone;
      if ("jwtSecret" in cfg && cfg["jwtSecret"].get!string.length)
        cfg["jwtSecret"] = "***";
      c.print(cfg.toPrettyString ~ "\n");
      return 0;
    }, []);
    return app.run(argv[1 .. $]);
  }
}
