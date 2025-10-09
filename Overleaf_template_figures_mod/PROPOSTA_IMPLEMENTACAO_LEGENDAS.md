# PROPOSTA DE IMPLEMENTAÇÃO - LEGENDAS DE FIGURAS
## Análise Completa dos Templates e Mapeamento de Figuras

**Data:** 2025-10-09
**Objetivo:** Adaptar templates .tex com legendas específicas para cada figura PDF conforme comentário 9 dos revisores sobre tamanho de fontes

---

## 1. ANÁLISE DOS TEMPLATES EXISTENTES

### 1.1 Templates Identificados (9 arquivos)

```
Overleaf_template_figures_mod/
├── cap3_fig_1_mod1_temp.tex  (Single-resonator: square/rect/trian)
├── cap3_fig_1_mod2_temp.tex  (Single-resonator: hex/kagomé)
├── cap3_fig_2_mod1_temp.tex  (Parametric 1: square/rect/trian)
├── cap3_fig_2_mod2_temp.tex  (Parametric 2: hex/kagomé)
├── cap3_fig_3_mod_comp_temp.tex (Comparative all lattices)
├── cap4_fig_1_mod1_temp.tex  (EPWE validation 1)
├── cap4_fig_1_mod2_temp.tex  (EPWE validation 2: hex/kagomé)
├── cap4_fig_2_mod1_temp.tex  (FRF single-resonator)
├── cap4_fig_2_mod2_temp.tex  (FRF multi-resonator)
```

---

## 2. MAPEAMENTO TEMPLATE → FIGURAS PDF

### 2.1 Capítulo 3 - Seção 1: Band Structures (Single-resonator baseline)

**Template:** `cap3_fig_1_mod1_temp.tex`
**Tipo:** 2 subfiguras (a: dispersion, b: wave modes) + legenda TikZ tabular
**Estrutura:**
- Subfigura (a): 0.58\textwidth - Dispersion diagram
- Subfigura (b): 0.38\textwidth - Wave modes
- Legenda: TikZ com retângulos coloridos e linhas

**Figuras mapeadas:**
1. **1_1_disp_frf_square.pdf** (Square lattice, fr = 80 Hz)
   - FBGW 1: f1 = 70.72 Hz, f2 = 93.88 Hz, Δf = 23.16 Hz
   - PBGW 1 (Γ→X): f1 = 61.54 Hz, f2 = 93.88 Hz, Δf = 32.33 Hz
   - PBGW 2 (Γ→X): f1 = 117.91 Hz, f2 = 149 Hz, Δf = 31.09 Hz
   - Caption: "Band structure and wave mode shapes for a square lattice..."
   - Label: `pwe_fem_disp_modal_square`
   - Manuscript: Linha 431

2. **1_2_disp_frf_rect.pdf** (Rectangular lattice, fr = 80 Hz)
   - FBGW 1: f1 = 78.23 Hz, f2 = 95.97 Hz, Δf = 17.74 Hz
   - PBGW 1: f1 = 62.27 Hz, f2 = 95.97 Hz, Δf = 33.70 Hz
   - PBGW 2: f1 = 117.91 Hz, f2 = 150.66 Hz, Δf = 32.64 Hz
   - Caption: "Band structure and wave mode shapes for a rectangular lattice..."
   - Label: `pwe_fem_disp_modal_rect`
   - Manuscript: Linha 487

3. **1_3_disp_frf_trian.pdf** (Triangular lattice, fr = 80 Hz)
   - **PRECISA EXTRAIR VALORES DO MANUSCRITO**
   - Caption: "Band structure and wave mode shapes for a triangular lattice..."
   - Label: `pwe_fem_disp_modal_trian`
   - Manuscript: Linha 532

---

**Template:** `cap3_fig_1_mod2_temp.tex`
**Tipo:** 2 subfiguras + legenda tabular (multi-resonator systems)
**Diferença:** Sistemas com DOIS band gaps completos (FBGW 1 e FBGW 2)

