# UIM Genetic Algorithms Library

A high-performance, type-safe genetic algorithm framework for D language with full vibe.d async/await support. Designed for building evolutionary computation systems, optimization algorithms, and machine learning applications.

## Features

- **Type-Safe Interfaces**: Compile-time contract enforcement for all GA components
- **Async-First**: Built on vibe.d for non-blocking, scalable operations
- **Modular Architecture**: Pluggable selection, crossover, and mutation strategies
- **Multiple Selection Strategies**: Roulette wheel, tournament, rank-based selection
- **Flexible Crossover**: Single-point and two-point crossover operators
- **Advanced Mutations**: Bit-flip, Gaussian, and swap mutation operators
- **Fitness Evaluation**: Async parallel evaluation support
- **Population Management**: Efficient population tracking with statistics
- **Serialization**: JSON serialization/deserialization for individuals
- **Extensible Design**: Create custom fitness evaluators, operators, and strategies

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:genetic-algorithms" version="*"
```

## Quick Start

### Basic Example: Evolving a Pattern

```d
import uim.genetic;
import vibe.d;

void main() {
    // Define target pattern to evolve
    ubyte[] target = [1, 0, 1, 1, 0, 1, 0, 1];

    // Create algorithm
    auto ga = new GeneticAlgorithm();
    ga.initializePopulation(50, 8);
    ga.fitnessEvaluator(new SimplePatternMatcher(target));
    ga.maxGenerations(100);

    // Run evolution
    ga.runAsync((bool success, IIndividual best) @safe {
        if (success) {
            writeln("Best solution found:");
            writeln("Fitness: ", best.fitness());
            writeln("Generations: ", ga.generation());
        }
    });
}
```

### Example: Numerical Optimization

```d
import uim.genetic;

void main() {
    // Optimize a mathematical function
    auto evaluator = new NumericalOptimizer((double x) @safe {
        return -(x - 0.5) * (x - 0.5); // Peak at x=0.5
    });

    auto ga = new GeneticAlgorithm();
    ga.initializePopulation(100, 16);
    ga.fitnessEvaluator(evaluator);
    ga.maxGenerations(50);
    ga.targetFitness(0.99);

    ga.runAsync((bool success, IIndividual best) @safe {
        if (success) {
            writeln("Optimization complete!");
            writeln("Best fitness: ", best.fitness());
        }
    });
}
```

## Architecture

### Core Interfaces

- **IIndividual**: Represents a solution candidate with genome and fitness
- **IPopulation**: Manages collection of individuals with statistics
- **IFitnessEvaluator**: Evaluates individual quality asynchronously
- **ISelectionStrategy**: Selects parents for reproduction
- **ICrossoverOperator**: Creates offspring from parents
- **IMutationOperator**: Introduces random variation

### Base Classes

- **Individual**: Default individual implementation with genome storage
- **Population**: Population container with best/worst/average tracking
- **GeneticAlgorithm**: Main algorithm orchestrator with async support

### Operators

**Selection Strategies:**
- `RouletteWheelSelection`: Probability-weighted selection
- `TournamentSelection`: Competitive tournament selection
- `RankSelection`: Rank-based probability selection

**Crossover Operators:**
- `SinglePointCrossover`: Single crossover point
- `TwoPointCrossover`: Two crossover points

**Mutation Operators:**
- `BitFlipMutation`: Flip individual bits in genome
- `GaussianMutation`: Add Gaussian noise to genes
- `SwapMutation`: Swap genome segments

## Configuration

```d
auto ga = new GeneticAlgorithm();

// Set population
ga.population(new Population());

// Set operators
ga.selectionStrategy(new TournamentSelection(5));
ga.crossoverOperator(new TwoPointCrossover(0.8));
ga.mutationOperator(new BitFlipMutation(0.02));

// Set parameters
ga.maxGenerations(200);
ga.targetFitness(0.95);
```

## Async Operations

All intensive operations run asynchronously:

```d
ga.runAsync((bool success, IIndividual best) @safe {
    if (success) {
        // Access results in callback
        writeln("Converged after ", ga.generation(), " generations");
        writeln("Best fitness: ", best.fitness());
    }
});

// Main fiber continues unblocked
writeln("Algorithm running in background...");
```

## Statistics

```d
auto stats = ga.statistics();
writeln("Generation: ", stats["generation"].get!long);
writeln("Population size: ", stats["size"].get!long);
writeln("Best fitness: ", stats["best"].get!double);
writeln("Average fitness: ", stats["average"].get!double);
```

## Custom Fitness Evaluator

```d
class MyEvaluator : IFitnessEvaluator {
    override void evaluate(IIndividual individual,
        void delegate(double fitness) @safe callback) @trusted {
        
        // Your evaluation logic here
        double fitness = calculateFitness(individual);
        callback(fitness);
    }

    override void evaluatePopulation(IIndividual[] individuals,
        void delegate(IIndividual[]) @safe callback) @trusted {
        
        // Optional: parallel evaluation for performance
        foreach (ind; individuals) {
            evaluate(ind, (double fit) @safe {
                ind.fitness(fit);
            });
        }
        callback(individuals);
    }
}
```

## Design Patterns

- **Strategy Pattern**: Pluggable selection, crossover, mutation strategies
- **Template Method**: GeneticAlgorithm provides overall algorithm structure
- **Factory Pattern**: Individual and population creation
- **Callback Pattern**: Async operations via delegates
- **Observer Pattern**: Population statistics tracking

## Performance Considerations

- Genome size should be reasonable (8-128 bytes typical)
- Large populations benefit from async evaluation
- Selection strategy impacts convergence speed
- Mutation rate affects exploration vs exploitation balance
- Elitism preserves best solutions between generations

## Testing

```bash
cd genetic-algorithms
dub test
```

## Notes

- **Type Safety**: All interfaces enforce correct implementation
- **Memory Efficiency**: Genomes stored as byte arrays
- **Async-Ready**: Integrates with vibe.d fiber-based concurrency
- **Extensible**: Implement interfaces for custom components
- **JSON Support**: Serialize individuals for persistence or communication

This library provides everything needed to build sophisticated genetic algorithm applications in D with modern async patterns and type safety.
