# uim-engineering

A comprehensive engineering library for the D language with vibe.d integration.

## Features

- **Units & Conversions**: SI and imperial conversions
- **Mechanics**: Kinematics, energy, momentum, power, torque
- **Materials**: Stress, strain, Young's modulus, safety factor
- **Thermodynamics**: Ideal gas, heat transfer, efficiency
- **Fluids**: Reynolds number, Bernoulli, flow rates
- **Electrical**: Ohm's law, power, resistivity, energy
- **Structural**: Bending stress, beam deflection, inertia
- **Web API**: REST endpoints via vibe.d

## Installation

Add to your `dub.json`:
```json
"dependencies": {
  "uim-framework:engineering": "*"
}
```

## Quick Start

```d
import uim.engineering;

void main() {
  auto energy = Mechanics.kineticEnergy(1200.0, 27.0);
  auto stress = Materials.stress(20000.0, 0.01);
  auto reynolds = Fluids.reynoldsNumber(1000.0, 2.0, 0.05, 0.001);
}
```
