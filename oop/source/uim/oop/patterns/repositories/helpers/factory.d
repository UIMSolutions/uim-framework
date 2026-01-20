module uim.oop.patterns.repositories.helpers.factory;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic repository factory.
 * /
class RepositoryFactory : UIMFactory!(string, IRepository) {
  /**
     * Create an in-memory repository.
     * /
  static MemoryRepository!(K,V) createInMemory(K, V)(K delegate(V) @safe keyExtractor) {
    return new MemoryRepository!(K, V)(keyExtractor);
  }

  /**
     * Create a specification repository.
     * /
  static SpecificationRepository!(K, V) createWithSpecification(K, V)(
    K delegate(V) @safe keyExtractor) {
    return new SpecificationRepository!(K, V)(keyExtractor);
  }
}
///
unittest {
  mixin(ShowTest!"Testing RepositoryFactory");

  class User {
    int id;
    string name;
  } 
  void testCreateInMemory() {
    auto repo = RepositoryFactory.createInMemory!(int, User)((u) => u.id);
    assert(repo !is null);
  }
  void testCreateWithSpecification() {
    auto repo = RepositoryFactory.createWithSpecification!(int, User)((u) => u.id);
    assert(repo !is null);
  
  }
} 

static this() {
  mixin(ShowInit!"Initializing RepositoryFactory module");

  
}
*/