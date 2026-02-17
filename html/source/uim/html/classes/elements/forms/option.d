/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.forms.option;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * Represents an HTML <option> element.
  * Provides methods to set option attributes like value, selected, and disabled.
  * Example usage:
  * auto option = H5SelectOption("Option 1").value("1").selected();
  */
class H5SelectOption : H5FormElement {
    mixin H5This!("option", false);

    H5SelectOption value(string valueValue) {
        attribute("value", valueValue);
        return this;
    }

    H5SelectOption selected() {
        attribute("selected", "");
        return this;
    }

    H5SelectOption disabled() {
        attribute("disabled", "");
        return this;
    }

    mixin(H5Calls!("SelectOption"));
}
///
unittest {
    mixin(ShowTest!"Testing SelectOption Class");

    assert(H5SelectOption() == `<option></option>`);
    assert(H5SelectOption("Option 1") == `<option>Option 1</option>`);
    assert(H5SelectOption().value("1") == `<option value="1"></option>`);
    assert(H5SelectOption().selected() == `<option selected=""></option>`);
    assert(H5SelectOption().disabled() == `<option disabled=""></option>`);
}