**Figuras mapeadas:**
4. **1_4_disp_frf_hex.pdf** (Hexagonal/Honeycomb, fr = 80 Hz)
   - **FBGW 1:** 37.13--67.24 Hz, Δf = 30.11 Hz
   - **FBGW 2:** 69.84--93.5 Hz, Δf = 23.66 Hz
   - **PBGW 3 (Γ→X):** 69.84--120 Hz, Δf = 50.16 Hz
   - Caption explícito no template atual
   - Label: `pwe_fem_disp_modal_hex`
   - Manuscript: Linha 598

5. **1_5_disp_frf_kag.pdf** (Kagomé, fr = 80 Hz)
   - **PRECISA EXTRAIR VALORES DO MANUSCRITO**
   - Três ressonadores → dual band gaps esperados
   - Label esperado: `pwe_fem_disp_modal_kag`
   - Manuscript: Linha 692

---

### 2.2 Capítulo 3 - Seção 2: Parametric Analysis (15 frequencies)

**Template:** `cap3_fig_2_mod1_temp.tex`
**Tipo:** 6 subfiguras (a-c: dispersion @ 3 freq, d-f: edge frequencies & FBGW)
**Estrutura complexa:** Duas linhas de legendas (uma para a-c, outra para d-f)

**Figuras mapeadas:**
6. **2_1_disp_frf_square.pdf** (Square parametric)
   - (a) fr = 10 Hz, (b) fr = 105 Hz, (c) fr = 150 Hz
   - (d) Lower edge f1 vs fr
   - (e) Upper edge f2 vs fr
   - (f) FBGW 1 vs fr: **MÁXIMO = 32.10 Hz @ fr = 105 Hz**
   - Caption: "Parametric analysis... maximum Δfg = 32.10 Hz at fr = 105 Hz"
   - Label: `pwe_disp_square_all_res`
   - Manuscript: Linha 445

7. **2_2_disp_frf_rect.pdf** (Rectangular parametric)
   - (a) fr = 10 Hz, (b) fr = 99 Hz, (c) fr = 150 Hz
   - **MÁXIMO = 20.53 Hz @ fr = 99 Hz**
   - Label: `pwe_disp_rect_all_res`
   - Manuscript: Linha 496

8. **2_3_disp_frf_trian.pdf** (Triangular parametric)
   - **PRECISA EXTRAIR VALORES (3 freq + máximo)**
   - Label: `pwe_disp_trian_all_res`

---

**Template:** `cap3_fig_2_mod2_temp.tex`
**Tipo:** 6 subfiguras (DUAL band gaps - FBGW 1 e FBGW 2)
**Diferença crítica:** Legenda para d-f distingue FBGW 1 (círculos) e FBGW 2 (quadrados)

**Figuras mapeadas:**
9. **2_4_disp_frf_hex.pdf** (Honeycomb parametric - dual band gaps)
   - (a) fr = 10 Hz, (b) fr = 60 Hz, (c) fr = 150 Hz
   - **FBGW 1 MÁXIMO:** Δf = 14.28 Hz @ fr = 59 Hz
   - **FBGW 2 MÁXIMO:** Δf = 28.67 Hz @ fr = 137 Hz
   - Caption explícito no template
   - Label: `pwe_disp_hex_all_res12`

10. **2_5_disp_frf_kag.pdf** (Kagomé parametric - dual band gaps)
    - **PRECISA EXTRAIR VALORES (3 freq + 2 máximos)**
    - FBGW 1 e FBGW 2 esperados
    - Label esperado: `pwe_disp_kag_all_res12`

---

### 2.3 Capítulo 3 - Seção 3: Comparative Analysis

**Template:** `cap3_fig_3_mod_comp_temp.tex`
**Tipo:** 1 figura única comparativa + legenda tabular complexa (3 linhas)
**Estrutura:** Todas as 5 lattices em um único gráfico

**Figura mapeada:**
11. **0_disp_comp_lattices.pdf** (Comparative all lattices)
    - Square FBGW 1: Δf = 32.10 Hz
    - Rectangular FBGW 1: Δf = 20.53 Hz
    - **Triangular FBGW 1: Δf = 55.40 Hz** (MÁXIMO!)
    - Honeycomb FBGW 1: Δf = 14.28 Hz
    - Honeycomb FBGW 2: Δf = 28.67 Hz
    - Kagomé FBGW 1: Δf = 6.54 Hz
    - Kagomé FBGW 2: Δf = 6.85 Hz
    - Caption completo no template
    - Label: `comp_all_latices_FBGW 1`
    - Manuscript: Linha 771

