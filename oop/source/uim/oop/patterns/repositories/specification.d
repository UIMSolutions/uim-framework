module uim.oop.patterns.repositories.specification;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Repository with specification support.
 * /
class SpecificationRepository(K, V) : MemoryRepository!(K, V), ISpecificationRepository!(K, V) {
  /**
     * Constructor.
     * /
  this(K delegate(V) @safe idExtractor) {
    super(idExtractor);
  }

  /**
     * Find entities that satisfy a specification.
     * /
  V[] find(ISpecification!V spec) {
    import std.algorithm : filter;
    import std.array : array;

    return _entities.values.filter!(e => spec.isSatisfiedBy(e)).array;
  }

  /**
     * Find first entity that satisfies a specification.
     * /
  V findOne(ISpecification!V spec) {
    foreach (value; _entities.values) {
      if (spec.isSatisfiedBy(value)) {
        return value;
      }
    }
    return V.init;
  }

  /**
     * Count entities that satisfy a specification.
     * /
  size_t count(ISpecification!V spec) {
    import std.algorithm : count, filter;

    return _entities.values.filter!(e => spec.isSatisfiedBy(e)).count;
  }
}





unittest {
  mixin(ShowTest!"Testing SpecificationRepository");

  class Product {
    int id;
    string name;
    double price;

    this(int id, string name, double price) {
      this.id = id;
      this.name = name;
      this.price = price;
    }
  }

  // Price specification
  class PriceRangeSpec : ISpecification!Product {
    private double _min;
    private double _max;

    this(double min, double max) {
      _min = min;
      _max = max;
    }

    bool isSatisfiedBy(Product product) {
      return product.price >= _min && product.price <= _max;
    }
  }

  auto repo = new SpecificationRepository!(int, Product)((Product p) => p.id);

  // Add products
  repo.add(new Product(1, "Cheap Item", 10.0));
  repo.add(new Product(2, "Mid Item", 50.0));
  repo.add(new Product(3, "Expensive Item", 150.0));

  // Find products in price range
  auto midRange = new PriceRangeSpec(20.0, 100.0);
  auto results = repo.find(midRange);
  assert(results.length == 1);
  assert(results[0].name == "Mid Item");

  // Count products
  auto expensiveSpec = new PriceRangeSpec(100.0, 200.0);
  assert(repo.count(expensiveSpec) == 1);

  // Find one
  auto cheapSpec = new PriceRangeSpec(0.0, 20.0);
  auto cheap = repo.findOne(cheapSpec);
  assert(cheap !is null);
  assert(cheap.name == "Cheap Item");
} */