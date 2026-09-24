# onemono.nvim — TODO

> Onedark monocromático. Strings em verde, funções em azul, vermelho só para erro.

## Filosofia
- [x] Base: paleta Onedark da variante [edge](https://github.com/sainnhe/edge) (fundos, fg e acentos).
- [x] Código: uma única cor de texto, exceto **strings (verde)** e **funções (azul)**. O resto por estilo (itálico/negrito).
- [x] Opção `mono = true` para monocromático puro (strings e funções no fg).
- [x] **Vermelho = erro.** Só em diagnósticos, mensagens de erro, `FIXME`/`BUG`, SpellBad e git delete. Teste garante.
- [x] **Sem roxo, sem rosa.** Fora da paleta; ANSI magenta e ícones roxos do mini.icons viram azure.
- [x] Cor apenas onde carrega significado: git, diagnósticos, kinds do LSP, ícones, busca, TODO/FIXME.

## Paleta
- [x] Dark: `#2c2e34` / `#c5cdd9` (edge default). Superfícies derivadas batem com bg1..bg4 do edge.
- [x] Light: `#eef2f8` (fundo do essential) / `#4b505b` (edge light). Acentos com os tons do edge light, escurecidos o mínimo para passar WCAG AA.
- [x] Acentos: green, blue, red, orange, yellow, cyan, azure.
- [x] `c.code.{string,func}` configurável via `on_colors`.
- [x] Script de validação de contraste (`scripts/contrast.lua`).

## Core (herdado do essential.nvim)
- [x] Compilação para bytecode em cache, chaveado por hash da config + versão.
- [x] `onemono`, `onemono-light`, `onemono-dark`; troca automática via `background`.
- [x] `:OnemonoCompile` / `:OnemonoClearCache` / `:OnemonoExtras`.

## Integrações
- [x] blink.cmp, mini.icons/pick/extra/files/tabline, gitsigns, dropbar, grug-far, mason, lazy.nvim, nvim-treesitter, semantic tokens.

## Extras
- [x] Ghostty, Kitty, Lazygit (light/dark) gerados da paleta.

## Documentação
- [x] README, `doc/onemono.txt`, banner e preview gerados da paleta.
