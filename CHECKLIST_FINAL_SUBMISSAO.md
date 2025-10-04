# CHECKLIST FINAL PRÉ-SUBMISSÃO - MSSP
## Manuscript: MSSP25-4032
## Deadline: 15 Oct 2025

---

## ✅ FASE 1: VERIFICAÇÕES DOS COMENTÁRIOS DOS REVISORES

### Revisor #1 - Comentários Técnicos

- [ ] **Comentário 1 (Relative Bandwidth):**
  - [ ] Equação η_rel implementada (linha 306-311) ✓
  - [ ] Tabela 14 completa com dados (linhas 821-854) ✓
  - [ ] Análise normalizada (linha 819) ✓
  - [ ] Consistência: "35%" em Abstract, Conclusions, Highlights ✓

- [ ] **Comentário 2 (Xiao et al.):**
  - [ ] Reconhecimento em linha 122 ✓
  - [ ] Conexão em linha 132 ✓
  - [ ] Citação correta \cite{Xiao_2012} ✓

- [ ] **Comentário 3 (Bragg Scattering):**
  - [ ] Clarificação adicionada (linha 110 ou equivalente)
  - [ ] Distingue LRSC vs traditional phononic crystals

- [ ] **Comentário 4 (Multi-material):**
  - [ ] Appendix C completo (linhas 1288-1456) ✓
  - [ ] Aluminum 6061 analysis ✓
  - [ ] Carbon/epoxy analysis ✓
  - [ ] Material properties tables ✓
  - [ ] Citações: Xiao et al. 2012, CMH-17 2012 ✓

- [ ] **Comentário 5 (Relative Bandwidth - duplicata):**
  - [ ] Resolvido junto com Comentário 1 ✓

- [ ] **Comentário 6 (Lattice Parameter):**
  - [ ] Resposta argumentativa no HTML
  - [ ] Justificativa científica presente
  - [ ] Sem modificações no manuscrito necessárias

- [ ] **Comentário 7 (Mass Ratio):**
  - [ ] Equação matemática (linhas 362-367) ✓
  - [ ] Definição clara de m_ratio ✓
  - [ ] Interpretação física presente ✓

- [ ] **Comentário 8 (Highlights):**
  - [ ] 5 highlights revisados ✓
  - [ ] Linguagem concisa ✓
  - [ ] Foco em contribuições específicas ✓
  - [ ] Dados quantitativos apenas validados ✓

- [ ] **Comentário 9 (Figuras):**
  - [ ] **PENDENTE - FAZER NO FDS**
  - [ ] Fontes aumentadas para mínimo 14pt
  - [ ] Espessura de linhas aumentada
  - [ ] Resolução mínima 600 DPI
  - [ ] Todas as figuras regeneradas
  - [ ] Atualizar HTML após conclusão

- [ ] **Comentário 10 (Seção 3 Concisa):**
  - [ ] Section 3 condensada
  - [ ] Redundâncias eliminadas
  - [ ] Figuras e tabelas preservadas
  - [ ] Conteúdo científico mantido

---

## ✅ FASE 2: VERIFICAÇÕES TÉCNICAS DO MANUSCRITO

### 2.1 Compilação LaTeX

- [ ] **Compilação sem erros:**
  ```bash
  pdflatex manuscript_mssp2_vf.tex
  bibtex manuscript_mssp2_vf
  pdflatex manuscript_mssp2_vf.tex
  pdflatex manuscript_mssp2_vf.tex
  ```
  - [ ] Nenhum erro fatal
  - [ ] Warnings aceitáveis apenas
  - [ ] PDF gerado (90 páginas)

- [ ] **Bibliografia:**
  - [ ] Todas as citações presentes em mybibfile.bib
  - [ ] Formato elsarticle-num.bst correto
  - [ ] Nenhuma citação "undefined"
  - [ ] Referências completas (autores, ano, DOI)