---

### 2.4 Capítulo 4 - Seção 1: EPWE Validation

**Template:** `cap4_fig_1_mod1_temp.tex`
**Tipo:** 6 subfiguras (a-c: disp/imped/FRF, d-f: mode shapes @ 3 points)
**Novidade:** Inclui impedância e FRF além de dispersion

**Figuras mapeadas:**
12. **1_1_disp_frf_square_pwe_epwe_recep1.pdf** (Square EPWE, fr = 40 Hz)
    - **PRECISA CRIAR NOVO TEMPLATE - NÃO ESTÁ LISTADO!**
    - Manuscript: Linha 901

13. **1_2_disp_frf_rect_pwe_epwe_recep1.pdf** (Rect EPWE, fr = 40 Hz)
    - (a) Dispersion PWE/EPWE, (b) Impedance, (c) Receptance FRF
    - Points: As, Bs, Cs para mode shapes
    - Label esperado: `epwe_frf_modes_rect`
    - Manuscript: Linha 929

14. **1_3_disp_frf_trian_pwe_epwe_recep1.pdf** (Trian EPWE, fr = 40 Hz)
    - **PRECISA EXTRAIR VALORES**
    - Manuscript: Linha 957

15. **1_4_disp_frf_hex_pwe_epwe_recep1.pdf** (Hex EPWE)
    - Aparece em DOIS templates diferentes!
    - Manuscript: Linha 985

---

**Template:** `cap4_fig_1_mod2_temp.tex`
**Tipo:** 6 subfiguras (dual band gaps - FBGW 1 e FBGW 2)

**Figuras mapeadas:**
16. **1_4_disp_frf_hex_pwe_epwe_recep1.pdf** (DUPLICADO - Hex EPWE, fr = 30 Hz)
    - FBGW 1 e FBGW 2
    - Caption no template: fr = 30 Hz
    - Label: `epwe_frf_modes_hex`

17. **1_5_disp_frf_kag_pwe_epwe_recep1.pdf** (Kagomé EPWE)
    - **PRECISA EXTRAIR VALORES**
    - Dual band gaps esperados
    - Manuscript: Linha 1013

---

### 2.5 Capítulo 4 - Seção 2: FRF Comparisons

**Template:** `cap4_fig_2_mod1_temp.tex`
**Tipo:** 3 subfiguras (FRF @ 3 frequências)
**Estrutura:** Comparação Bare plate vs LRSC plate

**Figuras mapeadas:**
18. **2_1_disp_frf_square_3_receps.pdf** (Square FRF comparison)
    - (a) LRSC 40 Hz, (b) LRSC 100 Hz, (c) LRSC 150 Hz
    - Peak markers: bare plate (red circles) vs LRSC (green circles)
    - **PRECISA EXTRAIR VALORES SE HOUVER**

19. **2_2_disp_frf_rect_3_receps.pdf** (Rect FRF comparison)
    - **PRECISA EXTRAIR VALORES**

20. **2_3_disp_frf_trian_3_receps.pdf** (Trian FRF comparison)
    - **PRECISA EXTRAIR VALORES**

---

**Template:** `cap4_fig_2_mod2_temp.tex`
**Tipo:** 3 subfiguras (FRF dual band gaps - FBGW 1 e FBGW 2)
**Diferença:** Marcadores diferentes (círculos FBGW 1, quadrados FBGW 2)

**Figuras mapeadas:**
21. **2_4_disp_frf_hex_3_receps.pdf** (Honeycomb FRF dual gaps)
    - (a) fr = 30 Hz, (b) fr = 50 Hz, (c) fr = 150 Hz
    - Caption no template presente

22. **2_5_disp_frf_kag_3_receps.pdf** (Kagomé FRF dual gaps)
    - **ATENÇÃO:** Arquivo listado como `2_5_disp_frf_kag.pdf` (sem `_3_receps`)
    - **PRECISA VERIFICAR NOME CORRETO**

---

## 3. PROBLEMAS IDENTIFICADOS

### 3.1 Inconsistências no Mapeamento Original do Usuário

