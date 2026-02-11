/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.interfaces.attribute;

import uim.html;

mixin(ShowModule!());

@safe:

interface IHtmlAttribute {
    // Getter / Setter for name
    string name();    
    IHtmlAttribute name(string value);
    
    // Getter / Setter for value
    string value();
    IHtmlAttribute value(string val);

    string toString();
}