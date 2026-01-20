/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.transferobjects.interfaces;

/**
 * Base interface for Transfer Objects (DTOs).
 * Transfer Objects are simple data containers used to transfer data between layers.
 */
interface ITransferObject {
  /**
   * Validate the transfer object data.
   * Returns: true if valid, false otherwise
   */
  bool validate() @safe;

  /**
   * Convert to associative array representation.
   */
  string[string] toMap() @safe;

  /**
   * Populate from associative array.
   */
  void fromMap(string[string] data) @safe;
}

/**
 * Interface for serializable transfer objects.
 */
interface ISerializableTransferObject : ITransferObject {
  /**
   * Serialize to JSON string.
   */
  string toJson() @safe;

  /**
   * Deserialize from JSON string.
   */
  void fromJson(string json) @trusted;
}

/**
 * Interface for transfer object assembler.
 * Converts between domain objects and transfer objects.
 */
interface ITransferObjectAssembler(TDomain, TTransfer) {
  /**
   * Convert domain object to transfer object.
   */
  TTransfer toTransferObject(TDomain domain) @safe;

  /**
   * Convert transfer object to domain object.
   */
  TDomain toDomainObject(TTransfer transfer) @safe;

  /**
   * Convert array of domain objects to transfer objects.
   */
  TTransfer[] toTransferObjects(TDomain[] domains) @safe;

  /**
   * Convert array of transfer objects to domain objects.
   */
  TDomain[] toDomainObjects(TTransfer[] transfers) @safe;
}

/**
 * Interface for composite transfer objects.
 */
interface ICompositeTransferObject : ITransferObject {
  /**
   * Get nested transfer objects.
   */
  ITransferObject[] getChildren() @safe;

  /**
   * Add a child transfer object.
   */
  void addChild(ITransferObject child) @safe;
}
