# UIM Neural - Neural Networks for D + vibe.d

A lightweight neural network toolkit for D that integrates with vibe.d. Build small feedforward models, train them with backpropagation, and expose inference over HTTP with only a few lines of code.

## Features
- Dense feedforward layers with configurable activations (ReLU, sigmoid, tanh, linear, softmax output helper)
- Losses: mean squared error and categorical cross entropy with softmax
- Simple SGD training loop with batch support and shuffling helpers
- Dataset utilities for mini-batch iteration and normalization
- Vibe.d HTTP server helper for JSON-based inference endpoints

## Quick Start

### Train a tiny network
```d
import uim.neural;

auto net = NeuralNetwork()
    .addDenseLayer(2, 8, activation.relu)
    .addDenseLayer(8, 1, activation.sigmoid);

Dataset data = Dataset([
    [0.0, 0.0],
    [0.0, 1.0],
    [1.0, 0.0],
    [1.0, 1.0]
], [
    [0.0],
    [1.0],
    [1.0],
    [0.0]
]);

TrainConfig cfg;
cfg.learningRate = 0.05;
cfg.epochs = 5000;

train(net, data, loss.mse, cfg);
auto prediction = net.predict([1.0, 0.0]);
```

### Expose inference over HTTP
```d
import uim.neural;

auto net = NeuralNetwork()
    .addDenseLayer(3, 6, activation.relu)
    .addDenseLayer(6, 2, activation.softmaxOutput);

serveNeuralNetwork(net, InferenceServerConfig("127.0.0.1", 8080, "/predict"));
// POST {"inputs": [[0.1, 0.2, 0.3]]} -> {"outputs": [[0.42, 0.58]]}
```

## Modules
- `uim.neural.activations` – activation helpers
- `uim.neural.layers` – dense layers
- `uim.neural.losses` – loss functions
- `uim.neural.network` – `NeuralNetwork` orchestration
- `uim.neural.training` – training loop, dataset helpers
- `uim.neural.server` – vibe.d HTTP inference helper

## Notes
- Designed for small models and educational use; not a replacement for full ML frameworks.
- Uses only the standard library plus vibe.d for serving and `uim.numerical` utilities for small helpers.
- Keep batch sizes modest; everything is kept in-memory.
