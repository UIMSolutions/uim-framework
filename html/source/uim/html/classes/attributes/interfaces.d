/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.html.classes.attributes.interfaces;

import uim.html;

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