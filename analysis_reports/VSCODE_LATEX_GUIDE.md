# Guia de Uso - VSCode LaTeX Workshop

## ✅ Configurações Aplicadas

### 📁 Arquivos Criados/Modificados:
- `.vscode/settings.json` - Configurações principais do LaTeX Workshop
- `.vscode/keybindings.json` - Atalhos de teclado personalizados
- `.vscode/tasks.json` - Tasks de compilação automatizadas
- `.vscode/extensions.json` - Extensões recomendadas
- `.vscode/launch.json` - Configurações de debug/launch

## 🎯 Funcionalidades Ativadas

### Visualização PDF:
- **Visualizador integrado** no VSCode (aba lateral)
- **Sincronização bidirecional** (clique duplo entre código e PDF)
- **Auto-zoom** ajustado à largura da página
- **Build automático** ao salvar arquivo .tex

### Limpeza Automática:
- Remove arquivos auxiliares após build bem-sucedido
- Lista completa de extensões para limpeza configurada

## ⌨️ Atalhos de Teclado

| Atalho | Função |
|--------|--------|
| `Ctrl+Alt+V` | Visualizar PDF |
| `Ctrl+Alt+B` | Build documento |
| `Ctrl+Alt+C` | Limpar arquivos auxiliares |
| `Ctrl+Alt+K` | Matar processo LaTeX |
| `Ctrl+Alt+J` | Sincronizar posição (SyncTeX) |

## 🔧 Tasks Disponíveis

### Via Command Palette (`Ctrl+Shift+P`):
- `Tasks: Run Task` → `Build LaTeX`
- `Tasks: Run Task` → `Build LaTeX with BibTeX`
- `Tasks: Run Task` → `Clean LaTeX`
- `Tasks: Run Task` → `Open PDF`

## 🚀 Como Usar

### Método 1 - Automático:
1. Abra `manuscript_mssp2_vf.tex` no VSCode
2. Salve o arquivo (`Ctrl+S`)
3. O PDF será compilado automaticamente
4. Use `Ctrl+Alt+V` para visualizar

### Método 2 - Manual:
1. Abra arquivo .tex
2. Pressione `Ctrl+Alt+B` para build
3. Pressione `Ctrl+Alt+V` para visualizar

### Método 3 - Com Bibliografia:
1. Use `Ctrl+Shift+P` → `Tasks: Run Task`
2. Selecione `Build LaTeX with BibTeX`
3. Aguarde conclusão e visualize com `Ctrl+Alt+V`

## 📋 Extensões Recomendadas

Instale via `Ctrl+Shift+X`:
- **LaTeX Workshop** (principal)
- **LaTeX Utilities** (utilitários extras)
- **LTeX** (correção gramatical)

## 🔍 Troubleshooting

### PDF não aparece:
1. Verifique se a extensão LaTeX Workshop está instalada
2. Tente `Ctrl+Shift+P` → `Developer: Reload Window`
3. Use `Ctrl+Alt+V` manualmente

### Build falha:
1. Verifique o terminal integrado para erros
2. Use `Ctrl+Alt+C` para limpar arquivos
3. Tente build manual com `Ctrl+Alt+B`

### Sincronização não funciona:
1. Certifique-se de que `-synctex=1` está nos argumentos
2. Clique duplo no PDF para ir ao código
3. Use `Ctrl+Alt+J` para forçar sincronização

## 📝 Notas Importantes

- **Auto-build** está ativado (compila ao salvar)
- **Porta automática** para visualizador (evita conflitos)
- **Warnings silenciados** (apenas erros são mostrados)
- **Arquivos auxiliares** removidos automaticamente