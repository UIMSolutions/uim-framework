module uim.entities.udas.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * UDA to mark an entity class
 */
struct UseEntity {
    string tableName;
    
    this(string table) {
        tableName = table;
    }
}
