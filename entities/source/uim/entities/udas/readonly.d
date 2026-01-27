module uim.entities.udas.readonly;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * UDA to mark a field as readonly (cannot be modified after creation)
 */
struct ReadOnly {
}
