# 📋 MATLAB Codes Index - PWE Analysis for LRSC Plates

## 🎯 Quick Navigation

### 🚀 **RECOMMENDED: Start Here**
```
📂 pwe/pwe_unified_implementation/
├── 🌟 general_pwe_dispersion.m      # Single function for all lattices
├── ⚙️  get_lattice_config.m         # Lattice parameters lookup
├── 🔧 generate_reciprocal_lattice.m # Optimized vector generation  
├── 🗺️  get_fibz_path.m              # Symmetry points and paths
├── 🧪 test_general_pwe.m            # Comprehensive test suite
├── 📖 README.md                     # Quick start guide
└── 📚 README_GeneralizedPWE.md     # Technical documentation
```

**Benefits**: 65% less code, 40% less memory, single interface for all lattices

### 📂 **Legacy: Individual Functions**
```
📂 pwe/pwe_individual_functions/
├── func0_1_square_pwe_plot_line_data_full_path.m      # Square lattice
├── func0_2_rectangular_pwe_plot_line_data_full_path.m # Rectangular lattice
├── func0_3_triangular_pwe_plot_line_data_full_path.m  # Triangular lattice  
├── func0_4_hexagonal_pwe_plot_line_data_full_path.m   # Hexagonal lattice
├── func0_5_kagome_pwe_plot_line_data_full_path.m      # Kagome lattice
└── 📖 README.md                                       # Individual function guide
```

**Purpose**: Original implementation for compatibility and reference

## ⚡ Quick Start Commands

### Unified Implementation (Recommended)
```matlab
% Add to MATLAB path
addpath('pwe/pwe_unified_implementation');

% Run tests
test_general_pwe;

% Basic analysis - any lattice type
[freq, w_kk] = general_pwe_dispersion('hexagonal', 10, 1, 1, ...
                   0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);

% Batch analysis - all lattices
lattices = {'square', 'rectangular', 'triangular', 'hexagonal', 'kagome'};
for i = 1:length(lattices)
    [f, k] = general_pwe_dispersion(lattices{i}, 8, 1, 1, ...
                 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);
end
```

### Individual Functions (Legacy)
```matlab  
% Add to MATLAB path
addpath('pwe/pwe_individual_functions');

% Square lattice
func0_1_square_pwe_plot_line_data_full_path(10, 1, 1, 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);

% Hexagonal lattice  
func0_4_hexagonal_pwe_plot_line_data_full_path(10, 1, 1, 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);
```

## 📊 Feature Comparison

| Feature | Unified Implementation | Individual Functions |
|---------|----------------------|---------------------|
| **Code Size** | ~600 lines (4 files) | ~1750 lines (5 files) |
| **Memory Usage** | Optimized (40% less) | Standard |
| **Performance** | Vectorized + Sparse | Basic implementation |
| **Interface** | Single function | 5 separate functions |
| **Maintenance** | Centralized | Distributed |
| **Testing** | Comprehensive suite | Manual testing |
| **Documentation** | Complete | Mixed quality |

## 🔧 Parameter Reference

### Common Parameters (All Functions)
```matlab
nmax_f    % Plane wave truncation (integer, 5-20 typical)
i_fi_f    % Initial frequency index (integer, usually 1)  
i_ff_f    % Final frequency index (integer, usually 1)
a_f       % Lattice constant [m] (0.01-0.05 typical)
he_f      % Plate thickness [m] (0.001-0.01 typical)
E_f       % Young's modulus [Pa] (70e9 for aluminum)
gamma_f   % Mass ratio [-] (0.1-0.5 typical)
ro_f      % Density [kg/m³] (2700 for aluminum)  
ni_f      % Poisson's ratio [-] (0.33 for aluminum)
fr_f      % Resonator frequency [Hz] (100-10000)
eta_p_f   % Loss factor [-] (0.01-0.1 typical)
```

### Lattice Types (Unified Only)
```matlab
'square'      % 4-fold symmetry, 0 resonators (bare plate)
'rectangular' % 2-fold symmetry, 1 resonator, 2:1 aspect ratio
'triangular'  % 3-fold symmetry, 1 resonator, 60° lattice
'hexagonal'   % 6-fold symmetry, 2 resonators, honeycomb
'kagome'      % 3-fold symmetry, 3 resonators, flat bands
```

## 📈 Output Files

Both implementations generate CSV files in `./1_database/`:

### Wave Vector Data  
`X_1_a_YY_h_ZZ_lattice_L_bare_pwe_w_data_full_path.csv`

### Frequency Data
`X_2_a_YY_h_ZZ_lattice_L_bare_pwe_f_data_full_path.csv`

Where:
- `X` = Lattice index (1-5)
- `YY` = Lattice parameter value  
- `ZZ` = Plate thickness value
- `L` = Lattice code (s/r/t/h/k)

## 🧪 Validation and Testing

### Unified Implementation
```matlab
addpath('pwe/pwe_unified_implementation');
test_general_pwe;  % Complete validation suite
```

### Manual Testing
```matlab
% Test with small parameters first
nmax = 5;  % Small truncation for testing
a = 0.02;  % 20mm lattice constant
h = 0.001; % 1mm thickness

% Aluminum parameters
E = 70e9; gamma = 0.1; ro = 2700; ni = 0.33; fr = 1000; eta = 0.01;

% Test unified function
[freq, w_kk] = general_pwe_dispersion('square', nmax, 1, 1, a, h, E, gamma, ro, ni, fr, eta);
```

## 🐛 Common Issues

1. **Out of Memory**: Reduce `nmax_f` parameter
2. **Slow Computation**: Normal for Kagome with high `nmax_f`  
3. **File Not Found**: Check MATLAB path and file locations
4. **Invalid Lattice**: Use exact spelling: 'square', 'rectangular', etc.

## 📚 Documentation Hierarchy

1. **This Index** (`INDEX.md`) - Navigation and quick reference
2. **Main README** (`README.md`) - Directory overview  
3. **PWE Hub** (`pwe/README.md`) - Universal PWE directory guide
4. **Unified Guide** (`pwe/pwe_unified_implementation/README.md`) - Quick start
5. **Technical Docs** (`pwe/pwe_unified_implementation/README_GeneralizedPWE.md`) - Full details
6. **Individual Guide** (`pwe/pwe_individual_functions/README.md`) - Legacy reference

## 👥 Support and Citation

**Author**: Anderson H.R. Ferreira  
**Email**: anderson.ferreira.datascience.83@gmail.com

**Citation**: When using this code, please cite the manuscript and:
```bibtex
@software{ferreira2023unified_pwe,
  author = {Ferreira, Anderson H.R.},
  title = {Unified PWE Implementation for Locally Resonant Sonic Crystals},
  year = {2023},
  note = {Optimized MATLAB implementation for lattice dispersion analysis}
}
```

---

**🚀 Ready to analyze any lattice configuration with optimal performance! 🚀**

*PWE Analysis Suite - Complete Implementation - 2023*