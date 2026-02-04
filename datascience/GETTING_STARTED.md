# uim-datascience: Data Science Library for D

A comprehensive data science library for the D programming language with full vibe.d integration for building data science web services.

**Created: February 4, 2026**

## Overview

The `uim-datascience` library provides a complete toolkit for:
- Statistical analysis and hypothesis testing
- Linear algebra and matrix operations
- Data manipulation with Series and DataFrames
- Machine learning algorithms (clustering, classification, regression)
- Probability distributions
- Data preprocessing and normalization
- RESTful API endpoints for data science operations via vibe.d

## Project Structure

```
datascience/
├── README.md                          # Main documentation
├── dub.sdl                            # Dub package configuration
├── source/uim/datascience/
│   ├── package.d                      # Main module exports
│   ├── series.d                       # 1D labeled array (Series)
│   ├── dataframe.d                    # 2D labeled array (DataFrame)
│   ├── statistics.d                   # Statistical functions
│   ├── distributions.d                # Probability distributions
│   ├── linalg.d                       # Linear algebra operations
│   ├── preprocessing.d                # Data preprocessing utilities
│   ├── clustering.d                   # Clustering algorithms (K-Means, Hierarchical)
│   ├── classification.d               # Classification algorithms
│   ├── regression.d                   # Regression algorithms
│   └── web.d                          # vibe.d REST API endpoints
├── examples/
│   ├── basic_example.d                # Basic usage example
│   └── web_api.d                      # Web API server example
└── tests/
    └── test_all.d                     # Unit tests
```

## Core Modules

### 1. **Data Structures**

#### Series (1D Array)
```d
import uim.datascience;

// Create a Series
auto data = new Series!double([1.0, 2.0, 3.0, 4.0, 5.0]);

// Statistical operations
auto mean = data.mean();
auto stddev = data.stddev();
auto median = data.median();
auto min = data.min();
auto max = data.max();

// Get descriptive statistics
auto stats = data.describe();

// Filtering
auto filtered = data.filter(x => x > 2.0);

// Mapping
auto doubled = data.map(x => x * 2);
```

#### DataFrame (2D Array)
```d
// Create DataFrame from columns
Series!double[string] columns;
columns["age"] = new Series!double([25.0, 30.0, 35.0]);
columns["income"] = new Series!double([50000.0, 60000.0, 70000.0]);

auto df = new DataFrame(columns);

// Operations
df.describe();
auto subset = df.select(["age"]);
auto filtered = df.filterByColumn("age", x => x > 25.0);

// Correlation matrix
auto corr = df.correlationMatrix();
```

### 2. **Statistics Module**

```d
double[] values = [1.0, 2.0, 3.0, 4.0, 5.0];

// Descriptive statistics
double mean = Statistics.mean(values);
double variance = Statistics.variance(values);
double stddev = Statistics.stddev(values);
double median = Statistics.median(values);
double skewness = Statistics.skewness(values);
double kurtosis = Statistics.kurtosis(values);

// Correlation and covariance
double cov = Statistics.covariance(x, y);
double corr = Statistics.correlation(x, y);

// Normalization
double[] zscore = Statistics.standardize(values);
double[] normalized = Statistics.normalize(values);

// Model evaluation
double rmse = Statistics.rootMeanSquaredError(actual, predicted);
double r2 = Statistics.rSquared(actual, predicted);
```

### 3. **Linear Algebra**

```d
// Vector operations
double dot = LinearAlgebra.dot([1, 2, 3], [4, 5, 6]);
double norm = LinearAlgebra.norm([3, 4]);  // Result: 5

// Matrix operations
double[][] matrix = [[1, 2], [3, 4]];
auto transposed = LinearAlgebra.transpose(matrix);
auto product = LinearAlgebra.matmul(matrixA, matrixB);

// Matrix decomposition
double det = LinearAlgebra.determinant(matrix);
auto inv = LinearAlgebra.inverse(matrix);
auto lu = LinearAlgebra.luDecomposition(matrix);

// Advanced operations
auto qr = LinearAlgebra.gramSchmidt(matrix);
auto eigen = LinearAlgebra.eigen(matrix);
```