- [ ] **Referências Cruzadas:**
  - [ ] Todas as \ref{} resolvidas
  - [ ] Tabelas numeradas corretamente
  - [ ] Figuras numeradas sequencialmente
  - [ ] Equações numeradas sem gaps
  - [ ] Apêndices A, B, C, D na ordem correta

### 2.2 Consistência de Dados Quantitativos

- [ ] **Performance Metrics:**
  - [ ] Triangular: 42.51% @ 140 Hz ✓
  - [ ] Square: 31.40% @ 100 Hz ✓
  - [ ] Improvement: 35% (não 40%) ✓
  - [ ] Computational efficiency: 1800-5700× ✓
  - [ ] PWE-FEM error: 0.68% ± 0.24% ✓

- [ ] **Multi-material Data:**
  - [ ] Aluminum: 222.0 Hz ✓
  - [ ] Carbon/epoxy: 408.1 Hz ✓
  - [ ] Stiffness variation: 150× (não 278×) ✓
  - [ ] Materiais: Al + C/E (não steel) ✓

- [ ] **Mass Ratio Values:**
  - [ ] Kagomé: 1.00 (reference)
  - [ ] Honeycomb: 0.75
  - [ ] Square: 0.29
  - [ ] Triangular: 0.25
  - [ ] Rectangular: 0.14

### 2.3 Formatação em Vermelho

- [ ] **Modificações Visíveis:**
  - [ ] Abstract (linha 82): texto em vermelho
  - [ ] Introdução (linhas 122, 132, 142): adições em vermelho
  - [ ] Section 3 início (linhas 304, 306-311): em vermelho
  - [ ] Mass ratio (linhas 362-367): em vermelho
  - [ ] Tabela 14 caption (linha 823): em vermelho
  - [ ] Tabela 14 data (linhas 825-853): em vermelho
  - [ ] Section 3 summary (linha 858): em vermelho
  - [ ] Section 4 intro (linha 862): em vermelho
  - [ ] Conclusions (linha 1131): em vermelho
  - [ ] Appendix C mentions (linha 142, 1439, 1445): em vermelho

- [ ] **Comando Correto:**
  - [ ] Usando \textcolor{red}{...}
  - [ ] Não usando {\color{red}...} (pode quebrar)
  - [ ] Texto vermelho visível no PDF

---

## ✅ FASE 3: VERIFICAÇÕES DE CONTEÚDO

### 3.1 Abstract

- [ ] Menciona 5 lattices (square, rectangular, triangular, honeycomb, kagomé)
- [ ] Cita PWE/EPWE + FEM validation
- [ ] Performance: "35% superior relative bandwidth" ✓
- [ ] Kagomé: "15 dB enhanced attenuation"
- [ ] Computational: "1800-5700× speedup"
- [ ] Palavras-chave corretas (sem duplicatas)

### 3.2 Highlights (highlights.tex)

- [ ] Exatamente 5 highlights
- [ ] Cada um com 1-2 linhas
- [ ] Todos em vermelho \textcolor{red}{...}
- [ ] Highlight #3: "35% superior relative bandwidth (42.51% vs 31.40%)" ✓
- [ ] Material efficiency: "25% of kagomé's material" ✓
- [ ] Sem linguagem promocional

### 3.3 Introduction

- [ ] Xiao et al. reconhecimento (2 locais) ✓
- [ ] Bragg scattering clarificação
- [ ] 5 lattices justificadas
- [ ] Research gap claro
- [ ] Objetivos específicos

### 3.4 Section 3 (Results)

- [ ] Relative bandwidth equation (Eq. 3.1)
- [ ] Tabela 14 de relative bandwidth completa
- [ ] 15 frequências × 5 lattices
- [ ] Análise normalizada (linha 819)
- [ ] Conclusões consistentes com dados

### 3.5 Conclusions

