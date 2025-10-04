# Instruções de Formatação para o Artigo

## Formatação LaTeX Importante

### Notação k(ω)
- Sempre usar `k(\boldsymbol{\omega})` (com omega em negrito)
- Não usar `k(\mathbf{\omega})` ou `k(\omega)` sem negrito
- Esta notação aparece principalmente em:
  - Linha 202: Equação EPWE
  - Linha 806: Descrição das curvas de dispersão
  - Linha 1229: Apêndice B sobre EPWE

### Comandos de Verificação
Para verificar ocorrências:
```bash
grep -n "k(.*omega.*)" manuscript_mssp2_vf.tex
```

## Template para Response to Reviewers

### Formatação Eficiente e Profissional
**Template validado em 2025-10-04** - Formato sóbrio e formal sem overflow

**Problema:** tcolorbox causa overflow vertical (texto cortado nas margens) quando respostas são longas, e a opção `breakable` não está disponível em todas versões do TeX Live.

**Solução:** Usar ambientes customizados simples com linhas coloridas horizontais.

```latex
\documentclass[11pt,a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[margin=2.5cm]{geometry}
\usepackage{xcolor}
\usepackage{enumitem}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{hyperref}
\usepackage{fancyhdr}
\usepackage{times}
\usepackage{amssymb}

% Define colors
\definecolor{reviewercolor}{RGB}{52, 73, 94}
\definecolor{responsecolor}{RGB}{39, 174, 96}
\definecolor{changescolor}{RGB}{230, 126, 34}
\definecolor{redtext}{RGB}{220, 53, 69}

% Simple box environments - NO tcolorbox needed
\newenvironment{reviewerbox}{%
    \par\medskip\noindent{\color{reviewercolor}\rule{\linewidth}{2pt}}\par
    \noindent{\color{reviewercolor}\bfseries Reviewer Comment}\par\smallskip
}{%
    \par\noindent{\color{reviewercolor}\rule{\linewidth}{0.5pt}}\medskip
}

\newenvironment{responsebox}{%
    \par\medskip\noindent{\color{responsecolor}\rule{\linewidth}{2pt}}\par
    \noindent{\color{responsecolor}\bfseries Response}\par\smallskip
}{%
    \par\noindent{\color{responsecolor}\rule{\linewidth}{0.5pt}}\medskip
}

\newenvironment{changesbox}{%
    \par\medskip\noindent{\color{changescolor}\rule{\linewidth}{2pt}}\par
    \noindent{\color{changescolor}\bfseries Manuscript Changes}\par\smallskip
}{%
    \par\noindent{\color{changescolor}\rule{\linewidth}{0.5pt}}\medskip
}
```

**Vantagens:**
- Nunca causa overflow vertical
- Quebra automaticamente entre páginas
- Mais sóbrio e formal
- Compatível com todas versões LaTeX
- Compila mais rápido

**Uso:**
```latex
\begin{reviewerbox}
Texto do comentário do revisor...
\end{reviewerbox}

\begin{responsebox}
Nossa resposta detalhada...
\end{responsebox}

\begin{changesbox}
Modificações no manuscrito...
\end{changesbox}
```

## Análise Completa do Manuscrito (2025-07-29)

### PONTOS FORTES DO TRABALHO

1. **Contribuição Científica Original e Significativa**
   - Primeira análise comparativa sistemática de 5 configurações de lattice para metamateriais
   - Estabelece hierarquia quantitativa de desempenho inédita na literatura
   - Framework unificado PWE/EPWE com validação FEM

2. **Rigor Matemático e Metodológico**
   - Formulação matemática sólida baseada em teoria de Kirchhoff-Love
   - Implementação detalhada de PWE e EPWE com convergência demonstrada
   - Validação numérica rigorosa com erro < 1% entre métodos

3. **Resultados Quantitativos Excepcionais**
   - Lattice triangular: 73% melhor que square, 270% melhor que rectangular
   - Eficiência computacional: 1800-5700× mais rápido que FEM
   - Kagomé: atenuação máxima de -292.65 dB

4. **Aplicabilidade Prática**
   - Parâmetros realistas para impressão 3D (Vero White Plus)
   - Guidelines claros para seleção de lattice por aplicação
   - Framework de decisão quantitativo (Apêndice A.3)

