/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation;

import uim.service.mixins.imports;

// cli, gui and odata are opt-in (see uim.service)
public {
    mixin(GenerateImports!("uim.service.presentation", ["http", "web"]));
    import uim.service.presentation.tcp;
    import uim.service.presentation.unix;
}