- [ ] Performance hierarchy clara
- [ ] "35% superior relative bandwidth" ✓
- [ ] Computational efficiency mencionada
- [ ] Limitations acknowledged
- [ ] Future work suggestions
- [ ] Sem claims exagerados

### 3.6 Appendices

- [ ] **Appendix A:** PWE Matrix formulation completa
- [ ] **Appendix B:** EPWE formulation completa
- [ ] **Appendix C:** Multi-material analysis
  - [ ] Aluminum data tables
  - [ ] Carbon/epoxy data tables
  - [ ] Material properties comparison
  - [ ] Frequency scaling analysis
  - [ ] Universal hierarchy demonstrated
- [ ] **Appendix D:** Selection framework

---

## ✅ FASE 4: DOCUMENTO DE RESPOSTA AOS REVISORES

### 4.1 Arquivo HTML (reviewer_response_template.html)

- [ ] **Estrutura:**
  - [ ] Header com título e autores
  - [ ] Seção para Revisor #1
  - [ ] 10 comentários endereçados

- [ ] **Cada Resposta Contém:**
  - [ ] Comment text (citação do revisor)
  - [ ] Response (resposta detalhada)
  - [ ] Manuscript Changes (localização exata)
  - [ ] Line numbers específicos
  - [ ] Texto em vermelho indicado com <span class="red-text">

- [ ] **Completude:**
  - [ ] Comentário 1: ✓ Completo
  - [ ] Comentário 2: ✓ Completo
  - [ ] Comentário 3: ✓ Completo
  - [ ] Comentário 4: ✓ Completo
  - [ ] Comentário 5: ✓ Referência ao Comentário 1
  - [ ] Comentário 6: ✓ Justificativa argumentativa
  - [ ] Comentário 7: ✓ Completo
  - [ ] Comentário 8: ✓ Completo
  - [ ] Comentário 9: ⏳ ATUALIZAR APÓS FIGURAS
  - [ ] Comentário 10: ✓ Completo

- [ ] **Dados Corretos no HTML:**
  - [ ] 35% (não 40%) ✓
  - [ ] 42.51% vs 31.40% ✓
  - [ ] 150× (não 278×) ✓
  - [ ] Aluminum + Carbon/epoxy (não steel) ✓

### 4.2 Conversão HTML para PDF (Opcional)

- [ ] Abrir no navegador (Chrome/Firefox)
- [ ] Imprimir como PDF
- [ ] Verificar formatação preservada
- [ ] Cores mantidas (azul/verde/amarelo)

---

## ✅ FASE 5: ARQUIVOS PARA SUBMISSÃO

### 5.1 Arquivos Obrigatórios

- [ ] **manuscript_mssp2_vf.tex** (source LaTeX)
- [ ] **manuscript_mssp2_vf.pdf** (PDF compilado com vermelho)
- [ ] **mybibfile.bib** (bibliografia)
- [ ] **elsarticle.cls** (classe do journal)
- [ ] **highlights.tex** (ou highlights.pdf)
- [ ] **reviewer_response_template.html** ou .pdf

### 5.2 Figuras

- [ ] Todas as figuras em pasta organizada
- [ ] Formato aceito (.pdf, .eps, .png)
- [ ] Resolução adequada (≥600 DPI para bitmap)
- [ ] Nomes consistentes com \includegraphics{}
- [ ] **APÓS COMENTÁRIO 9:**
  - [ ] Figuras regeneradas com fontes maiores
  - [ ] Legendas legíveis
  - [ ] Linhas mais espessas

### 5.3 Arquivos Auxiliares (Verificar se Necessários)

- [ ] cover_letter.tex (carta de apresentação - se aplicável)
- [ ] graphical_abstract (se solicitado)
- [ ] Supplementary material (códigos MATLAB - opcional)

### 5.4 Dados Tabulares Suplementares (Opcional)