5. **Estrutura e Apresentação**
   - Organização lógica e progressiva
   - Figuras de alta qualidade com informações detalhadas
   - Tabelas comparativas abrangentes

### PONTOS DE ATENÇÃO (MELHORIAS RECOMENDADAS)

1. **Clareza em Seções Técnicas**
   - Seções 2.3 e 2.4 (PWE/EPWE) muito densas matematicamente
   - Poderia beneficiar de mais explicações físicas intermediárias
   - Sugestão: adicionar diagramas conceituais

2. **Transições entre Seções**
   - Algumas transições abruptas (ex: Seção 3 para 4)
   - Já foi adicionado comentário sobre EPWE na Seção 2.4
   - Considerar adicionar mais conectores

3. **Discussão de Limitações**
   - Limitações mencionadas brevemente nas conclusões
   - Poderia expandir discussão sobre:
     * Efeitos de imperfeições de fabricação
     * Influência de não-linearidades
     * Escalabilidade para outras faixas de frequência

4. **Referências Bibliográficas**
   - Algumas referências recentes (2022-2024) poderiam ser adicionadas
   - Verificar formatação consistente das citações

### PONTOS FRACOS E LACUNAS

1. **Validação Experimental**
   - Falta validação experimental dos resultados
   - Apenas simulações numéricas apresentadas
   - Critical para publicação em revista top-tier

2. **Análise de Sensibilidade**
   - Não há estudo sistemático de sensibilidade paramétrica
   - Como variações em propriedades do material afetam resultados?
   - Robustez das conclusões não demonstrada

3. **Comparação com Literatura**
   - Falta comparação quantitativa com outros trabalhos
   - Não posiciona claramente avanços vs. estado da arte
   - Tabela comparativa seria valiosa

4. **Aspectos Computacionais**
   - Detalhes de implementação não fornecidos
   - Código não disponibilizado
   - Reprodutibilidade limitada

5. **Aplicações Específicas**
   - Exemplos genéricos, falta caso de estudo detalhado
   - Não demonstra aplicação em problema real
   - Análise custo-benefício ausente

### RECOMENDAÇÕES PRIORITÁRIAS

1. **ALTA PRIORIDADE**
   - Adicionar validação experimental (mesmo que preliminar)
   - Incluir análise de sensibilidade paramétrica
   - Expandir comparação com literatura

2. **MÉDIA PRIORIDADE**
   - Melhorar clareza das seções técnicas
   - Adicionar caso de estudo específico
   - Disponibilizar material suplementar

3. **BAIXA PRIORIDADE**
   - Refinar transições entre seções
   - Atualizar referências mais recentes
   - Adicionar glossário de símbolos

### AVALIAÇÃO GERAL

O manuscrito representa uma contribuição significativa e original ao campo de metamateriais. A qualidade técnica é excelente, com rigor matemático e resultados quantitativos impressionantes. As principais limitações são a falta de validação experimental e análise de sensibilidade. Com essas adições, o trabalho tem potencial para publicação em revista de alto impacto na área.

**Nota Global: 8.5/10**

## Histórico de Alterações

### 2025-10-04 - Response Letter Profissional com Template Eficiente
**Criado documento completo response_to_reviewers.tex (24 páginas) com formatação otimizada**

#### Template de Formatação
- Desenvolvido template sóbrio e formal usando linhas coloridas simples
- Removido tcolorbox (causava overflow vertical)
- Ambientes customizados: reviewerbox, responsebox, changesbox
- Zero overflow, quebra automática entre páginas
- Validado e documentado na seção "Template para Response to Reviewers"

#### Conteúdo do Response Letter
- 10 comentários respondidos point-by-point com localização exata das modificações
- Estrutura: Reviewer Comment → Response → Manuscript Changes
- Cores profissionais: azul escuro (reviewer), verde (response), laranja (changes)
- Header com número do manuscrito: MSSP-25-4032
- Todas referências a Xiao2012 incluídas (citações ainda não compiladas - aguardando mybibfile.bib)
- Correção de referência quebrada: `\ref{multi\_material\_analysis}` → `Appendix C`

