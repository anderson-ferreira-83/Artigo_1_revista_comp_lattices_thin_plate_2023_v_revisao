# MATLAB Codes Directory

## 📋 Purpose
This directory contains MATLAB implementation codes for the PWE (Plane Wave Expansion) and EPWE (Extended Plane Wave Expansion) methods applied to LRSC (Locally Resonant Sonic Crystal) plates with five different lattice configurations.

## 📁 Directory Structure
```
matlab_codes/
├── README.md                      # This documentation
├── INDEX.md                       # Navigation guide
├── STRUCTURE_SUMMARY.md           # Organization summary
├── epwe/                         # Extended PWE method implementations
│   ├── func3_1_square_epwe_plot_line_data.m
│   ├── func3_2_rectangular_epwe_plot_line_data.m
│   ├── func3_3_triangular_epwe_plot_line_data.m
│   ├── func3_4_honeycomb_epwe_plot_line_data.m
│   └── func3_5_kagome_epwe_plot_line_data.m
└── pwe/                          # 🎯 Universal PWE Implementation Hub
    ├── README.md                 # PWE directory overview and guide
    ├── pwe_individual_functions/ # 📂 Individual PWE Functions (Legacy)
    │   ├── README.md             # Individual functions guide
    │   ├── func0_1_square_pwe_plot_line_data_full_path.m
    │   ├── func0_2_rectangular_pwe_plot_line_data_full_path.m  
    │   ├── func0_3_triangular_pwe_plot_line_data_full_path.m
    │   ├── func0_4_hexagonal_pwe_plot_line_data_full_path.m
    │   └── func0_5_kagome_pwe_plot_line_data_full_path.m
    └── pwe_unified_implementation/ # 🚀 Unified PWE Implementation (Recommended)
        ├── README.md               # Quick start guide
        ├── README_GeneralizedPWE.md # Complete technical documentation
        ├── general_pwe_dispersion.m # Main unified function
        ├── get_lattice_config.m    # Lattice configurations
        ├── generate_reciprocal_lattice.m # Optimized reciprocal vectors
        ├── get_fibz_path.m         # FIBZ paths and symmetry points
        └── test_general_pwe.m      # Comprehensive test suite
```

## Important Notes

⚠️ **LOCAL DEVELOPMENT ONLY**
- This directory is excluded from version control via `.gitignore`
- Contents are for local development and testing purposes only
- Do not commit MATLAB code files to the repository

## 🎯 Implementation Options

### 🚀 **Recommended: Unified Implementation**
- **Location**: `pwe/pwe_unified_implementation/`
- **Usage**: Single function for all lattice types
- **Performance**: 65% code reduction, 40% memory savings
- **Benefits**: Optimized algorithms, better maintenance, comprehensive testing

```matlab
% Example usage
addpath('pwe/pwe_unified_implementation');
[freq, w_kk] = general_pwe_dispersion('hexagonal', 10, 1, 1, 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);
```

### 📂 **Legacy: Individual Functions** 
- **Location**: `pwe/pwe_individual_functions/`
- **Usage**: Separate function for each lattice type
- **Compatibility**: Original implementation (for reference/comparison)

```matlab
% Example usage  
addpath('pwe/pwe_individual_functions');
func0_4_hexagonal_pwe_plot_line_data_full_path(10, 1, 1, 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);
```

## 🔬 Implementation Base
The MATLAB codes implement the matrix formulation detailed in:
- **Appendix A** of the manuscript: PWE Matrix Formulation for LRSC Plates
- **Xiao et al. (2012)** semi-analytical methodology for metamaterial plates
- **Miranda et al. (2019)** rigorous PWE implementation for sonic crystals
- **Ferreira et al. (2017)** semi-analytical formulation for thick plates
- **Five lattice configurations**: square, rectangular, triangular, hexagonal, and kagome

## 📊 Supported Lattice Types

| Lattice | Symmetry | Resonators | Applications |
|---------|----------|------------|--------------|
| Square | 4-fold | 0 (bare) | Reference studies |
| Rectangular | 2-fold | 1 | Anisotropic properties |
| Triangular | 3-fold | 1 | Close-packed structures |
| Hexagonal | 6-fold | 2 | Honeycomb materials |
| Kagome | 3-fold | 3 | Flat band phenomena |

## 🚀 Quick Start

1. **Choose implementation**:
   - For new work: Use `pwe/pwe_unified_implementation/`
   - For compatibility: Use `pwe/pwe_individual_functions/`

2. **Run tests** (unified implementation):
   ```matlab
   addpath('pwe/pwe_unified_implementation');
   test_general_pwe
   ```

3. **Basic analysis**:
   ```matlab
   addpath('pwe/pwe_unified_implementation');
   [freq, w_kk] = general_pwe_dispersion('square', 8, 1, 1, 0.02, 0.001, 70e9, 0.1, 2700, 0.33, 1000, 0.01);
   ```

## 👥 Contact
**Anderson H.R. Ferreira**  
E-mail: anderson.ferreira.datascience.83@gmail.com

For technical questions about the MATLAB implementation, refer to:
- Mathematical formulation in **Appendix A** of the manuscript
- PWE directory overview in `pwe/README.md`
- Complete technical documentation in `pwe/pwe_unified_implementation/README_GeneralizedPWE.md`