/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.htmls.classes.elements.h;

import uim.htmls;

@safe:

/// HTML heading element (h1-h6)
class DH : DHtmlElement {
    this(int level) {
        import std.conv : to;
        super("h" ~ level.to!string);
    }
}

auto H1() { return new DH(1); }
auto H1(string content) { auto element = new DH(1); element.text(content); return element; }

auto H2() { return new DH(2); }
auto H2(string content) { auto element = new DH(2); element.text(content); return element; }

auto H3() { return new DH(3); }
auto H3(string content) { auto element = new DH(3); element.text(content); return element; }

auto H4() { return new DH(4); }
auto H4(string content) { auto element = new DH(4); element.text(content); return element; }

auto H5() { return new DH(5); }
auto H5(string content) { auto element = new DH(5); element.text(content); return element; }

auto H6() { return new DH(6); }
auto H6(string content) { auto element = new DH(6); element.text(content); return element; }

unittest {
    auto h1 = H1("Title");
    assert(h1.toString() == "<h1>Title</h1>");
}
