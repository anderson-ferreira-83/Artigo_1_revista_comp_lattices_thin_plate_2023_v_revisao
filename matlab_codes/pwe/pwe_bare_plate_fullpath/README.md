# Individual PWE Functions - Separate Implementation

## 📋 Overview

This directory contains the original individual PWE (Plane Wave Expansion) functions for different lattice configurations. Each function is specialized for a specific lattice type and maintains the original implementation structure.

## 📁 File Structure

```
pwe_individual_functions/
├── func0_1_square_pwe_plot_line_data_full_path.m      # Square lattice PWE
├── func0_2_rectangular_pwe_plot_line_data_full_path.m # Rectangular lattice PWE  
├── func0_3_triangular_pwe_plot_line_data_full_path.m  # Triangular lattice PWE
├── func0_4_hexagonal_pwe_plot_line_data_full_path.m   # Hexagonal lattice PWE
├── func0_5_kagome_pwe_plot_line_data_full_path.m      # Kagome lattice PWE
└── README.md                                           # This documentation
```

## 🔧 Individual Function Usage

### Square Lattice (Bare Plate Analysis)
```matlab
func0_1_square_pwe_plot_line_data_full_path(nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

### Rectangular Lattice (Aspect Ratio 2:1)
```matlab
func0_2_rectangular_pwe_plot_line_data_full_path(nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

### Triangular Lattice (60° Symmetry)
```matlab
func0_3_triangular_pwe_plot_line_data_full_path(nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

### Hexagonal Lattice (Honeycomb, 2 Resonators)
```matlab
func0_4_hexagonal_pwe_plot_line_data_full_path(nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

### Kagome Lattice (3 Resonators, Flat Bands)
```matlab
func0_5_kagome_pwe_plot_line_data_full_path(nmax_f, i_fi_f, i_ff_f, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

## 📊 Lattice Specifications

| Function | Lattice | Unit Cell | Resonators | Output Files |
|----------|---------|-----------|------------|-------------|
| func0_1  | Square | a × a | 0 (bare) | `1_1_a_XX_h_YY_lattice_s_*` |
| func0_2  | Rectangular | a × 0.5a | 1 | `2_1_a_XX_h_YY_lattice_r_*` |
| func0_3  | Triangular | a²√3/2 | 1 | `3_1_a_XX_h_YY_lattice_t_*` |
| func0_4  | Hexagonal | 3a²√3/2 | 2 | `4_1_a_XX_h_YY_lattice_h_*` |
| func0_5  | Kagome | 2a²√3 | 3 | `5_1_a_XX_h_YY_lattice_k_*` |

## 🔢 Common Input Parameters

| Parameter | Type | Units | Description |
|-----------|------|-------|-------------|
| `nmax_f` | integer | - | Plane wave truncation order |
| `i_fi_f` | integer | - | Initial frequency index (reserved) |
| `i_ff_f` | integer | - | Final frequency index (reserved) |
| `a_f` | double | m | Primary lattice constant |
| `he_f` | double | m | Plate thickness |
| `E_f` | double | Pa | Young's modulus |
| `gamma_f` | double | - | Resonator mass ratio |
| `ro_f` | double | kg/m³ | Plate material density |
| `ni_f` | double | - | Poisson's ratio |
| `fr_f` | double | Hz | Resonator frequency |
| `eta_p_f` | double | - | Structural loss factor |

## 📤 Output Files

Each function automatically generates two CSV files:
- **Wave Vector Data**: `X_1_a_XX_h_YY_lattice_Y_bare_pwe_w_data_full_path.csv`
- **Frequency Data**: `X_2_a_XX_h_YY_lattice_Y_bare_pwe_f_data_full_path.csv`

Where:
- `X` = Function index (1-5)
- `XX` = Lattice constant value
- `YY` = Plate thickness value  
- `Y` = Lattice code (s/r/t/h/k)

## 📈 Example Usage

```matlab
% Material parameters (Aluminum plate)
nmax_f = 10;         % Plane wave truncation
a_f = 0.02;          % 20mm lattice constant
he_f = 0.001;        % 1mm plate thickness
E_f = 70e9;          % 70 GPa Young's modulus
gamma_f = 0.1;       % 10% mass ratio
ro_f = 2700;         % 2700 kg/m³ density
ni_f = 0.33;         % 0.33 Poisson's ratio
fr_f = 1000;         % 1 kHz resonator frequency
eta_p_f = 0.01;      % 1% loss factor

% Analyze square lattice
func0_1_square_pwe_plot_line_data_full_path(nmax_f, 1, 1, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);

% Analyze triangular lattice
func0_3_triangular_pwe_plot_line_data_full_path(nmax_f, 1, 1, a_f, he_f, E_f, gamma_f, ro_f, ni_f, fr_f, eta_p_f);
```

## ⚠️ Important Notes

1. **Language Mixing**: Some functions contain mixed Portuguese/English comments
2. **Code Duplication**: ~85% code overlap between functions
3. **Memory Usage**: Each function loads full matrices independently
4. **Maintenance**: Changes must be applied to all 5 functions

## 🔄 Migration Recommendation

For new projects, consider using the **unified implementation** in `../pwe_unified_implementation/` which provides:
- Single function interface
- Better computational performance  
- Reduced memory usage
- Consistent documentation
- Easier maintenance

## 📚 References

1. Xiao, Y., Wen, J., & Wen, X. (2012). "Sound transmission loss analysis of metamaterial thin plates with periodic resonators using a semi-analytical method". *Journal of Sound and Vibration*, 331(25), 5408–5423.

2. Xiao, Y., Wen, J., & Wen, X. (2012). "Flexural wave band gaps in locally resonant thin plates with periodically attached spring–mass resonators". *Journal of Physics D: Applied Physics*, 45(19), 195401.

3. Ferreira, A.H.R., Dos Santos, J.M.C., Miranda, E.J.P., & Ramos, R. (2017). "Semi-analytical formulation for sound transmission loss analysis through a thick plate with periodically attached spring-mass resonators". Internal Report, University Project.

4. Miranda, E.J.P., Ferreira, A.H.R., Dos Santos, J.M.C., & Ramos, R. (2019). "Plane Wave Expansion (PWE) method for locally resonant sonic crystals in thin elastic plates". *Journal of Physics D: Applied Physics*, 52(19), 195401.

## 👥 Author

**Anderson H.R. Ferreira**  
E-mail: anderson.ferreira.datascience.83@gmail.com

---

*Individual PWE Functions - Original Implementation - 2023*