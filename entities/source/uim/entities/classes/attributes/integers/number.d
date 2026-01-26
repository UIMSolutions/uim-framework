/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.integers.number;

import uim.entities;

@safe:
class DNumberAttribute : DIntegerAttribute {
  mixin(AttributeThis!("NumberAttribute"));
}
mixin(AttributeCalls!("NumberAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DNumberAttribute);
    testAttribute(NumberAttribute);
  }
}