/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.flyweights.interfaces.memory;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Interface for objects that can report their memory footprint.
 */
interface IMemoryReportable {
    /**
     * Gets an estimate of memory used by this object.
     * Returns: Approximate memory usage in bytes
     */
    size_t memoryUsage() const @safe;
}