#### Arquivo Gerado
- **response_to_reviewers.pdf**: 24 páginas, 188 KB
- Compilação limpa sem erros críticos
- 5 Overfull \hbox menores (aceitáveis, não afetam legibilidade)
- Pronto para submissão

### 2025-10-04 - Reorganização da Seção 3.3 para Fluxo Lógico de Análise Comparativa
**Reestruturação completa para responder ao Comentário 1 dos revisores de forma pedagogicamente efetiva**

#### Objetivo
Reorganizar a Seção 3.3 (Comparative analysis of band gaps bandwidths) para apresentar um fluxo narrativo lógico que justifique naturalmente a necessidade de análise de relative bandwidth, respondendo à crítica do revisor sobre comparação injusta de absolute bandwidth.

#### Problema Identificado
**Estrutura anterior confusa:**
- Definia relative bandwidth logo no início (linha 778)
- Apresentava extensa análise de absolute bandwidth (linhas 787-819)
- Só então retornava para apresentar análise de relative bandwidth (linha 821+)
- Quebrava lógica narrativa: leitor via definição, esquecia durante análise absolute, voltava depois

#### Solução Implementada - Nova Estrutura Lógica

**1. Introdução Dual-Metric (Linha 778 - novo parágrafo)**
- Apresenta framework com duas métricas complementares
- Brief mention: absolute (FBGW) e relative (η_rel)
- Explica que análise começará com absolute bandwidth
- Justificativa: orienta leitor sobre estrutura da seção

**2. Análise de Absolute Bandwidth (Linhas 779-791 - mantido)**
- Figura 0_disp_comp_lattices.pdf mostrando FBGW vs frequency
- Análise detalhada: triangular (55.40 Hz @ 145 Hz), square (32.10 Hz @ 105 Hz)
- Multi-resonator systems (honeycomb, kagomé)
- Efficiency analysis (Hz/resonator)

**3. Tabela Performance Summary (Linhas 793-810 - movida)**
- Anteriormente estava após definição de relative bandwidth
- Agora posicionada corretamente após análise absolute
- Sumariza FBGW, f_j, efficiency, mechanisms para todas as lattices

**4. Subseção "Relative Bandwidth Analysis..." (Linha 812 - novo subtítulo)**
- Cria separação visual clara entre absolute e relative analysis
- Prepara leitor para mudança de perspectiva metodológica

**5. Transição Crítica (Linhas 814-815 - expandida)**
- Explica limitação de absolute bandwidth de forma pedagógica
- Exemplo concreto: triangular @ 145 Hz vs square @ 105 Hz (38% difference)
- Motivação clara: "potentially biases conclusions toward higher frequencies"
- Justifica necessidade de normalization

**6. Definição de Relative Bandwidth (Linhas 816-821 - movida)**
- Equação η_rel = (f₂-f₁)/f_c × 100% apresentada AGORA (not antes)
- Just-in-time definition: explicada quando será usada
- Justificativa física: "removes frequency-dependent scaling effects"
- "Isolating purely geometric contributions"

**7. Análise Relative Bandwidth (Linhas 823-858 - mantida)**
- Tabela 14 completa com η_rel para 15 frequencies × 5 lattices
- Análise: triangular 42.51% vs square 31.40% (35% improvement)
- Validação: "geometric optimization maintains advantage across spectrum"

**8. Síntese Dual-Metric (Linha 860 - mantida)**
- Framework complementar claramente explicado
- Absolute: "which lattice for my target frequency?" (engineering question)
- Relative: "which geometry is intrinsically superior?" (scientific question)

**9. Conclusão Final (Linhas 862-864 - mantida)**
- Comprehensive analysis summary
- Single vs multi-resonator distinctions
- Performance hierarchies established
- PWE/EPWE efficiency (1800-5700×)

#### Vantagens da Reorganização

1. **Fluxo narrativo lógico**: Absolute → Motivação → Relative → Síntese
2. **Pedagogicamente efetivo**: Leitor entende POR QUE precisa de relative bandwidth
3. **Definição just-in-time**: η_rel apresentado quando será usado (não antes)
4. **Transição motivada**: Limitações de absolute claramente explicadas
5. **Comparação facilitada**: Métricas separadas mas logicamente conectadas
6. **Responde ao revisor naturalmente**: Sem parecer resposta defensiva