- [ ] doc_files_data_materials_al_carb/*.tex
- [ ] Dados completos de simulações
- [ ] Podem ser incluídos como material suplementar

---

## ✅ FASE 6: VERIFICAÇÕES FINAIS DO PDF

### 6.1 Inspeção Visual do PDF

- [ ] **Página por página:**
  - [ ] Texto em vermelho claramente visível
  - [ ] Figuras renderizadas corretamente
  - [ ] Tabelas formatadas adequadamente
  - [ ] Equações legíveis
  - [ ] Nenhum texto cortado nas margens
  - [ ] Headers e footers corretos

- [ ] **Tabelas Críticas:**
  - [ ] Tabela 1: Material properties ✓
  - [ ] Tabela 2: Computational parameters ✓
  - [ ] Tabela 3: Geometric properties + mass ratio ✓
  - [ ] Tabela 14: Relative bandwidth comparison ✓ (VERIFICAR VISUALMENTE)
  - [ ] Appendix C tables: Aluminum + Carbon/epoxy

- [ ] **Figuras Críticas:**
  - [ ] Figure 1: Unit cells (5 lattices)
  - [ ] Dispersion diagrams (todas visíveis)
  - [ ] Receptance plots (FEM validation)
  - [ ] Comparative plots

### 6.2 Metadados do PDF

- [ ] Título correto
- [ ] Autores listados
- [ ] Keywords presentes
- [ ] Bookmark structure (se aplicável)

### 6.3 Numeração e Paginação

- [ ] 90 páginas totais (ou próximo)
- [ ] Páginas numeradas corretamente
- [ ] Sem páginas em branco indesejadas
- [ ] Apêndices iniciando em nova página

---

## ✅ FASE 7: CHECKLIST ESPECÍFICO DO EDITOR

### 7.1 Requisitos MSSP Explícitos

> **Email do editor:**
> "ensure that all modified text is printed in red"

- [ ] **TODO texto modificado em vermelho** ✓

> "If the response to the reviewers' comments is not complete and descriptive, I will be unable to make a prompt decision"

- [ ] **Resposta ponto-a-ponto completa** ✓
- [ ] **Descritiva com localizações exatas** ✓

> "When revising your manuscript please include a point-by-point response"

- [ ] **Arquivo HTML/PDF com respostas** ✓

> "submit your revised paper by 15 Oct 2025"

- [ ] **Deadline: 15 Outubro 2025** - ATENÇÃO!

### 7.2 Guide for Authors MSSP

- [ ] Verificar formato elsarticle atualizado
- [ ] Figuras em formato aceito
- [ ] Bibliografia formato correto (elsarticle-num)
- [ ] Abstract < 300 palavras (verificar limite)
- [ ] Keywords (mínimo 4, máximo 6 - verificar)

---

## ✅ FASE 8: PREPARAÇÃO DO UPLOAD

### 8.1 Sistema Editorial (Editorial Manager)

- [ ] **Login:**
  - Username: anderson.ferreira.fem.unicamp@gmail.com
  - URL: https://www.editorialmanager.com/ymssp/

- [ ] **Localizando Submissão:**
  - [ ] Menu: "Submission Needing Revision"
  - [ ] Manuscript ID: MSSP25-4032
  - [ ] Click em "Create Revision"

### 8.2 Upload de Arquivos

- [ ] **Step 1: Manuscript files**
  - [ ] Upload manuscript_mssp2_vf.tex (LaTeX source)
  - [ ] Upload manuscript_mssp2_vf.pdf (compiled PDF)
  - [ ] **NÃO apenas PDF** - incluir source!

- [ ] **Step 2: Figures**
  - [ ] Upload todas as figuras individualmente
  - [ ] Verificar nomes corretos

- [ ] **Step 3: Highlights**
  - [ ] Upload highlights.tex ou highlights.pdf

- [ ] **Step 4: Response to Reviewers**
  - [ ] Upload reviewer_response_template.pdf
  - [ ] Verificar formatação preservada

- [ ] **Step 5: Bibliography**
  - [ ] Upload mybibfile.bib
  - [ ] Verificar encoding (UTF-8)

### 8.3 Campos do Formulário

- [ ] **Cover letter:**
  - [ ] Mencionar que todos os comentários foram endereçados
  - [ ] Listar modificações principais
  - [ ] Agradecer aos revisores

- [ ] **Changes summary:**
  - [ ] Resumo das 10 modificações principais
  - [ ] Indicar que texto está em vermelho
  - [ ] Mencionar Appendix C adicionado

---

## ✅ FASE 9: VERIFICAÇÃO CRUZADA (DOUBLE-CHECK)

### 9.1 Comparação HTML ↔ Manuscrito

- [ ] **Comentário 1:**
  - HTML diz: "Lines 306-311"
  - Manuscrito: Equação presente? ✓

- [ ] **Comentário 2:**
  - HTML diz: "Lines 122, 132"
  - Manuscrito: Texto Xiao presente? ✓

- [ ] **Comentário 4:**
  - HTML diz: "Appendix C, Lines 1293-1435"
  - Manuscrito: Appendix completo? ✓

- [ ] **Comentário 7:**
  - HTML diz: "Lines 362-369"
  - Manuscrito: Equação mass ratio? ✓

- [ ] **Comentário 8:**
  - HTML diz: "5 highlights revised"
  - highlights.tex: 5 em vermelho? ✓

### 9.2 Valores Numéricos Críticos

- [ ] **Triangular peak:**
  - Abstract: 42.51% ✓
  - Table 14: 42.51% ✓
  - Conclusions: 42.51% ✓
  - Highlights: 42.51% ✓
  - HTML: 42.51% ✓

- [ ] **Improvement percentage:**
  - Abstract: 35% ✓
  - Section 3: 35% ✓
  - Conclusions: 35% ✓
  - Highlights: 35% ✓
  - HTML: 35% ✓
  - **NENHUMA menção a "40%"** (obsoleto)

- [ ] **Materials:**
  - Intro: "aluminum and carbon/epoxy" ✓
  - Appendix C: Al + C/E ✓
  - HTML: Al + C/E ✓
  - **NENHUMA menção a "steel"** (obsoleto)

- [ ] **Stiffness variation:**
  - Intro: 150× ✓
  - Appendix C: 150× ✓
  - HTML: 150× ✓
  - **NENHUMA menção a "278×"** (obsoleto)

---

## ✅ FASE 10: CHECKLIST FINAL PRÉ-CLICK "SUBMIT"

### 10.1 Última Revisão (5 minutos antes de submeter)

- [ ] **Respirar fundo** 😊

- [ ] **Abrir PDF final uma última vez:**
  - [ ] Primeira página: título, autores corretos
  - [ ] Abstract: texto vermelho visível
  - [ ] Tabela 14: dados completos e visíveis
  - [ ] Appendix C: presente e completo
  - [ ] Bibliografia: sem "???" ou citações quebradas

- [ ] **Verificar HTML de resposta:**
  - [ ] Todos os 10 comentários presentes
  - [ ] Nenhum "TODO" ou placeholder
  - [ ] Formatação profissional

- [ ] **Highlights:**
  - [ ] 5 bullets em vermelho
  - [ ] Concisão confirmada
  - [ ] Dados corretos

### 10.2 Confirmações Finais

- [ ] **Prazo:** Submissão ANTES de 15 Out 2025 ✓
- [ ] **Arquivos source incluídos** (não apenas PDF) ✓
- [ ] **Todas as modificações em vermelho** ✓
- [ ] **Resposta completa e descritiva** ✓

### 10.3 Backup Antes de Submeter

- [ ] **Criar pasta de backup:**
  ```bash
  mkdir backup_submissao_final_$(date +%Y%m%d)
  cp manuscript_mssp2_vf.* backup_submissao_final_*/
  cp highlights.tex backup_submissao_final_*/
  cp reviewer_response_template.html backup_submissao_final_*/
  cp mybibfile.bib backup_submissao_final_*/
  ```

- [ ] **Commit git (se aplicável):**
  ```bash
  git add .
  git commit -m "Final revision for MSSP - all reviewer comments addressed"
  git tag submission_final_v2
  ```

---

## ✅ FASE 11: PÓS-SUBMISSÃO

### 11.1 Confirmação Imediata

- [ ] **Email de confirmação recebido**
- [ ] **Manuscript ID confirmado:** MSSP25-4032
- [ ] **Status no sistema:** "Under Review" ou similar

### 11.2 Documentação

- [ ] **Salvar email de confirmação**
- [ ] **Screenshot do sistema mostrando submissão**
- [ ] **Anotar data e hora exatas da submissão**

### 11.3 Próximos Passos

- [ ] **Aguardar resposta:** Típico 4-8 semanas
- [ ] **Preparar-se para possível round 2** (rare but possible)
- [ ] **Celebrar!** 🎉

---

## 📊 RESUMO EXECUTIVO

### Status Atual (Completude):
```
[████████████████████░] 95%

