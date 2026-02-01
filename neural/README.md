# UIM Neural - Neural Networks for D + vibe.d

Updated on 1. February 2026


A lightweight neural network toolkit for D that integrates with vibe.d. Build small feedforward models, train them with backpropagation, and expose inference over HTTP with only a few lines of code.

## Features
- Dense feedforward layers with configurable activations (ReLU, sigmoid, tanh, linear, softmax output helper)
- Losses: mean squared error and categorical cross entropy with softmax
- Simple SGD training loop with batch support and shuffling helpers
- Dataset utilities for mini-batch iteration and normalization
- Vibe.d HTTP server helper for Json-based inference endpoints


## Quick Start

### Train a tiny XOR network
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

### Classification Example
```d
import uim.neural;

auto net = NeuralNetwork()
    .addDenseLayer(4, 10, activation.tanh)
    .addDenseLayer(10, 3, activation.softmaxOutput);

// Assume irisData and irisLabels are loaded as double[][]
train(net, Dataset(irisData, irisLabels), loss.crossEntropy, TrainConfig(0.01, 1000));
auto classProbs = net.predict([5.1, 3.5, 1.4, 0.2]);
```

### Regression Example
```d
import uim.neural;

auto net = NeuralNetwork()
    .addDenseLayer(1, 16, activation.relu)
    .addDenseLayer(16, 1, activation.linear);

// Fit y = 2x + 1
double[][] xs = [[0.0], [1.0], [2.0], [3.0]];
double[][] ys = [[1.0], [3.0], [5.0], [7.0]];
train(net, Dataset(xs, ys), loss.mse, TrainConfig(0.1, 2000));
auto yPred = net.predict([4.0]); // Should be close to 9.0
```

### Custom Activation Function
```d
import uim.neural;

auto swish = ActivationFunction((x) => x / (1 + exp(-x)));
auto net = NeuralNetwork()
    .addDenseLayer(2, 8, swish)
    .addDenseLayer(8, 1, activation.sigmoid);
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