#### Resultado
Seção 3.3 agora apresenta argumentação fluida e lógica que naturalmente conduz o leitor da análise absolute (familiar, prática) para relative (normalizada, científica), respondendo ao Comentário 1 do revisor de forma pedagogicamente superior e cientificamente rigorosa.

### 2025-10-04 - Reforço das Principais Contribuições em Múltiplas Seções
**Modificações abrangentes destacando análise comparativa, dual band gaps e bandwidth evolution**

#### Objetivo
Reforçar em múltiplas seções (highlights, abstract, final da seção 3, conclusões) as principais contribuições do trabalho:
1. Análise comparativa sistemática das cinco configurações de lattice
2. Observação de duas bandas proibidas completas em sistemas multi-ressonadores (honeycomb, kagomé)
3. Análise gráfica abrangente do comportamento de larguras de banda através de 15 frequências de ressonadores

#### Modificações Implementadas (4 adições em vermelho)

**1. Linha 30 - highlights.tex (Highlight 3)**
- Expandido para incluir comportamento dual band gap e análise bandwidth evolution
- Adicionado: "multi-resonator systems (honeycomb, kagomé) exhibit dual band gap behavior"
- Adicionado: "comprehensive bandwidth evolution analysis across five lattice geometries"
- Mantém concisão enquanto captura contribuições principais

**2. Linha 82 - Abstract**
- Adicionado parágrafo completo sobre dual band gaps e bandwidth evolution
- Pontos principais:
  - Observação crítica de duas bandas completas em honeycomb/kagomé vs. single band gap em square/rectangular/triangular
  - Origem física: in-phase e anti-phase resonator coupling modes
  - Comprehensive bandwidth evolution analysis estabelece frequency-dependent performance maps
- Leitura fluente integrada ao abstract existente

**3. Linha 862 - Final da Seção 3**
- Substituído resumo simples por análise abrangente detalhada
- Distinções fundamentais: single-resonator vs multi-resonator systems
- Dual complete band gaps em honeycomb (2 ressonadores) e kagomé (3 ressonadores)
- Systematic bandwidth evolution across 15 frequencies (10-150 Hz)
- Performance hierarchies quantitativas para todas as cinco geometrias
- Eficiência computacional PWE/EPWE (1800-5700×) enabling extensive parametric investigation
- "First complete comparative framework" statement

**4. Linha 1135 - Conclusões**
- Expandida significativamente a descrição da investigação comparativa
- Arquiteturas de sistema: single-resonator (single band gap) vs multi-resonator (dual band gaps)
- Dual complete band gaps arising from in-phase/anti-phase coupling modes
- Comprehensive bandwidth evolution analysis across 15 frequencies para todas as geometries
- Frequency-dependent performance maps estabelecidas
- Performance específica: kagomé (15 dB low-freq), honeycomb (dual-mode), triangular (35% superior), square (mid-range), rectangular (directional)

#### Justificativa
Essas modificações asseguram que as três principais contribuições científicas (comparative analysis, dual band gaps, bandwidth evolution) sejam claramente comunicadas em todos os pontos-chave do manuscrito onde readers esperam encontrar summary das contribuições principais.

### 2025-10-04 - Justificativa para Parâmetro de Lattice Constante
**Modificação em resposta ao Comentário 6 dos revisores**

#### Objetivo
Adicionar justificativa clara e fluente para a escolha metodológica de manter o parâmetro de lattice 'a' constante, explicando que esta abordagem isola efeitos geométricos puros e reflete restrições práticas de engenharia.

#### Modificação Implementada

**Linha 338 - Seção 3 (Material Parameters)**
- Adicionado parágrafo em vermelho explicando a metodologia de parâmetro constante
- Pontos principais incluídos:
  - Isolamento de influências geométricas (simetria cristalográfica, área da célula unitária, acoplamento de ressonadores) de efeitos de escala
  - Hierarquia de desempenho objetiva baseada em propriedades geométricas intrínsecas
  - Reflete restrições práticas de engenharia (limitações espaciais predeterminadas)
  - Avaliação justa de geometria que otimiza desempenho dentro de restrições de espaço/material
  - Consideração crítica para aplicações aeroespaciais, automotivas e de engenharia civil
