/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.strategies.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base strategy interface.
 * Defines the contract for all concrete strategies.
 */
interface IStrategy {
  /**
   * Execute the strategy algorithm.
   * Returns: Result of the strategy execution
   */
  string execute();
}

/**
 * Generic strategy interface with input and output types.
 */
interface IGenericStrategy(TInput, TOutput) {
  /**
   * Execute the strategy with input data.
   * Params:
   *   input = The input data for the strategy
   * Returns: The result of the strategy execution
   */
  TOutput execute(TInput input);
}

/**
 * Strategy interface with multiple parameters.
 */
interface IParameterizedStrategy(TOutput, TParams...) {
  /**
   * Execute the strategy with multiple parameters.
   * Params:
   *   params = Variable number of parameters
   * Returns: The result of the strategy execution
   */
  TOutput execute(TParams params);
}

/**
 * Sorting strategy interface.
 */
interface ISortStrategy(T) {
  /**
   * Sort an array using the strategy's algorithm.
   * Params:
   *   data = The array to sort
   * Returns: The sorted array
   */
  T[] sort(T[] data);
}

/**
 * Validation strategy interface.
 */
interface IValidationStrategy(T) {
  /**
   * Validate data using the strategy's rules.
   * Params:
   *   data = The data to validate
   * Returns: true if valid, false otherwise
   */
  bool validate(T data);

  /**
   * Get validation error message.
   * Returns: Error message if validation failed
   */
  string errorMessage();
}

/**
 * Compression strategy interface.
 */
interface ICompressionStrategy {
  /**
   * Compress data.
   * Params:
   *   data = The data to compress
   * Returns: Compressed data
   */
  ubyte[] compress(ubyte[] data);

  /**
   * Decompress data.
   * Params:
   *   data = The data to decompress
   * Returns: Decompressed data
   */
  ubyte[] decompress(ubyte[] data);

  /**
   * Get compression algorithm name.
   * Returns: The name of the compression algorithm
   */
  string algorithmName();
}

/**
 * Payment strategy interface.
 */
interface IPaymentStrategy {
  /**
   * Process a payment.
   * Params:
   *   amount = The amount to charge
   * Returns: true if payment successful
   */
  bool pay(double amount);

  /**
   * Get payment method name.
   * Returns: The name of the payment method
   */
  string paymentMethod();
}
