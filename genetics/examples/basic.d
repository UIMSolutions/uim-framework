/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module genetic_test;

import uim.genetic;
import vibe.d;
import std.stdio;

void main() {
    writeln("=== UIM Genetic Algorithm Test ===\n");

    // Test 1: Pattern matching
    writeln("Test 1: Pattern Matching GA");
    ubyte[] target = [1, 0, 1, 1, 0, 1, 0, 1, 1, 0];

    auto ga = new GeneticAlgorithm();
    ga.initializePopulation(50, target.length);
    ga.fitnessEvaluator(new SimplePatternMatcher(target));
    ga.maxGenerations(50);
    ga.selectionStrategy(new TournamentSelection(3));
    ga.crossoverOperator(new SinglePointCrossover(0.7));
    ga.mutationOperator(new BitFlipMutation(0.02));

    ga.runAsync((bool success, IIndividual best) {
        if (success) {
            writeln("Pattern matching complete!");
            writeln("  Best fitness: ", best.fitness());
            writeln("  Generations: ", ga.generation());
            auto stats = ga.statistics();
            writeln("  Final stats: ", stats.toString());
            writeln();
            
            // Run test 2
            test2();
        }
    });

    // Keep fiber alive for async operations
    sleep(5.seconds);
}

void test2() {
    writeln("Test 2: Numerical Optimization");
    
    auto evaluator = new NumericalOptimizer((double x) {
        // Optimize: -(x-0.5)^2, peaks at 0.5
        double diff = x - 0.5;
        return -(diff * diff);
    });

    auto ga = new GeneticAlgorithm();
    ga.initializePopulation(100, 16);
    ga.fitnessEvaluator(evaluator);
    ga.maxGenerations(100);
    ga.targetFitness(0.99);

    ga.runAsync((bool success, IIndividual best) {
        if (success) {
            writeln("Numerical optimization complete!");
            writeln("  Best fitness: ", best.fitness());
            writeln("  Generations: ", ga.generation());
            writeln("\nAll tests completed!");
        }
    });
}