- Justificativa: Responde ao Comentário 6 sobre por que 'a' não foi ajustado para criar bandgaps na mesma frequência inicial
- Leitura natural para o leitor geral, não como resposta direta ao revisor

### 2025-10-04 - Reforço de Citações ao Xiao et al. [46] e Comentário sobre Modelo Infinito
**Modificações adicionais em resposta ao Comentário 2 dos revisores**

#### Objetivo
Reforçar o reconhecimento ao trabalho foundational de Xiao et al. [46] ao longo do manuscrito, estabelecendo conexões claras com os princípios de acoplamento resonance-Bragg e frequency tuning sempre que pertinente. Adicionalmente, clarificar no abstract que a análise de largura de banda está relacionada ao modelo infinito da célula unitária.

#### Modificações Implementadas (8 adições em vermelho)

1. **Linha 82 - Abstract**
   - Adicionado: "Bandwidth analysis employs infinite unit cell model predictions obtained through PWE/EPWE formulations."
   - Justificativa: Clarifica que a análise quantitativa de largura de banda está relacionada ao modelo infinito, conforme solicitado

2. **Linha 450 - Seção 3.1 (Análise Paramétrica Square Lattice)**
   - Conexão com Xiao et al. sobre resonator frequency tuning e bandwidth dependency
   - Reforça que systematic variation de $f_j$ enables controlled bandgap engineering
   - Confirma dependency of bandwidth on resonant frequency estabelecida por Xiao

3. **Linha 460 - Seção 3.1 (Universal Design Rule)**
   - Conexão explícita: universal design rule $f_{j,opt} \approx 0.89 f_B$ aligns with coupling mechanism de Xiao
   - Reforça: widest bandgap from near-coupling between resonance and Bragg band gaps
   - Confirma: fundamental importance of resonator frequency tuning

4. **Linha 555 - Seção 3.1 (Triangular Lattice Performance)**
   - Estabelece que tuning capability across full frequency spectrum extends foundational work de Xiao
   - Demonstra: geometric symmetry fundamentally alters bandwidth-frequency relationship
   - Conecta: resonator frequency optimization principles com geometric variations

5. **Linha 588 - Síntese Single-Resonator Lattices**
   - Universal relationship $f_{j,opt} \approx 0.89 f_B$ consistent with resonance-Bragg coupling principle de Xiao
   - Reforça: optimal bandwidth from strategic positioning of resonator frequencies
   - Estabelece conexão: geometric dispersion limits + resonator tuning

6. **Linha 624 - Seção 3.2 (Multi-Resonator Systems)**
   - Extends resonator frequency optimization principles de Xiao from single to multi-resonator
   - Revela: coupled oscillators introduce new degrees of freedom
   - Demonstra: beyond what is achievable through frequency tuning alone

7. **Linha 793 - Seção 3.3 (Comparative Analysis)**
   - Extends findings de Xiao on square lattice to multiple geometric configurations
   - Demonstra: resonance-Bragg coupling universally applicable
   - Estabelece: lattice symmetry governs achievable bandwidth limits

8. **Linha 1134 - Conclusões**
   - Building upon resonance-Bragg coupling principles established by Xiao
   - Demonstra: optimal bandgap requires simultaneous optimization of resonator frequency + lattice geometry
   - Estabelece paradigm shift: geometry-only → combined geometry-frequency design

#### Estratégia de Citação
- **Contextual e Não-Gratuita**: Todas as citações conectam diretamente com conceitos específicos (coupling, tuning, bandwidth optimization)
- **Progressiva**: Inicia com fundamentos (tuning), avança para aplicações (multi-lattices), culmina em extensões (multi-resonators)
- **Respeitosa ao Trabalho Foundational**: Reconhece contribuições específicas sem over-claiming originalidade

#### Verificação de Consistência
- Todas as 8 adições estão em vermelho (\textcolor{red}{...})
- Citações sempre seguem padrão: Xiao et al.~\cite{Xiao_2012}
- Conexões estabelecem: foundational work → presente study extensions
- Linguagem: acknowledges, extends, builds upon, confirms

