module uim.oop.patterns.chains.interfaces.priority;

import uim.oop;
@safe:

/**
 * Priority-based handler interface.
 */
interface IPriorityHandler : IHandler {
    /**
     * Gets the handler priority.
     * Returns: The priority level (higher = processed first)
     */
    int priority() const;
}
