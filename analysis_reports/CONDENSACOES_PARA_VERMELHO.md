# CONDENSAÇÕES QUE PRECISAM SER MARCADAS EM VERMELHO

## ETAPA 2 - Seção 3.1 (SR-SDOF Lattices)

### 1. Square Lattice - Mode Shape Analysis (linha ~462)
**Localização:** manuscript_mssp2_vf.tex linha 462
**Status atual:** SEM vermelho
**Texto condensado:**
```
Dispersion analysis reveals local resonance creating FBGW 1 ($\Delta f_{12} = 23.16$ [Hz],
$f_1 = 70.72$ Hz, $f_2 = 93.88$ Hz) with resonator frequency $f_j = 80$ Hz strategically
positioned between mode edges for optimal energy extraction. Mode shapes
(Figure \ref{pwe_fem_disp_modal_square}b) show anti-resonance at point $B_s$, where the
resonator creates destructive interference trapping wave energy and preventing propagation.
```

### 2. Square Lattice - Edge Frequency Evolution (linha ~493)
**Localização:** manuscript_mssp2_vf.tex linha 493
**Status atual:** SEM vermelho
**Texto condensado:**
```
Edge frequency evolution reveals asymmetric band gap formation: $f_1$ increases linearly
with $f_j$ (direct resonator control), while $f_2$ saturates at Bragg limit $f_B = 117.91$ Hz
—an intrinsic geometric ceiling independent of resonator tuning. Maximum bandwidth
$\Delta f_{12} = 32.10$ Hz at $f_j = 105$ Hz represents optimal balance between local
resonance (controlling $f_1$) and geometric dispersion (limiting $f_2$), with subsequent
decay reflecting saturation as $f_2$ approaches $f_B$.
```

### 3. Rectangular Lattice - Parametric Analysis (linha ~551)
**Localização:** manuscript_mssp2_vf.tex linha 551
**Status atual:** SEM vermelho
**Texto condensado:**
```
Parametric analysis (Figure \ref{pwe_disp_rect_all_res}) reveals geometric constraints:
premature bandwidth maximum at $f_j = 99$ Hz (36% penalty vs. square), complete band gap
disappearance at $f_j = 150$ Hz (fundamental frequency cutoff), and compressed operational
range with rapid decay beyond $f_j = 120$ Hz. Aspect ratio creates anisotropic
resonator-plate coupling—reduced $a_2$ direction area weakens flexural mode interaction,
producing directionality-dependent scattering and establishing geometric aspect ratio as a
critical design parameter.
```

### 4. Triangular Lattice - Bandwidth Stability (linha ~611)
**Localização:** manuscript_mssp2_vf.tex linha 611
**Status atual:** SEM vermelho
**Texto condensado:**
```
Exceptional bandwidth stability (Figure \ref{pwe_disp_trian_all_res}f): unlike
square/rectangular lattices with rapid decay, triangular maintains bandwidth >20 Hz across
extended frequency ranges through six-fold rotational symmetry providing multiple equivalent
scattering pathways. This creates robust wave-resonator coupling less sensitive to frequency
detuning, demonstrating that lattice symmetry dominates over unit cell area—despite smaller
area than square, superior symmetry enables area-normalized efficiency exceeding simple area
scaling.
```

---

## ETAPA 3 - Seção 3.2 (MR-SDOF Lattices)

### 5. Honeycomb - Dual-Resonator Introduction (linha ~626)
**Localização:** manuscript_mssp2_vf.tex linha 626
**Status atual:** SEM vermelho
**Texto condensado:**
```
Honeycomb dual-resonator geometry positions two identical resonators at
\( \mathbf{r_1} = a(0, 1/2) \) and \( \mathbf{r_2} = -a(0, 1/2) \), creating symmetric
coupling enabling both in-phase and anti-phase oscillation modes. Unlike single-resonator
systems with independent plate interaction, dual-resonator systems exhibit collective
behavior (cooperative/competitive oscillations) creating distinct eigenfrequencies that
generate multiple band gaps. Increased stiffness \( k_j = 1969 \) [N/m] maintains target
frequency \( f_j = 80 \) [Hz] accounting for reduced effective mass per resonator.
```

### 6. Honeycomb - Dual Band Gap Mechanisms (linha ~662)
**Localização:** manuscript_mssp2_vf.tex linha 662
**Status atual:** SEM vermelho
**Texto condensado:**
```
Breakthrough capability (Figure \ref{pwe_fem_disp_modal_hex}a): simultaneous two distinct
full band gaps (FBGW 1: $\Delta f_{23} = 2.30$ Hz, FBGW 2: $\Delta f_{34} = 17.23$ Hz)
—qualitative leap beyond single-resonator systems with only one primary band gap. Anti-phase
coupling mode (point $B_h$, Figure \ref{pwe_fem_disp_modal_hex}b) creates FBGW 1 through
destructive interference where resonators oscillate $180°$ out-of-phase, trapping energy
and preventing propagation. In-phase coupling mode generates stronger, broader FBGW 2
through collective resonance with coherent resonator motion maximizing energy extraction.
Dual-resonator systems access different regimes via frequency adjustment: low-frequency
($f_j < 50$ Hz, anti-phase dominant), intermediate ($50 < f_j < 100$ Hz, dual band gap
coexistence), high-frequency ($f_j > 100$ Hz, in-phase dominant), enabling single geometry
optimization for different frequency ranges.
```

