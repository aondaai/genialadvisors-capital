# genialadvisors.capital

Landing page da **Genial Restructuring Advisors** (Reestruturação & Situações Especiais).

Site estático puro: sem build, sem dependências, sem requisições externas.

| arquivo | o que é |
|---|---|
| `index.html` | a página inteira — CSS e JS inline, fontes do sistema, primeiro quadro do vídeo embutido em base64 |
| `hero.webm` | vídeo do hero, 67 KB (navegadores modernos) |
| `hero.mp4` | vídeo do hero, 146 KB (Safari / fallback) |
| `render.yaml` | blueprint da Render: publish path e cache headers |

## Deploy
Render static site, `publishPath: .`, sem build command. Auto-deploy no push para `main`.

## Pendências antes de divulgar
1. **Formulário** — `var endpoint = null` no fim do `index.html` precisa da URL do CRM.
2. **Analytics** — nenhum script incluído de propósito.
3. **Dados de mercado** — números de 2025–2026 (Serasa Experian, BCB, imprensa). Revalidar com compliance.
4. **Marca** — registrar "Genial Restructuring Advisors" no INPI.
