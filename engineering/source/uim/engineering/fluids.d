/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.fluids;

import std.math;

@safe:

/**
 * Fluid dynamics utilities.
 */
class Fluids {
    static double reynoldsNumber(double density, double velocity, double length, double viscosity) pure nothrow {
        return (density * velocity * length) / viscosity;
    }

    static double dynamicPressure(double density, double velocity) pure nothrow {
        return 0.5 * density * velocity * velocity;
    }

    static double flowRate(double velocity, double area) pure nothrow {
        return velocity * area;
    }

    static double continuityVelocity(double area1, double velocity1, double area2) pure nothrow {
        return (area1 * velocity1) / area2;
    }

    static double bernoulliPressure(double p0, double density, double velocity, double height) pure nothrow {
        return p0 + dynamicPressure(density, velocity) + density * 9.80665 * height;
    }
}
