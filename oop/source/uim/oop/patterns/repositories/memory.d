module uim.oop.patterns.repositories.memory;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * In-memory repository implementation.
 * Stores entities in memory using their K as key.
 */
class MemoryRepository(K, V) : IRepository!(K, V) {
    private V[K] _entities;
    private K delegate(V) @safe _keyExtractor;

    /**
     * Constructor.
     * Params:
     *   keyExtractor = Function to extract K from value
     */
    this(K delegate(V) @safe keyExtractor) {
        _keyExtractor = keyExtractor;
    }

    /**
     * Add a new value to the repository.
     */
    void add(V value) {
        auto id = _keyExtractor(value);
        _entities[id] = value;
    }

    /**
     * Update an existing value in the repository.
     */
    void update(V value) {
        auto id = _keyExtractor(value);
        if (id in _entities) {
            _entities[id] = value;
        }
    }

    /**
     * Remove an value from the repository.
     */
    void remove(V value) {
        auto id = _keyExtractor(value);
        _entities.remove(id);
    }

    /**
     * Remove an value by its K.
     */
    bool removeById(K key) {
        if (key in _entities) {
            _entities.remove(key);
            return true;
        }
        return false;
    }

    /**
     * Find an value by its K.
     */
    V findById(K key) {
        if (auto value = key in _entities) {
            return *value;
        }
        return V.init;
    }

    /**
     * Get all entities in the repository.
     */
    V[] findAll() {
        return _entities.values;
    }

    /**
     * Check if an value with the given K exists.
     */
    bool exists(K key) {
        return (key in _entities) !is null;
    }

    /**
     * Get the total count of entities.
     */
    size_t count() {
        return _entities.length;
    }

    /**
     * Clear all entities from the repository.
     */
    void clear() {
        _entities.clear();
    }
}
///
unittest {
  mixin(ShowTest!"Testing MemoryRepository");

  class User {
    int id;
    string name;
    int age;

    this(int id, string name, int age) {
      this.id = id;
      this.name = name;
      this.age = age;
    }
  }

  auto repo = new MemoryRepository!(int, User)((User u) => u.id);

  // Test add
  auto user1 = new User(1, "Alice", 30);
  auto user2 = new User(2, "Bob", 25);
  repo.add(user1);
  repo.add(user2);
  assert(repo.count() == 2);

  // Test findById
  auto found = repo.findById(1);
  assert(found !is null);
  assert(found.name == "Alice");

  // Test exists
  assert(repo.exists(1));
  assert(repo.exists(2));
  assert(!repo.exists(999));

  // Test findAll
  auto all = repo.findAll();
  assert(all.length == 2);

  // Test update
  user1.name = "Alice Updated";
  repo.update(user1);
  auto updated = repo.findById(1);
  assert(updated.name == "Alice Updated");

  // Test removeById
  assert(repo.removeById(2));
  assert(repo.count() == 1);
  assert(!repo.exists(2));

  // Test remove
  repo.remove(user1);
  assert(repo.count() == 0);
  assert(!repo.exists(1));

  // Test clear
  repo.add(new User(3, "Charlie", 35));
  repo.add(new User(4, "Diana", 28));
  assert(repo.count() == 2);
  repo.clear();
  assert(repo.count() == 0);
}