**Problema 1:** Template `cap4_fig_1_mod1_temp.tex` lista 3 figuras:
```
1_2_disp_frf_rect_pwe_epwe_recep1.pdf
1_3_disp_frf_trian_pwe_epwe_recep1.pdf
1_4_disp_frf_hex_pwe_epwe_recep1.pdf
```
Mas **falta:** `1_1_disp_frf_square_pwe_epwe_recep1.pdf` (presente no manuscrito linha 901)

**Problema 2:** Template `cap4_fig_1_mod2_temp.tex` lista:
```
1_4_disp_frf_hex_pwe_epwe_recep1.pdf  (DUPLICADO!)
1_5_disp_frf_kag_pwe_epwe_recep1.pdf
```
A figura hex aparece em AMBOS os templates mod1 e mod2

**Problema 3:** Template `cap4_fig_2_mod2_temp.tex` lista:
```
2_5_disp_frf_kag.pdf
```
Mas arquivo real parece ser `2_5_disp_frf_kag_3_receps.pdf`

### 3.2 Valores Faltantes no Manuscrito

**Prioridade ALTA - Precisam ser extraídos:**
1. Triangular baseline (1_3_disp_frf_trian.pdf): FBGW, PBGWs
2. Kagomé baseline (1_5_disp_frf_kag.pdf): FBGW 1, FBGW 2
3. Triangular parametric (2_3_disp_frf_trian.pdf): 3 frequências + máximo
4. Kagomé parametric (2_5_disp_frf_kag.pdf): 3 frequências + 2 máximos
5. EPWE figures: valores específicos de As/Bs/Cs points

---

## 4. PROPOSTA DE IMPLEMENTAÇÃO

### 4.1 Estratégia Geral

**Fase 1: Completar Extração de Dados (CRÍTICO)**
1. Ler seções do manuscrito para triangular/kagomé
2. Extrair todos os valores numéricos faltantes
3. Validar consistência com valores já conhecidos
4. Criar tabela master com TODOS os valores

**Fase 2: Adaptação de Templates**
Para CADA template, criar versões específicas para cada figura:
- Substituir placeholders de imagem
- Atualizar valores numéricos nas legendas TikZ
- Adaptar captions
- Corrigir labels

**Fase 3: Integração no Manuscrito**
- Substituir `\includegraphics` simples por blocos completos dos templates
- Verificar compilação LaTeX
- Validar numeração de figuras
- Confirmar referências cruzadas

### 4.2 Estrutura de Nomenclatura para Arquivos Gerados

Proposta:
```
cap3_fig_1_square.tex        (baseado em mod1)
cap3_fig_1_rect.tex          (baseado em mod1)
cap3_fig_1_trian.tex         (baseado em mod1)
cap3_fig_1_hex.tex           (baseado em mod2)
cap3_fig_1_kag.tex           (baseado em mod2)

cap3_fig_2_square.tex        (baseado em mod1)
cap3_fig_2_rect.tex          (baseado em mod1)
cap3_fig_2_trian.tex         (baseado em mod1)
cap3_fig_2_hex.tex           (baseado em mod2)
cap3_fig_2_kag.tex           (baseado em mod2)

cap3_fig_3_comp.tex          (figura comparativa única)

cap4_fig_1_square.tex        (CRIAR mod1 para square!)
cap4_fig_1_rect.tex          (baseado em mod1)
cap4_fig_1_trian.tex         (baseado em mod1)
cap4_fig_1_hex.tex           (baseado em mod2)
cap4_fig_1_kag.tex           (baseado em mod2)

cap4_fig_2_square.tex        (baseado em mod1)
cap4_fig_2_rect.tex          (baseado em mod1)
cap4_fig_2_trian.tex         (baseado em mod1)
cap4_fig_2_hex.tex           (baseado em mod2)
cap4_fig_2_kag.tex           (baseado em mod2)
```

**Total:** 22 arquivos .tex adaptados

### 4.3 Template de Adaptação (Exemplo: Square Baseline)

**Arquivo original:** `cap3_fig_1_mod1_temp.tex`
**Arquivo gerado:** `cap3_fig_1_square.tex`

