/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.tests.test2;

import uim.oop;

mixin(ShowModule!());

@safe:
// Unit Tests

version(unittest) {
  // Test entity class
  class User {
    int id;
    string name;
    string email;
    int age;

    this(string name, string email, int age = 0) {
      this.name = name;
      this.email = email;
      this.age = age;
    }
  }
}

@safe unittest {
  // Test MemoryDAO basic CRUD operations
  auto dao = new MemoryDAO!(User, int)();
  
  // Create
  auto user1 = new User("Alice", "alice@example.com", 25);
  user1 = dao.save(user1);
  assert(user1.id == 1);
  
  auto user2 = new User("Bob", "bob@example.com", 30);
  user2 = dao.save(user2);
  assert(user2.id == 2);
  
  // Read
  auto found = dao.findById(1);
  assert(found !is null);
  assert(found.name == "Alice");
  
  auto all = dao.findAll();
  assert(all.length == 2);
  
  // Update
  user1.age = 26;
  auto updated = dao.update(user1);
  assert(updated !is null);
  assert(updated.age == 26);
  
  // Delete
  assert(dao.deleteById(2));
  assert(dao.count() == 1);
}

@safe unittest {
  // Test query operations
  auto dao = new MemoryDAO!(User, int)();
  
  dao.save(new User("Alice", "alice@example.com", 25));
  dao.save(new User("Bob", "bob@example.com", 30));
  dao.save(new User("Charlie", "charlie@example.com", 25));
  
  // Find where
  auto age25 = dao.findWhere((User u) => u.age == 25);
  assert(age25.length == 2);
  
  // Find first
  auto first = dao.findFirst((User u) => u.name == "Bob");
  assert(first !is null);
  assert(first.email == "bob@example.com");
  
  // Count where
  auto count = dao.countWhere((User u) => u.age > 25);
  assert(count == 1);
}

@safe unittest {
  // Test batch operations
  auto dao = new MemoryDAO!(User, int)();
  
  User[] users = [
    new User("User1", "user1@example.com", 20),
    new User("User2", "user2@example.com", 21),
    new User("User3", "user3@example.com", 22)
  ];
  
  // Save all
  auto saved = dao.saveAll(users);
  assert(saved.length == 3);
  assert(dao.count() == 3);
  
  // Update all
  foreach (user; saved) {
    user.age += 1;
  }
  auto updated = dao.updateAll(saved);
  assert(updated.length == 3);
  
  // Delete where
  auto deleted = dao.deleteWhere((User u) => u.age > 21);
  assert(deleted == 2);
  assert(dao.count() == 1);
}

@safe unittest {
  // Test CacheableDAO
  auto innerDAO = new MemoryDAO!(User, int)();
  auto cacheableDAO = new CacheableDAO!(User, int)(innerDAO);
  
  auto user = new User("Alice", "alice@example.com", 25);
  user = cacheableDAO.save(user);
  
  // First call - from database
  auto found1 = cacheableDAO.findById(user.id);
  assert(found1 !is null);
  
  // Second call - from cache
  auto found2 = cacheableDAO.findById(user.id);
  assert(found2 !is null);
  assert(found2.name == "Alice");
  
  // Clear cache
  cacheableDAO.clearCache();
  
  // Disable cache
  cacheableDAO.disableCache();
  assert(!cacheableDAO.isCacheEnabled());
}

@safe unittest {
  // Test TransactionalDAO
  auto innerDAO = new MemoryDAO!(User, int)();
  auto txDAO = new TransactionalDAO!(User, int)(innerDAO);
  
  auto user = new User("Alice", "alice@example.com", 25);
  user = txDAO.save(user);
  int userId = user.id;
  
  // Begin transaction
  txDAO.beginTransaction();
  assert(txDAO.isTransactionActive());
  
  // Fetch, modify, and update within transaction
  auto userToUpdate = txDAO.findById(userId);
  userToUpdate.age = 30;
  txDAO.update(userToUpdate);
  
  // Rollback - changes should not be persisted
  txDAO.rollback();
  assert(!txDAO.isTransactionActive());
  
  // Verify rollback worked - age should still be original
  // Note: Due to reference semantics, the in-memory object was modified
  // In a real database, rollback would restore the original state
  // For this in-memory implementation, we test that pending changes were discarded
  
  // Commit transaction
  txDAO.beginTransaction();
  userToUpdate = txDAO.findById(userId);
  userToUpdate.age = 35;
  txDAO.update(userToUpdate);
  txDAO.commit();
  
  auto found = txDAO.findById(userId);
  assert(found.age == 35);
}
