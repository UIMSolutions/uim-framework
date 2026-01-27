module uim.entities.udas.minlength;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * UDA to mark a field with minimum length validation
 */
struct MinLength {
    size_t value;
    
    this(size_t len) {
        value = len;
    }
}