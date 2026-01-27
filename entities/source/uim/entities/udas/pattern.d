module uim.entities.udas.pattern;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * UDA to mark a field with pattern validation (regex)
 */
struct Pattern {
    string regex;
    
    this(string pattern) {
        regex = pattern;
    }
}