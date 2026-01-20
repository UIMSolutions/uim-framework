module uim.oop.patterns.bridges.interfaces;

/**
 * Implementor interface defines the interface for implementation classes.
 * This is the "implementation" side of the bridge.
 */
interface IImplementor {
    /**
     * Performs the actual implementation-specific operation.
     * Returns: A string describing the operation result.
     */
    string operationImpl() @safe;
}

/**
 * Abstraction interface defines the interface for the "abstraction" side.
 * It maintains a reference to an object of type IImplementor.
 */
interface IBridgeAbstraction {
    /**
     * Performs an operation using the implementor.
     * Returns: A string describing the operation result.
     */
    string operation();
    
    /**
     * Gets the current implementor.
     * Returns: The current IImplementor instance.
     */
    IImplementor implementor();
    
    /**
     * Sets a new implementor.
     * Params:
     *   impl = The new IImplementor instance to use.
     */
    void implementor(IImplementor impl);
}

/**
 * Extended abstraction interface for more complex operations.
 */
interface IExtendedAbstraction : IBridgeAbstraction {
    /**
     * Performs an extended operation using the implementor.
     * Returns: A string describing the extended operation result.
     */
    string extendedOperation();
}

/**
 * Generic implementor interface for type-specific implementations.
 */
interface IGenericImplementor(T) {
    /**
     * Processes data of type T.
     * Params:
     *   data = The data to process.
     * Returns: The processed result.
     */
    T process(T data);
    
    /**
     * Gets the name of this implementor.
     * Returns: The implementor name.
     */
    string name();
}

/**
 * Generic abstraction interface that works with generic implementors.
 */
interface IGenericAbstraction(T) {
    /**
     * Executes an operation with the given data.
     * Params:
     *   data = The data to process.
     * Returns: The processed result.
     */
    T execute(T data);
    
    /**
     * Gets the current implementor.
     * Returns: The current generic implementor.
     */
    IGenericImplementor!T implementor();
    
    /**
     * Sets a new implementor.
     * Params:
     *   impl = The new implementor to use.
     */
    void implementor(IGenericImplementor!T impl);
}