### 7. Honeycomb - Parametric Analysis (linha ~697)
**Localização:** manuscript_mssp2_vf.tex linha 697
**Status atual:** SEM vermelho
**Texto condensado:**
```
Parametric analysis (Figure \ref{pwe_disp_hex_all_res12}) reveals three modal regimes:
(a) $f_j = 10$ Hz—anti-phase dominant producing only FBGW 1; (b) $f_j = 60$ Hz—optimal
dual-mode where FBGW 1 peaks ($\Delta f_{23} = 14.17$ Hz) through constructive
anti-phase/in-phase interference, creating broadband blocking impossible in single-resonator
systems; (c) $f_j = 150$ Hz—in-phase dominant with powerful FBGW 2 ($\Delta f_{34} = 23.63$ Hz)
while FBGW 1 vanishes. Edge evolution (d-e) shows lower edges ($f_2$, $f_3$) with direct
resonator control (linear) and upper edges ($f_3$, $f_4$) with saturation at geometric limits.
Maximum FBGW 2 of $\Delta f_{34} = 27.73$ Hz at $f_j = 140$ Hz represents 46\% improvement
over best single-resonator (square: 30.90 Hz), establishing collective resonance superiority.
FBGW 1 maximum coinciding with FBGW 2 emergence reveals constructive modal interaction
—synergistic coupling where second mode enhances rather than competes.
```

### 8. Kagomé - Triple-Resonator Introduction (linha ~700)
**Localização:** manuscript_mssp2_vf.tex linha 700
**Status atual:** SEM vermelho
**Texto condensado:**
```
Kagomé triple-resonator architecture positions three resonators at
\( \mathbf{r_1} = a(-1/2, -\sqrt{3}/6) \), \( \mathbf{r_2} = a(-1/2, -\sqrt{3}/6) \),
and \( \mathbf{r_3} = a(\sqrt{3}/3, 0) \) with 120° triangular symmetry creating intricate
phase relationships fundamentally different from honeycomb. Three-fold rotational symmetry
produces narrow but well-defined band gaps through unique interference patterns, effective
for precise frequency-selective attenuation. FIBZ coordinates \( \Gamma = (0,0) \),
\( X = \pi/a(1/\sqrt{3},0) \), \( M = \pi/a(1/2\sqrt{3},1/2) \),
\( X' = \pi/a(1/2\sqrt{3},1/2) \), \( M' = \pi/a(0,2/3) \) with three identical resonators
(\( k_j = 246.16 \) N/m) following path \( M' \longrightarrow \Gamma \longrightarrow X \longrightarrow M \longrightarrow X' \longrightarrow M' \);
adjusted frequency \( f_j = 80 \) Hz enables direct honeycomb comparison.
```

### 9. Kagomé - Fundamental Limitation (linha ~724)
**Localização:** manuscript_mssp2_vf.tex linha 724
**Status atual:** SEM vermelho
**Texto condensado:**
```
Fundamental limitation (Figure \ref{pwe_fem_disp_modal_kag}a): despite 50\% more resonators
than honeycomb, only two complete band gaps emerge—FBGW 1 (\( f_3 \)-\( f_4 \),
\( \Delta f_{34} \)) and FBGW 2 (\( f_4 \)-\( f_5 \), \( \Delta f_{45} \))—plus partial
PBGW 1 (30–40 Hz) from three-resonator coupling creating hybrid states with selective
directional attenuation, contrasting honeycomb's broader band gaps. At \( f_j = 80 \) Hz,
both FBGW 1/FBGW 2 coexist (honeycomb-like) but with characteristic narrow widths
(particularly FBGW 2), demonstrating three-resonator configuration creates highly
frequency-selective attenuation suitable for precise frequency targeting rather than
broadband applications.
```

### 10. Kagomé - Performance Ceiling (linha ~766)
**Localização:** manuscript_mssp2_vf.tex linha 766
**Status atual:** SEM vermelho
**Texto condensado:**
```
Modal coupling evolution (Figure \ref{pwe_disp_kag_all_res}d-e): FBGW 1 emerges between
modes \( f_3 \)-\( f_4 \), FBGW 2 spans \( f_4 \)-\( f_5 \), with shared mode \( f_4 \)
indicating overlapping resonance regions contrasting with honeycomb's distinct frequency
separation. Geometric frustration penalty (f): maximum FBGW 1 (\( \Delta f_{34} = 6.54 \) Hz
at \( f_j = 35 \) Hz) and FBGW 2 (\( \Delta f_{45} = 6.85 \) Hz at \( f_j = 101 \) Hz)
both achieve only ~7 Hz widths with optimal point separation (\( \Delta f_j = 66 \) Hz)
smaller than honeycomb (77 Hz), indicating reduced modal separation. Performance ceiling:
both band gaps converging to ~7 Hz represents three-fold symmetry constraint where triangular
geometry forces competing phase relationships preventing maximum coupling efficiency, unlike
dual-resonator systems with independent anti-phase/in-phase optimization.
```

---

## AÇÃO NECESSÁRIA

Marcar TODOS os 10 textos acima com `\textcolor{red}{...}` no manuscript_mssp2_vf.tex.

**Justificativa:**
Estas são todas condensações substantivas realizadas nas ETAPAs 2 e 3 que modificam
significativamente o texto original submetido (manuscript_mssp2_sub.tex). Os revisores
precisam ver claramente onde o texto foi modificado para atender ao Comment (10) sobre
redução da Seção 3.

**Próximo passo:**
Aplicar `\textcolor{red}{...}` em todas essas 10 localizações.
