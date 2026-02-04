/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.materials;

@safe:

/**
 * Materials and strength of materials utilities.
 */
class Materials {
    static double stress(double force, double area) pure nothrow {
        return force / area;
    }

    static double strain(double deltaL, double L0) pure nothrow {
        return deltaL / L0;
    }

    static double youngsModulus(double stress, double strain) pure nothrow {
        return stress / strain;
    }

    static double hookesLaw(double modulusE, double strain) pure nothrow {
        return modulusE * strain;
    }

    static double safetyFactor(double allowableStress, double actualStress) pure nothrow {
        return allowableStress / actualStress;
    }

    static double shearStress(double force, double area) pure nothrow {
        return force / area;
    }

    static double pressureFromForce(double force, double area) pure nothrow {
        return force / area;
    }
}
