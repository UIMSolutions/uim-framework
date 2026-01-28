module uim.oop.patterns.mvc.controllers.async;

import uim.oop;

@safe:

/**
 * AsyncController - Controller with async operation support
 * 
 * Provides hooks for before/after action execution
 */
class AsyncController : Controller {
    alias BeforeAction = void delegate(string, string[string]) @safe;
    alias AfterAction = void delegate(string, string[string], string) @safe;

    protected BeforeAction[] _beforeActions;
    protected AfterAction[] _afterActions;

    this(IMVCModel model = null, IView view = null) {
        super(model, view);
    }

    /**
     * Registers a before action callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void before(BeforeAction callback) {
        _beforeActions ~= callback;
    }

    /**
     * Registers an after action callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void after(AfterAction callback) {
        _afterActions ~= callback;
    }

    /**
     * Executes action with before/after hooks
     * 
     * Params:
     *   action = The action name
     *   params = The parameters
     * 
     * Returns: The result
     */
    override string executeAction(string action, string[string] params = null) {
        // Execute before actions
        foreach (callback; _beforeActions) {
            callback(action, params);
        }

        // Execute the action
        auto result = super.executeAction(action, params);

        // Execute after actions
        foreach (callback; _afterActions) {
            callback(action, params, result);
        }

        return result;
    }
}
