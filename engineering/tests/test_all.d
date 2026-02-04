/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module engineering.tests.test_all;

import uim.engineering;

void main() {
    testUnits();
    testMechanics();
    testMaterials();
    testThermodynamics();
    testFluids();
    testElectrical();
    testStructural();
}

void testUnits() {
    auto ft = Units.metersToFeet(1.0);
    auto m = Units.feetToMeters(ft);
    assert(approxEqual(m, 1.0, 1e-9));
}

void testMechanics() {
    auto ke = Mechanics.kineticEnergy(2.0, 3.0);
    assert(approxEqual(ke, 9.0, 1e-12));
}

void testMaterials() {
    auto s = Materials.stress(100.0, 0.5);
    assert(approxEqual(s, 200.0, 1e-12));
}

void testThermodynamics() {
    auto p = Thermodynamics.idealGasPressure(1.0, 300.0, 0.025);
    assert(p > 0.0);
}

void testFluids() {
    auto re = Fluids.reynoldsNumber(1000.0, 1.0, 0.05, 0.001);
    assert(re > 0.0);
}

void testElectrical() {
    auto v = Electrical.voltage(2.0, 5.0);
    assert(approxEqual(v, 10.0, 1e-12));
}

void testStructural() {
    auto I = Structural.momentOfInertiaRect(0.2, 0.4);
    assert(I > 0.0);
}

private bool approxEqual(double a, double b, double tol) pure nothrow {
    return (a - b) <= tol && (b - a) <= tol;
}
