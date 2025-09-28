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