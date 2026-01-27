module uim.entities.udas.maxlength;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * UDA to mark a field with maximum length validation
 */
struct MaxLength {
    size_t value;
    
    this(size_t len) {
        value = len;
    }
}