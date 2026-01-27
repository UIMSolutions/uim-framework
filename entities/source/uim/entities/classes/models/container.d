module uim.entities.classes.models.container;

import uim.entities;

@safe:
class DModelContainer  : DNamedContainer!IModel {
}
auto ModelContainer() { return new DModelContainer; }