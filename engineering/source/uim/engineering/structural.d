/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.structural;

import std.math;

@safe:

/**
 * Structural engineering utilities.
 */
class Structural {
    // Second moment of area
    static double momentOfInertiaRect(double width, double height) pure nothrow {
        return (width * pow(height, 3)) / 12.0;
    }

    static double momentOfInertiaCircle(double radius) pure nothrow {
        return (PI * pow(radius, 4)) / 4.0;
    }

    // Bending stress
    static double bendingStress(double moment, double c, double inertia) pure nothrow {
        return (moment * c) / inertia;
    }

    // Deflection for simply supported beam with central load
    static double deflectionCentralLoad(double load, double length, double modulusE, double inertia) pure nothrow {
        return (load * pow(length, 3)) / (48.0 * modulusE * inertia);
    }

    // Axial deformation
    static double axialDeformation(double force, double length, double area, double modulusE) pure nothrow {
        return (force * length) / (area * modulusE);
    }
}
