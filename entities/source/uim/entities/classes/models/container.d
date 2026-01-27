module uim.entities.classes.container;

import uim.entities;

@safe:
class DModelContainer  : DNamedContainer!IModel {
}
auto ModelContainer() { return new DModelContainer; }