module uim.entities.classes.elements.registry;

import uim.entities;

@safe:
class UIMElementRegistry : DRegistry!UIMElement {
  static UIMElementRegistry registry;
}
auto ElementRegistry() { // SIngleton
  if (UIMElementRegistry.registry is null) {
    UIMElementRegistry.registry = new UIMElementRegistry;
  }
  return UIMElementRegistry.registry;
}
