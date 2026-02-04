/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.electrical;

import std.math;

@safe:

/**
 * Electrical engineering utilities.
 */
class Electrical {
    static double voltage(double current, double resistance) pure nothrow {
        return current * resistance;
    }

    static double current(double voltage, double resistance) pure nothrow {
        return voltage / resistance;
    }

    static double resistance(double voltage, double current) pure nothrow {
        return voltage / current;
    }

    static double powerVI(double voltage, double current) pure nothrow {
        return voltage * current;
    }

    static double powerIR(double current, double resistance) pure nothrow {
        return current * current * resistance;
    }

    static double resistanceFromResistivity(double resistivity, double length, double area) pure nothrow {
        return resistivity * length / area;
    }

    static double capacitorEnergy(double capacitance, double voltage) pure nothrow {
        return 0.5 * capacitance * voltage * voltage;
    }

    static double inductorEnergy(double inductance, double current) pure nothrow {
        return 0.5 * inductance * current * current;
    }
}
