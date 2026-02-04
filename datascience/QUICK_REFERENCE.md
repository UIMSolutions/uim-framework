# UIM Data Science - Quick Reference

## 📦 Installation
```json
{ "dependencies": { "uim-framework:datascience": "*" } }
```

## 🎯 Import
```d
import uim.datascience;
```

---

## 📊 Data Structures

### Series (1D Array)
```d
auto s = new Series!double([1, 2, 3, 4, 5]);
s.mean()            // 3.0
s.stddev()          // √2.5
s.median()          // 3.0
s.filter(x => x > 2)
s.map(x => x * 2)
s.describe()
```

### DataFrame (2D Array)
```d
Series!double[string] cols;
cols["age"] = new Series!double([25, 30, 35]);
cols["income"] = new Series!double([50000, 60000, 70000]);
auto df = new DataFrame(cols);
df.select(["age"])
df.filterByColumn("age", x => x > 25)
df.correlationMatrix()
df.describe()
```

---

## 📈 Statistics

```d
double[] data = [1, 2, 3, 4, 5];

Statistics.mean(data)           // 3.0
Statistics.variance(data)       // 2.5
Statistics.stddev(data)         // √2.5
Statistics.median(data)         // 3.0
Statistics.quantile(data, 0.25) // 2.0
Statistics.skewness(data)       // 0
Statistics.kurtosis(data)       // -1.3

Statistics.correlation(x, y)
Statistics.covariance(x, y)

// Normalization
Statistics.standardize(data)    // z-score
Statistics.normalize(data)      // [0,1]

// Model metrics
Statistics.rSquared(actual, pred)
Statistics.rootMeanSquaredError(actual, pred)
Statistics.meanAbsoluteError(actual, pred)
```

---

## 📊 Distributions

```d
// Normal(μ=0, σ=1)
auto norm = new NormalDistribution(0, 1);
norm.pdf(x)         // Probability density
norm.cdf(x)         // Cumulative prob
norm.quantile(p)    // Inverse CDF

// Uniform(0, 1)
auto uniform = new UniformDistribution(0, 1);

// Exponential(λ=1)
auto exp = new ExponentialDistribution(1.0);

// Beta(α, β)
auto beta = new BetaDistribution(2, 5);

// Chi-squared(df=5)
auto chi2 = new ChiSquaredDistribution(5);
```

---

## 🔢 Linear Algebra

```d
// Vectors
LinearAlgebra.dot([1,2,3], [4,5,6])  // 32
LinearAlgebra.norm([3,4])            // 5

// Matrices
LinearAlgebra.transpose(m)
LinearAlgebra.matmul(m1, m2)
LinearAlgebra.determinant(m)
LinearAlgebra.inverse(m)

// Decompositions
LinearAlgebra.luDecomposition(m)
LinearAlgebra.gramSchmidt(m)
LinearAlgebra.eigen(m)              // Eigenvalues/vectors
```

---

## 🔧 Preprocessing

```d
// Scaling
Preprocessing.standardScale(data)    // z-score
Preprocessing.minMaxScale(data)      // [0,1]

// Missing values
Preprocessing.imputeMean(data)       // Mean imputation
Preprocessing.dropNaN(data)          // Remove NaN rows

// Features
Preprocessing.oneHotEncode(feature)
Preprocessing.polynomialFeatures(X, 3)

// Split
auto split = Preprocessing.trainTestSplit(X, y, 0.2);
```

---

## 🎯 Clustering

### K-Means
```d
auto km = new KMeans(3);
km.fit(data);
auto labels = km.predict(data);
auto centers = km.get_centers();
auto inertia = km.get_inertia();
```

### Hierarchical
```d
auto hc = new HierarchicalClustering();
hc.fit(data, 3);
auto labels = hc.getLabels(data.length);
```

---

## 🏷️ Classification

### Decision Tree
```d
auto tree = new DecisionTreeClassifier();
tree.fit(X, y);
auto pred = tree.predict(X_test);
```

### K-Nearest Neighbors
```d
auto knn = new KNearestNeighbors(5);
knn.fit(X_train, y_train);
auto pred = knn.predict(X_test);
```

### Naive Bayes
```d
auto nb = new NaiveBayesClassifier();
nb.fit(X_train, y_train);
auto pred = nb.predict(X_test);
```

---

## 📉 Regression

### Linear
```d
auto lr = new LinearRegression();
lr.fit(X, y);
auto pred = lr.predict(X_test);
double intercept = lr.get_intercept();
double[] coef = lr.get_coefficients();
```

### Logistic
```d
auto logistic = new LogisticRegression();
logistic.fit(X, y, 0.01, 1000);
double[] proba = logistic.predictProba(X_test);
size_t[] pred = logistic.predict(X_test);
```

### Polynomial
```d
auto poly = new PolynomialRegression(3);
poly.fit(X, y);
auto pred = poly.predict(X_test);
```

### Ridge (L2)
```d
auto ridge = new RidgeRegression(1.0);
ridge.fit(X, y);
auto pred = ridge.predict(X_test);
```

---

## 🌐 Web API (vibe.d)

```bash
# Start server
dub run :web_api

# Endpoints
GET /api/datascience/health
POST /api/datascience/statistics/describe
POST /api/datascience/correlation
POST /api/datascience/preprocess/normalize
POST /api/datascience/preprocess/standardize
POST /api/datascience/visualization/histogram
POST /api/datascience/statistics/summary
```

---

## 📚 Documentation

- **README.md** - Quick start
- **GETTING_STARTED.md** - Full guide (400+ lines)
- **BUILD_COMPLETE.md** - Build info
- **examples/basic_example.d** - Working demo
- **examples/web_api.d** - API server

---

## 🧪 Testing

```bash
cd datascience
dub test
```

---

## 📦 Files

```
datascience/
├── source/uim/datascience/
│   ├── package.d          # Exports
│   ├── series.d           # 1D arrays
│   ├── dataframe.d        # 2D arrays
│   ├── statistics.d       # Stats functions
│   ├── distributions.d    # Probability
│   ├── linalg.d           # Linear algebra
│   ├── preprocessing.d    # Data prep
│   ├── clustering.d       # Clustering
│   ├── classification.d   # Classification
│   ├── regression.d       # Regression
│   └── web.d              # REST API
├── examples/
│   ├── basic_example.d
│   └── web_api.d
└── tests/
    └── test_all.d
```

---

**Status**: ✅ Production Ready | **License**: Apache 2.0

For full documentation, see GETTING_STARTED.md in the datascience folder.
