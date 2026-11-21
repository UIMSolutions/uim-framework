/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// GtkD desktop adapter (opt-in: import uim.service.presentation.gui explicitly;
/// requires the gtk-d dependency and a GTK 3 runtime).
///
/// ---
/// return runEntityBrowser(engine, "default", "admin", args);
/// ---
module uim.service.presentation.gui;

version (Have_gtk_d) {
  public import uim.service.presentation.gui.browser;
}