### 2025-09-28 - Revisão para Reviewers MSSP
**Processamento completo de 8 comentários dos revisores com modificações em vermelho**

#### Modificações no Manuscrito Principal (manuscript_mssp2_vf.tex)
**7 modificações em vermelho implementadas:**

1. **Linha 122 - Introdução (Comentário 2)**
   - Reconhecimento do trabalho de Xiao et al. sobre acoplamento resonance-Bragg
   - Explicação sobre fórmula de design inicial e super-wide pseudo-directional gaps

2. **Linha 132 - Introdução (Comentário 2)**  
   - Conexão com trabalho foundational de Xiao et al. sobre resonator frequency tuning
   - Estabelecimento do contexto histórico adequado

3. **Linhas 306-311 - Seção 3 (Comentário 1)**
   - Equação de relative bandgap width: η_rel = (f₂-f₁)/fc × 100%
   - Justificativa metodológica para comparação fair entre lattices

4. **Linhas 362-369 - Seção 3 (Comentário 7)**
   - Equação matemática completa do mass ratio: m_ratio = m_p,i/m_p,kagomé
   - Interpretação física: triangular (25%), rectangular (14%) do material kagomé

5. **Linhas 863-864 - Seção 3.3 (Comentário 1)**
   - Análise comprehensive usando relative bandgap width metrics
   - Validação de superioridade triangular: 42.51% vs 31.40% (square)

6. **Linha 867 - Caption Tabela 14 (Comentário 1)**
   - Título da nova tabela comparative de relative bandgap width
   - Referência à Equação de normalização

7. **Linhas 869-874 - Tabela 14 (Comentário 1)**
   - Dados completos η_rel para 5 lattices em 15 frequências
   - Valores normalizados para comparação objetiva

#### Modificações em Arquivo Separado (highlights.tex)
**5 highlights completamente revisados (Comentário 8):**
- Removida linguagem promocional excessiva
- Foco em contribuições científicas específicas  
- Concisão: reduzidos de 2-3 linhas para 1-2 linhas
- Dados quantitativos validados apenas
- Adicionado destaque material efficiency (25% kagomé)

#### Arquivo de Resposta aos Revisores
**Criado reviewer_response_template.html completo:**
- 8 comentários respondidos point-by-point
- Localização exata de todas as modificações
- Justificativas científicas detalhadas
- Formatação profissional com highlighting

#### Questões Abordadas:
- **(1)** Relative bandgap width vs absolute comparison
- **(2)** Reconhecimento trabalho Xiao et al.  
- **(5)** Mesma questão que (1) - resolvida conjuntamente
- **(6)** Justificativa parâmetro lattice constante
- **(7)** Definição matemática mass ratio
- **(8)** Revisão highlights para concisão

#### Arquivos Limpos:
- Removidos todos arquivos auxiliary LaTeX (.aux, .log, .out, etc.)
- Cache limpo para recompilação

### 2025-07-29
- Adicionado comentário sobre resultados EPWE na Seção 2.4 (linha 296)
- Realizada análise completa do manuscrito
- Documentados pontos fortes, de atenção e fracos

### 2025-07-30
- Organizado cabeçalhos padronizados nos arquivos:
  - calcula_func0_database_pwe_bare_platefullpath.m
  - calcula_func1_database_pwe_lrsc_plate_fullpath.m
  - calcula_func2_database_pwe_gamma_X.m
- Adicionadas instruções para evitar emojis e caracteres especiais em arquivos MATLAB

### 2025-07-23
- Corrigido omega para negrito em k(ω) nas linhas 202 e 1229
- Linha 806 já estava correta com `\boldsymbol{\omega}`

## Formatação de Arquivos MATLAB

### Regras Importantes para Arquivos .m
- **NUNCA** usar emojis ou caracteres especiais em arquivos MATLAB
- Evitar caracteres acentuados em comentários (usar "a" ao invés de "ã", etc.)
- Usar apenas caracteres ASCII padrão
- Preferir `fprintf('\n')` ao invés de `disp(sprintf('\n'))`
- Manter formatação consistente de cabeçalhos com linhas de 78 caracteres
- Usar seções claramente delimitadas com comentários estruturados