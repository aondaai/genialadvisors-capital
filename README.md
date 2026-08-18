# genialadvisors.capital

Landing page da **Genial Restructuring Advisors** (Reestruturação & Situações Especiais).

Site estático puro: sem build, sem dependências, sem requisições externas.

| arquivo | o que é |
|---|---|
| `index.html` | a página inteira — CSS e JS inline, fontes do sistema, hero em CSS + SVG |
| `render.yaml` | blueprint da Render: publish path e cache headers |

O hero era um vídeo de 214 KB (`hero.mp4` / `hero.webm`), removido em favor do
motivo da linha-virada em SVG — o mesmo da seção 06, em escala de hero. O vídeo
não carregava abaixo de 860 px e o quadro estático de reserva ficava invisível
sob o scrim, então no celular o hero era azul-marinho chapado. A versão vetorial
compõe geometrias distintas para paisagem e retrato (`@media(max-aspect-ratio:1/1)`)
em vez de recortar um frame 16:9, e redesenha a cada retorno ao hero.
Para recuperar os arquivos: `git checkout b87641e -- hero.mp4 hero.webm`.

## Deploy
Render static site, `publishPath: .`, sem build command. Auto-deploy no push para `main`.

## Pendências antes de divulgar
1. **Formulário** — `var endpoint = null` no fim do `index.html` precisa da URL do CRM.
2. **Analytics** — nenhum script incluído de propósito.
3. **Dados de mercado** — números de 2025–2026 (Serasa Experian, BCB, imprensa). Revalidar com compliance.
4. **Marca** — registrar "Genial Restructuring Advisors" no INPI.
