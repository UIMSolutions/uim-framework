module uim.entities.udas.range;

/**
 * UDA to mark a field with range validation
 */
struct Range {
    long min;
    long max;
    
    this(long minimum, long maximum) {
        min = minimum;
        max = maximum;
    }
}