### 4. **Probability Distributions**

```d
// Normal Distribution
auto normal = new NormalDistribution(0.0, 1.0);
double pdf = normal.pdf(0.5);
double cdf = normal.cdf(0.5);
double quantile = normal.quantile(0.95);

// Uniform Distribution
auto uniform = new UniformDistribution(0.0, 1.0);
double pdf = uniform.pdf(0.5);
double cdf = uniform.cdf(0.5);

// Exponential Distribution
auto exp_dist = new ExponentialDistribution(1.0);
double pdf = exp_dist.pdf(1.0);

// Beta Distribution
auto beta = new BetaDistribution(2.0, 5.0);
double pdf = beta.pdf(0.5);

// Chi-Squared Distribution
auto chi2 = new ChiSquaredDistribution(5);
double pdf = chi2.pdf(3.0);
```

### 5. **Data Preprocessing**

```d
// Feature scaling
double[][] standardized = Preprocessing.standardScale(data);
double[][] normalized = Preprocessing.minMaxScale(data);

// Missing value handling
double[][] filled = Preprocessing.imputeMean(data);
double[][] clean = Preprocessing.dropNaN(data);

// Feature engineering
double[][] encoded = Preprocessing.oneHotEncode(categoricalFeature);
double[][] poly = Preprocessing.polynomialFeatures(data, 3);

// Train-test split
auto split = Preprocessing.trainTestSplit(X, y, 0.2);
auto X_train = split.X_train;
auto X_test = split.X_test;
auto y_train = split.y_train;
auto y_test = split.y_test;
```

### 6. **Clustering**

#### K-Means
```d
double[][] data = [
  [1.0, 1.0], [1.5, 1.5], [10.0, 10.0], [10.5, 10.5]
];

auto kmeans = new KMeans(2);
kmeans.fit(data);
auto labels = kmeans.predict(data);
double inertia = kmeans.get_inertia();
double[][] centers = kmeans.get_centers();
```

#### Hierarchical Clustering
```d
auto hierarchical = new HierarchicalClustering();
hierarchical.fit(data, 3);  // 3 clusters
auto labels = hierarchical.getLabels(data.length);
```

### 7. **Classification**

#### Decision Tree
```d
double[][] X = [[1, 1], [2, 2], [3, 3], [4, 4]];
size_t[] y = [0, 0, 1, 1];

auto tree = new DecisionTreeClassifier();
tree.fit(X, y);
auto predictions = tree.predict(X);
```

#### K-Nearest Neighbors
```d
auto knn = new KNearestNeighbors(3);
knn.fit(X_train, y_train);
auto predictions = knn.predict(X_test);
```

#### Naive Bayes
```d
auto nb = new NaiveBayesClassifier();
nb.fit(X_train, y_train);
auto predictions = nb.predict(X_test);
```

### 8. **Regression**

#### Linear Regression
```d
double[][] X = [[1], [2], [3], [4], [5]];
double[] y = [2, 4, 6, 8, 10];

auto lr = new LinearRegression();
lr.fit(X, y);
auto predictions = lr.predict(X);
double intercept = lr.get_intercept();
double[] coefficients = lr.get_coefficients();
```

#### Logistic Regression
```d
auto logistic = new LogisticRegression();
logistic.fit(X_train, y_train, 0.01, 1000);
double[] probabilities = logistic.predictProba(X_test);
size_t[] predictions = logistic.predict(X_test);
```

#### Polynomial Regression
```d
auto poly_reg = new PolynomialRegression(3);  // Degree 3
poly_reg.fit(X_train, y_train);
auto predictions = poly_reg.predict(X_test);
```

#### Ridge Regression (L2 Regularization)
```d
auto ridge = new RidgeRegression(1.0);  // Alpha = 1.0
ridge.fit(X_train, y_train);
auto predictions = ridge.predict(X_test);
```

### 9. **Web API (vibe.d Integration)**

The library provides REST API endpoints for data science operations:

```d
// Start the server
dub run :web_api
```

#### Available Endpoints

