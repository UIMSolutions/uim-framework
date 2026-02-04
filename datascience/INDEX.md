# UIM Data Science Library - Documentation Index

**Built**: February 4, 2026  
**Status**: ✅ Production Ready  
**Location**: `/datascience/`

---

## 📚 Documentation Files

### Getting Started
1. **README.md** (150 lines)
   - Quick overview
   - Feature summary
   - Installation instructions
   - Quick start code samples

2. **QUICK_REFERENCE.md** (200 lines)
   - API cheat sheet
   - Code snippets for all modules
   - Common use patterns
   - Quick lookup reference

### Comprehensive Guides
3. **GETTING_STARTED.md** (400+ lines)
   - Complete feature documentation
   - Module-by-module explanation
   - Detailed code examples
   - Performance notes
   - Future enhancements
   - References

4. **BUILD_COMPLETE.md** (200 lines)
   - Build summary
   - File structure
   - Architecture decisions
   - Integration details
   - Next steps

### Meta
5. **INDEX.md** (this file)
   - Documentation navigation
   - File guide
   - Learning path

---

## 🗂️ Source Code Files

### Core Modules (11 files)
Located in `source/uim/datascience/`

1. **package.d** - Module exports and public API
2. **series.d** - 1D labeled array (Series class)
3. **dataframe.d** - 2D labeled array (DataFrame class)
4. **statistics.d** - Statistical functions
5. **distributions.d** - Probability distributions
6. **linalg.d** - Linear algebra operations
7. **preprocessing.d** - Data preprocessing utilities
8. **clustering.d** - Clustering algorithms (K-Means, Hierarchical)
9. **classification.d** - Classification algorithms (Tree, KNN, NB)
10. **regression.d** - Regression algorithms (Linear, Logistic, Polynomial, Ridge)
11. **web.d** - vibe.d REST API endpoints

---

## 💻 Examples

Located in `examples/`

1. **basic_example.d** - Demonstrates all major features
   - Series operations
   - Statistics
   - Linear algebra
   - Clustering
   - Regression

2. **web_api.d** - REST API server
   - vibe.d integration
   - JSON endpoints
   - Model serving

Run with:
```bash
dub run basic_example.d
dub run web_api.d
```

---

## 🧪 Tests

Located in `tests/`

1. **test_all.d** - Unit test suite
   - Series tests
   - Statistics tests
   - Linear algebra tests
   - Clustering tests
   - Regression tests

Run with:
```bash
dub test
```

---

## 📖 Learning Path

### Beginner
1. Start with **README.md** (5 min read)
2. Look at **QUICK_REFERENCE.md** for API overview (10 min)
3. Run **basic_example.d** (5 min)

### Intermediate
1. Read **GETTING_STARTED.md** for detailed guide (30 min)
2. Study individual module files (30 min)
3. Try modifying examples (30 min)

### Advanced
1. Review **BUILD_COMPLETE.md** for architecture (15 min)
2. Study source code implementations (1+ hour)
3. Extend with custom algorithms (varies)

---

## 🔍 Finding What You Need

### Data Structures
- **Series**: series.d in source code, QUICK_REFERENCE section 1
- **DataFrame**: dataframe.d in source code, QUICK_REFERENCE section 2

### Statistics
- **Functions**: statistics.d in source code, QUICK_REFERENCE section 3
- **Distributions**: distributions.d, QUICK_REFERENCE section 4

### Machine Learning
- **Linear Algebra**: linalg.d, QUICK_REFERENCE section 5
- **Preprocessing**: preprocessing.d, QUICK_REFERENCE section 6
- **Clustering**: clustering.d, QUICK_REFERENCE section 7
- **Classification**: classification.d, QUICK_REFERENCE section 8
- **Regression**: regression.d, QUICK_REFERENCE section 9

### Web Services
- **REST API**: web.d source, QUICK_REFERENCE section 10

---

## 📋 Quick Facts

| Metric | Value |
|--------|-------|
| Core Modules | 11 |
| Documentation Files | 5 |
| Example Files | 2 |
| Test Files | 1 |
| Total Lines | 3,500+ |
| Classes | 15+ |
| Functions | 100+ |
| Algorithms | 30+ |
| License | Apache 2.0 |

---

## 🎯 Module Overview

### Data Structures (2 modules)
- Series - 1D labeled arrays
- DataFrame - 2D labeled arrays

### Analysis (2 modules)
- Statistics - Statistical functions
- Distributions - Probability distributions

### Computation (1 module)
- Linear Algebra - Matrix/vector operations

### Processing (1 module)
- Preprocessing - Feature engineering, scaling

