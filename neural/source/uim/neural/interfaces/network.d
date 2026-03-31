module uim.neural.interfaces.network;

import uim.neural;

@safe:

interface INeuralNetwork {
  // Define the methods that a neural network should implement
  void train(Json trainingData);
  Json predict(Json inputData);
  void save(string filePath);
  void load(string filePath);
}