**Health Check:**
```
GET /api/datascience/health
Response: {"status": "ok", "service": "uim-datascience"}
```

**Descriptive Statistics:**
```
POST /api/datascience/statistics/describe
Body: {"data": [1.0, 2.0, 3.0, 4.0, 5.0]}
```

**Correlation:**
```
POST /api/datascience/correlation
Body: {"x": [1, 2, 3], "y": [2, 4, 6]}
```

**Normalization:**
```
POST /api/datascience/preprocess/normalize
Body: {"data": [1.0, 100.0, 1000.0]}
```

**Standardization:**
```
POST /api/datascience/preprocess/standardize
Body: {"data": [1.0, 2.0, 3.0, 4.0, 5.0]}
```

**Histogram:**
```
POST /api/datascience/visualization/histogram
Body: {"data": [...], "bins": 10}
```

**Model Prediction:**
```
POST /api/models/:modelId/predict
Body: {"data": [...]}
```

## Usage Examples

### Running the Basic Example
```bash
cd datascience/examples
dub run basic_example.d
```

### Running the Web API
```bash
cd datascience/examples
dub run web_api.d
```

Then test with:
```bash
curl -X GET http://localhost:8080/api/datascience/health
curl -X POST http://localhost:8080/api/datascience/statistics/summary \
  -H "Content-Type: application/json" \
  -d '{"data": [1, 2, 3, 4, 5]}'
```

### Running Tests
```bash
cd datascience
dub test
```

## Features

### ✅ Implemented
- **Data Structures**: Series, DataFrame
- **Statistics**: Mean, variance, std dev, correlation, skewness, kurtosis
- **Linear Algebra**: Matrix operations, decompositions, eigenvalues
- **Distributions**: Normal, Uniform, Exponential, Beta, Chi-squared
- **Preprocessing**: Scaling, normalization, imputation, encoding
- **Clustering**: K-Means, Hierarchical clustering
- **Classification**: Decision Trees, KNN, Naive Bayes
- **Regression**: Linear, Logistic, Polynomial, Ridge
- **Web API**: vibe.d REST endpoints for all operations

### 🚀 Planned Features
- Neural networks module
- Time series analysis
- Dimensionality reduction (PCA, t-SNE)
- Cross-validation utilities
- Hyperparameter optimization
- Model serialization/deserialization
- Advanced visualization endpoints
- GPU acceleration support

## Dependencies

- **D Language**: Version 2.100+
- **dlib**: Numerical library (~>1.3.2)
- **vibe-d**: Web framework (~>0.10.3)
- **uim-core**: Core utilities
- **uim-numerical**: Numerical computations

## Installation

Add to your `dub.json`:
```json
{
  "dependencies": {
    "uim-framework:datascience": "*"
  }
}
```

Or to `dub.sdl`:
```sdl
dependency "uim-framework:datascience" version="*"
```

## API Documentation

See the individual module files for detailed API documentation:
- [statistics.d](source/uim/datascience/statistics.d)
- [linalg.d](source/uim/datascience/linalg.d)
- [clustering.d](source/uim/datascience/clustering.d)
- [classification.d](source/uim/datascience/classification.d)
- [regression.d](source/uim/datascience/regression.d)

## Performance Considerations

- All algorithms are implemented in pure D without external C/C++ dependencies
- Suitable for medium-sized datasets (up to millions of rows)
- For very large datasets, consider GPU acceleration or distributed processing
- Linear algebra operations use optimized algorithms (LU, QR, Eigenvalue)

## License

Apache 2.0 - See LICENSE file

## Contributing

Contributions are welcome! Areas for enhancement:
- Performance optimization
- Algorithm parallelization
- Additional statistical tests
- More ML algorithms
- Better visualization support
- GPU backend

## Author

Ozan Nurettin Süel (UI Manufaktur)

## References

This library implements algorithms from:
- Elements of Statistical Learning (Hastie, Tibshirani, Friedman)
- Pattern Recognition and Machine Learning (Bishop)
- Numerical Recipes (Press, Teukolsky, Vetterling, Flannery)
- Standard statistical textbooks and research papers
