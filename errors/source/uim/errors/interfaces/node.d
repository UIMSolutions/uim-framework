/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.interfaces.node;

import uim.errors;
mixin(ShowModule!());
@safe:

// Interface for Error Nodes
// Provides methods to look at the contained value and iterate on child nodes in the error tree.
interface IErrorNode {
/*     string name();
    IErrorNode name(string name); */

    // Get the contained value.
    IErrorNode value();
    IErrorNode value(IErrorNode newValue);

    // Get the child nodes of this node.
    IErrorNode children(IErrorNode[] nodes);
    IErrorNode[] children();
}
