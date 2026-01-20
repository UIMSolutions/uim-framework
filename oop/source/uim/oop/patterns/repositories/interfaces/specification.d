module uim.oop.patterns.repositories.interfaces.specification;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Specification interface for querying repositories.
 * Used with Specification pattern for complex queries.
 */
interface ISpecification(V) {
  /**
     * Check if an value satisfies the specification.
     */
  bool isSatisfiedBy(V value);
}

/**
 * Extended repository interface with specification support.
 */
interface ISpecificationRepository(V, K) : IRepository!(K, V) {
  /**
     * Find values that satisfy a specification.
     */
  V[] find(ISpecification!V spec);
  /**
     * Find first value that satisfies a specification.
     */
  V findOne(ISpecification!V spec);
  /**
     * Count values that satisfy a specification.
     */
  size_t count(ISpecification!V spec);
}
