/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Generic command line adapter (opt-in: import uim.service.presentation.cli explicitly).
///
/// ---
/// auto app = new CliApplication("uim-demo-cli", "Demo service administration");
/// registerEntityCommands(app, engine);   // list/get/create/update/delete/invoke for every entity set
/// return app.run(argv[1 .. $]);
/// ---
module uim.service.presentation.cli;

public {
  import uim.service.presentation.cli.args;
  import uim.service.presentation.cli.table;
  import uim.service.presentation.cli.app;
  import uim.service.presentation.cli.entities;
}
