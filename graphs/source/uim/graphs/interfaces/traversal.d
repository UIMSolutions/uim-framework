/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.graphs.interfaces.traversal;

import uim.graphs.interfaces.node;

enum TraversalOrder {
    BreadthFirst,
    DepthFirst,
    PreOrder,
    PostOrder
}

interface ITraversal {
    /// Visit node with optional visitor callback
    void visit(INode node, scope void delegate(INode) @safe visitor = null) @safe;
    
    /// Get traversal order
    @property TraversalOrder order() const @safe;
}
