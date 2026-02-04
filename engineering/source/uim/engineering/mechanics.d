/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.mechanics;

import std.math;
import uim.engineering.units;

@safe:

/**
 * Classical mechanics utilities.
 */
class Mechanics {
    // Kinematics
    static double displacement(double s0, double v0, double a, double t) pure nothrow {
        return s0 + v0 * t + 0.5 * a * t * t;
    }

    static double velocity(double v0, double a, double t) pure nothrow {
        return v0 + a * t;
    }

    static double acceleration(double dv, double dt) pure nothrow {
        return dv / dt;
    }

    // Dynamics
    static double force(double mass, double acceleration) pure nothrow {
        return mass * acceleration;
    }

    static double momentum(double mass, double velocity) pure nothrow {
        return mass * velocity;
    }

    static double impulse(double force, double time) pure nothrow {
        return force * time;
    }

    // Energy
    static double kineticEnergy(double mass, double velocity) pure nothrow {
        return 0.5 * mass * velocity * velocity;
    }

    static double potentialEnergy(double mass, double height) pure nothrow {
        return mass * Units.g * height;
    }

    static double work(double force, double distance) pure nothrow {
        return force * distance;
    }

    static double power(double work, double time) pure nothrow {
        return work / time;
    }

    // Rotation
    static double torque(double radius, double force) pure nothrow {
        return radius * force;
    }

    static double angularVelocity(double omega0, double alpha, double t) pure nothrow {
        return omega0 + alpha * t;
    }

    static double rotationalEnergy(double inertia, double omega) pure nothrow {
        return 0.5 * inertia * omega * omega;
    }
}
