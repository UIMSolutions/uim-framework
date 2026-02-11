/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.interfaces.input;

import uim.html;

mixin(ShowModule!());

@safe:

// Represents an HTML <input> element, which is a form element that allows users to enter data. 
interface IInput : IFormElement {
    IHtmlAttribute type();
    IInput type(string typeValue);
}