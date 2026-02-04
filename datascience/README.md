# uim-datascience

A comprehensive data science library for the D language with vibe.d integration.

## Features

- **Statistical Analysis**: Descriptive statistics, distributions, hypothesis testing
- **Linear Algebra**: Matrix operations, decompositions, eigenvalue problems
- **Data Structures**: DataFrames, Series, missing value handling
- **Machine Learning**: Clustering, classification, regression algorithms
- **Visualization**: HTTP endpoints for data exploration and visualization via vibe.d
- **Data I/O**: CSV, JSON, and database connectivity

## Modules

### Core Modules
- `statistics` - Probability distributions and statistical functions
- `linalg` - Linear algebra operations
- `dataframe` - Tabular data manipulation
- `preprocessing` - Data cleaning and transformation

### Machine Learning
- `clustering` - K-means, hierarchical clustering
- `classification` - Logistic regression, decision trees, SVM
- `regression` - Linear, polynomial, ridge regression

### Web Integration
- `web` - vibe.d REST API endpoints for model serving

## Installation

Add to your `dub.json`:
```json
"dependencies": {
  "uim-framework:datascience": "*"
}
```

## Quick Start

```d
import uim.datascience;

void main() {
  // Create a series
  auto data = Series!double([ 1.0, 2.0, 3.0, 4.0, 5.0 ]);
  
  // Calculate statistics
  auto mean = data.mean();
  auto stddev = data.stddev();
  
  writeln("Mean: ", mean);
  writeln("StdDev: ", stddev);
}
```

## License

Apache 2.0
