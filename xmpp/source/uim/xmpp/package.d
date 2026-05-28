/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp;

import vibe.d;

mixin(ShowModule!());

public {
  import uim.core;
  import uim.oop;
}

public {
  import uim.xmpp.helpers;
  import uim.xmpp.interfaces;
}

public {
  import uim.xmpp.stanza;
  import uim.xmpp.client;
  import uim.xmpp.transport;
}