COMPLETO:
✅ Comentários 1, 2, 3, 4, 5, 6, 7, 8, 10
✅ Manuscrito compilado e verificado
✅ Dados consistentes (35%, 150×, Al+C/E)
✅ HTML de resposta 90% completo
✅ Highlights revisados

PENDENTE:
⏳ Comentário 9: Figuras (FDS)
⏳ HTML Comentário 9: Após figuras
⏳ Verificação visual final do PDF
⏳ Upload no sistema
```

### Risco Assessment:
```
BAIXO RISCO:
✅ Conteúdo científico sólido
✅ Todos os comentários técnicos endereçados
✅ Dados verificados e consistentes
✅ Formatação em vermelho presente

ATENÇÃO NECESSÁRIA:
⚠️ Comentário 9 (figuras) - trabalho restante
⚠️ Verificação visual final completa
⚠️ Deadline: 15 Out 2025
```

### Timeline Recomendado:
```
ESTA SEMANA (FDS):
- Sexta/Sábado: Regenerar figuras (Comentário 9)
- Domingo: Verificação visual completa do PDF

SEMANA SEGUINTE:
- Segunda: Atualizar HTML com Comentário 9
- Terça: Verificação final cruzada
- Quarta: Submissão no sistema
- Quinta: Confirmar recebimento

