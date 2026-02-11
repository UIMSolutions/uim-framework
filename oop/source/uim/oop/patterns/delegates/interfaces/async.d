module uim.oop.patterns.delegates.interfaces.async;

/**
 * Async Business Delegate interface.
 * Supports asynchronous business operations.
 */
interface IAsyncBusinessDelegate {
  /**
   * Execute a business operation asynchronously.
   * Params:
   *   callback = Callback function to execute when operation completes
   */
  void doTaskAsync(void delegate(string) @safe callback);

  /**
   * Check if an async operation is in progress.
   * Returns: true if operation is in progress
   */
  bool isOperationInProgress();
}