**Modificações necessárias:**
1. **Linha 15:** `figura_a_SEM_LEGENDA.png` → `1_1_disp_frf_square.pdf`
2. **Linha 23:** `figura_b.png` → (manter ou extrair do PDF original)
3. **Linhas 36, 42, 48:** Atualizar valores de PBGW 1, FBGW 1, PBGW 2
4. **Linha 72:** Caption completo atualizado
5. **Linha 73:** Label = `pwe_fem_disp_modal_square`

---

## 5. RISCOS E MITIGAÇÕES

### Risco 1: Valores Incorretos Extraídos
**Mitigação:** Validação cruzada com tabelas do manuscrito

### Risco 2: Templates Não Cobrem Todos os Casos
**Mitigação:** Identificar casos especiais (square EPWE faltante) e criar template adicional

### Risco 3: Compilação LaTeX com Erros
**Mitigação:** Testar cada arquivo .tex individualmente antes de integrar

### Risco 4: Referências Cruzadas Quebradas
**Mitigação:** Manter labels originais do manuscrito

---

## 6. PRÓXIMOS PASSOS

### Passo 1: VALIDAÇÃO DA PROPOSTA
- Apresentar esta análise ao usuário
- Confirmar estratégia de implementação
- Esclarecer dúvidas sobre problemas identificados

### Passo 2: EXTRAÇÃO DE DADOS FALTANTES
- Buscar no manuscrito: triangular (linhas ~530-560)
- Buscar no manuscrito: kagomé (linhas ~690-730)
- Buscar no manuscrito: valores EPWE (Capítulo 4)

### Passo 3: CRIAÇÃO DE TABELA MASTER
Criar arquivo `VALORES_TODOS_GRAFICOS.csv` com:
```
figura,lattice,fr_Hz,FBGW1_f1,FBGW1_f2,FBGW1_df,FBGW2_f1,FBGW2_f2,FBGW2_df,...
1_1,square,80,70.72,93.88,23.16,,,,...
1_2,rect,80,78.23,95.97,17.74,,,,...
...
```

### Passo 4: IMPLEMENTAÇÃO AUTOMATIZADA
Script Python/bash para gerar 22 arquivos .tex a partir de:
- Templates base (9 arquivos)
- Tabela master de valores
- Mapeamento figura → template

---

## 7. DECISÕES PENDENTES DO USUÁRIO

### Decisão 1: Tratamento de Figuras Duplicadas
**Questão:** `1_4_disp_frf_hex_pwe_epwe_recep1.pdf` aparece em mod1 e mod2
**Opção A:** Manter em ambos com valores diferentes (fr = 40 Hz vs 30 Hz)?
**Opção B:** Corrigir mapeamento (apenas em mod2)?

### Decisão 2: Square EPWE Faltante
**Questão:** Template cap4_fig_1_mod1 não lista square, mas manuscrito usa
**Opção A:** Criar template específico para square EPWE
**Opção B:** Adaptar mod1 para incluir square

### Decisão 3: Nomenclatura Kagomé FRF
**Questão:** `2_5_disp_frf_kag.pdf` vs `2_5_disp_frf_kag_3_receps.pdf`
**Opção A:** Renomear arquivo PDF
**Opção B:** Atualizar template

### Decisão 4: Integração Imediata ou Testes Isolados
**Opção A:** Gerar todos 22 .tex e integrar no manuscrito de uma vez
**Opção B:** Gerar e testar 1-2 exemplos primeiro para validar abordagem

---

## 8. ESTIMATIVA DE ESFORÇO

**Extração de dados:** 30 min (ler manuscrito, extrair valores)
**Criação tabela master:** 15 min
**Adaptação manual de 1 template exemplo:** 10 min
**Automação (script):** 45 min
**Geração de 22 arquivos:** 5 min (automatizado)
**Testes de compilação:** 30 min
**Integração no manuscrito:** 45 min

**TOTAL ESTIMADO:** ~3h

---

## CONCLUSÃO

A análise identificou uma estrutura clara e sistemática nos templates, mas revelou:
1. ✅ Templates bem organizados e reutilizáveis
2. ⚠️ Alguns valores numéricos faltantes no mapeamento
3. ⚠️ Inconsistências em 3 casos (hex duplicado, square EPWE, kag naming)
4. ✅ Caminho claro para automação

**RECOMENDAÇÃO:** Validar proposta antes de prosseguir com implementação.
