module uim.databases.classes.rows.row;

import uim.databases;
@safe:

/// Row represents a single database record with heterogeneous typed columns
alias Row = Json[string];

// Convenience functions for Row operations
Row createRow() @safe {
    return (Json[string]).init;
}

Row createRow(Json[string] data) @safe {
    return data.dup;
}