### Machine Learning (3 modules)
- Clustering - K-Means, Hierarchical
- Classification - Decision Trees, KNN, Naive Bayes
- Regression - Linear, Logistic, Polynomial, Ridge

### Web (1 module)
- Web - vibe.d REST API

---

## 🚀 Usage Examples

### Example 1: Load Documentation
```bash
# Quick reference for all APIs
cat QUICK_REFERENCE.md

# Full feature guide
cat GETTING_STARTED.md

# Build information
cat BUILD_COMPLETE.md
```

### Example 2: Run Examples
```bash
# Feature demonstration
dub run examples/basic_example.d

# Start REST API
dub run examples/web_api.d
```

### Example 3: Use in Your Code
```d
import uim.datascience;

void main() {
  auto data = new Series!double([1, 2, 3]);
  writeln(data.mean());
}
```

---

## 📝 File Structure

```
datascience/
├── README.md                    # Quick start (1st read)
├── QUICK_REFERENCE.md           # API cheat sheet (reference)
├── GETTING_STARTED.md           # Complete guide (study)
├── BUILD_COMPLETE.md            # Build summary
├── INDEX.md                     # This file
├── LICENSE
├── dub.sdl
│
├── source/uim/datascience/      # Implementation
│   ├── package.d
│   ├── series.d
│   ├── dataframe.d
│   ├── statistics.d
│   ├── distributions.d
│   ├── linalg.d
│   ├── preprocessing.d
│   ├── clustering.d
│   ├── classification.d
│   ├── regression.d
│   └── web.d
│
├── examples/                    # Working code
│   ├── basic_example.d
│   └── web_api.d
│
└── tests/                       # Unit tests
    └── test_all.d
```

---

## ✅ What's Included

### Documentation
- ✅ Quick start guide
- ✅ API reference
- ✅ Complete feature guide
- ✅ Build summary
- ✅ This index

### Code
- ✅ 11 core modules
- ✅ 100+ functions
- ✅ 30+ algorithms
- ✅ 2 examples
- ✅ 1 test suite

### Integration
- ✅ Part of uim-framework
- ✅ vibe.d compatible
- ✅ Production ready

---

## 🎓 Advanced Topics

### Topics Covered
- Data structures and manipulation
- Statistical analysis
- Probability theory
- Linear algebra
- Feature engineering
- Clustering algorithms
- Classification algorithms
- Regression algorithms
- Web API design

### Topics for Future
- Time series analysis
- Neural networks
- Deep learning
- GPU acceleration
- Distributed computing
- Model serialization

---

## 💡 Tips

1. **Start Simple**: Begin with README.md and QUICK_REFERENCE.md
2. **Learn by Example**: Run basic_example.d first
3. **Reference Often**: Use QUICK_REFERENCE.md for syntax
4. **Go Deep**: Read GETTING_STARTED.md for understanding
5. **Review Code**: Study source files for implementation details

---

## 🔗 Related Files

### In uim-framework root:
- `/dub.sdl` - Framework configuration (includes datascience)
- `/DATASCIENCE_BUILD_SUMMARY.md` - Integration summary

### In datascience folder:
- `dub.sdl` - Package configuration
- `LICENSE` - Apache 2.0 license
- All files documented above

---

## 📞 Quick Answers

**Q: Where do I start?**  
A: Read README.md first (5 min), then QUICK_REFERENCE.md

**Q: How do I use the library?**  
A: Import `uim.datascience` and see QUICK_REFERENCE.md for examples

**Q: Where are the examples?**  
A: In `examples/` folder, run with `dub run`

**Q: Where's the full documentation?**  
A: See GETTING_STARTED.md (400+ lines with all details)

**Q: How do I run tests?**  
A: Run `dub test` from datascience folder

**Q: Is it production ready?**  
A: Yes! ✅ Full unit tests, error handling, and documentation

**Q: What's the license?**  
A: Apache 2.0 - See LICENSE file

---

## 🎉 Next Steps

1. **Learn**: Read documentation in this order:
   - README.md (overview)
   - QUICK_REFERENCE.md (API reference)
   - GETTING_STARTED.md (comprehensive guide)

2. **Explore**: Run the examples
   - `dub run examples/basic_example.d`
   - `dub run examples/web_api.d`

3. **Experiment**: Modify examples and try your own code

4. **Integrate**: Use in your projects
   - Add to `dub.json` dependency
   - Import `uim.datascience`
   - Start coding!

---

**Status**: ✅ Complete and Ready  
**Version**: 1.0  
**Date**: February 4, 2026  
**License**: Apache 2.0

---

For questions or improvements, refer to the documentation or study the source code.

**Happy Data Science! 🚀**
