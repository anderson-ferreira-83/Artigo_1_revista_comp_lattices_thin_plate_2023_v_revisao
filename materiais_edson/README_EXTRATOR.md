# Extrator de Comentários PDF

## 📁 Arquivos Criados

1. **`extract_pdf_comments.py`** - Extrator completo e robusto
2. **`simple_pdf_extractor.py`** - Versão simplificada 
3. **`instalar_e_executar.bat`** - Script automático para Windows
4. **`README_EXTRATOR.md`** - Este arquivo de instruções

## 🎯 Objetivo

Extrair comentários, anotações e highlights do arquivo `response_to_reviewers_rev1.pdf` localizado neste diretório.

## 🚀 Como Usar

### Opção 1: Executar Automaticamente (Windows)
```bash
# Duplo-clique no arquivo ou execute no terminal:
instalar_e_executar.bat
```

### Opção 2: Executar Manualmente

#### Passo 1: Instalar Bibliotecas
```bash
pip install PyMuPDF pdfplumber PyPDF2
```

#### Passo 2: Executar Extrator
```bash
# Versão completa (recomendada):
python extract_pdf_comments.py

# Ou versão simples:
python simple_pdf_extractor.py
```

### Opção 3: Apenas uma biblioteca
```bash
# Se tiver apenas PyMuPDF:
pip install PyMuPDF
python simple_pdf_extractor.py

# Se tiver apenas PyPDF2 (limitado - só texto):
pip install PyPDF2
python simple_pdf_extractor.py
```

## 📄 Arquivos de Saída

O extrator criará arquivos com timestamp:

### Comentários (formato legível)
- **`pdf_comments_YYYYMMDD_HHMMSS.txt`**
  - Lista todos os comentários encontrados
  - Inclui página, tipo, autor, conteúdo
  - Formato fácil de ler

### Comentários (formato estruturado)
- **`pdf_comments_YYYYMMDD_HHMMSS.json`**
  - Dados em formato JSON para processamento
  - Inclui coordenadas, datas, metadados

### Texto Completo
- **`pdf_text_YYYYMMDD_HHMMSS.txt`**
  - Todo o texto do PDF extraído
  - Organizado por páginas

## 🔍 Tipos de Comentários Detectados

- **Text** - Comentários de texto
- **Highlight** - Texto destacado
- **Note** - Notas adesivas
- **Underline** - Sublinhados
- **StrikeOut** - Texto riscado
- **Squiggly** - Sublinhado ondulado
- **Ink** - Anotações à mão livre

## ⚠️ Solução de Problemas

### Erro: "Arquivo não encontrado"
- Verifique se `response_to_reviewers_rev1.pdf` está na mesma pasta
- Certifique-se de executar o script na pasta correta

### Erro: "Biblioteca não instalada"
```bash
# Instalar uma por vez se houver conflitos:
pip install PyMuPDF
# OU
pip install pdfplumber
# OU  
pip install PyPDF2
```

### Nenhum comentário encontrado
Isso pode acontecer se:
- O PDF não tem comentários/anotações
- Os comentários estão em formato proprietário
- O PDF está protegido
- Os comentários são imagens/desenhos

### Erro de permissão
- Execute como administrador (Windows)
- Verifique permissões do arquivo PDF

## 🛠️ Funcionalidades dos Scripts

### `extract_pdf_comments.py` (Completo)
- ✅ Extrai todos os tipos de comentários
- ✅ Inclui metadados completos
- ✅ Salva em múltiplos formatos
- ✅ Relatório detalhado
- ✅ Tratamento de erros robusto

### `simple_pdf_extractor.py` (Simples)
- ✅ Funciona com menos dependências
- ✅ Mais rápido
- ✅ Fácil de entender
- ✅ Fallback automático

## 💡 Dicas

1. **Use o script completo primeiro** - tem mais recursos
2. **Se der erro, tente o simples** - mais compatível
3. **Verifique os arquivos gerados** - podem ter nomes com timestamp
4. **Abra os .txt no Notepad++** - melhor formatação
5. **Os .json podem ser abertos no VS Code** - estrutura clara

## 📧 Em caso de problemas

Se os scripts não funcionarem:
1. Verifique se Python está instalado (`python --version`)
2. Tente instalar apenas uma biblioteca por vez
3. Execute no terminal para ver mensagens de erro
4. Copie o erro e consulte a documentação

## 🎯 Resultado Esperado

Após a execução bem-sucedida, você terá:
- **Lista completa** de todos os comentários do PDF
- **Texto integral** do documento  
- **Metadados** de cada anotação (autor, data, localização)
- **Arquivos organizados** por timestamp

Isso permitirá analisar facilmente todos os comentários e apontamentos dos revisores no arquivo `response_to_reviewers_rev1.pdf`.