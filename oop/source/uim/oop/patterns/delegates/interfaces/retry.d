module uim.oop.patterns.delegates.interfaces.retry;

/**
 * Business Delegate with retry capabilities.
 */
interface IRetryableBusinessDelegate : IBusinessDelegate {
  /**
   * Set maximum retry attempts.
   * Params:
   *   attempts = Maximum number of retry attempts
   */
  void setMaxRetries(int attempts);

  /**
   * Get current retry count.
   * Returns: Number of retries performed
   */
  int retryCount();
}
