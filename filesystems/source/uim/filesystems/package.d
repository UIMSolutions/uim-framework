/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems;

public {
    import uim.core;
    import uim.oop;
    import uim.logging;

    import uim.filesystems.classes;
    import uim.filesystems.async_;
}

// Main function for unit testing
version (unittest) {
    void main() {
        import std.stdio : writeln;
        writeln("UIM Filesystems Library Unit Tests");
    }
}
