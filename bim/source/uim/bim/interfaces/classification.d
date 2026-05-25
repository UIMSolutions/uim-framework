/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.classification;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimClassification - Interface for classification reference (IfcClassificationReference).
 * Supports standard classification systems such as Uniclass 2015, OmniClass, MasterFormat,
 * UniFormat, ETIM, and custom schemes.
 */
interface IBimClassification {
  string system();
  IBimClassification system(string value);

  string edition();
  IBimClassification edition(string value);

  string code();
  IBimClassification code(string value);

  string label();
  IBimClassification label(string value);

  string location();
  IBimClassification location(string value);

  Json toJson();
  IBimClassification fromJson(Json data);
}