BUFFER: 10+ dias antes do deadline ✓
```

---

## 🎯 AÇÕES IMEDIATAS

### Para Você (Usuário):

1. **ESTE FDS:**
   - [ ] Regenerar figuras com fontes ≥14pt
   - [ ] Verificar clareza visual de todas as ~50 figuras
   - [ ] Recompilar manuscrito com figuras novas
   - [ ] Informar ao assistente quando concluído

2. **APÓS FIGURAS:**
   - [ ] Solicitar atualização do HTML (Comentário 9)
   - [ ] Verificação visual final do PDF completo
   - [ ] Executar Fase 6 deste checklist

3. **ANTES DE SUBMETER:**
   - [ ] Revisão completa deste checklist
   - [ ] Backup de todos os arquivos
   - [ ] Upload no sistema MSSP

---

## 📞 SUPORTE

**Se encontrar problemas:**
- Compilação LaTeX: Verificar log file
- Referências quebradas: Rodar bibtex novamente
- Figuras: Verificar caminhos e formatos
- Sistema MSSP: help@elsevier.com

**Contatos Importantes:**
- Editor MSSP: (via sistema)
- Suporte técnico: https://service.elsevier.com
- Email submissão: anderson.ferreira.fem.unicamp@gmail.com

---

**CHECKLIST CRIADO:** 2025-10-03
**ÚLTIMA ATUALIZAÇÃO:** 2025-10-03
**VERSÃO:** 1.0 Final

**BOA SORTE! 🍀**
