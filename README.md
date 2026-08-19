# genialadvisors.capital

Landing page da **Genial Restructuring Advisors** (Reestruturação & Situações Especiais).

Site estático puro: sem build, sem dependências, sem requisições externas.

| arquivo | o que é |
|---|---|
| `index.html` | a página inteira — CSS e JS inline, fontes do sistema, hero em CSS + SVG |
| `render.yaml` | blueprint da Render: publish path e cache headers |
| `og.png` | card de compartilhamento, 1200×630 — o que aparece no LinkedIn/WhatsApp |
| `og.source.html` | fonte do `og.png`. Não é página do site: `noindex`, nada linka para ela |

O hero era um vídeo de 214 KB (`hero.mp4` / `hero.webm`), removido em favor do
motivo da linha-virada em SVG — o mesmo da seção 06, em escala de hero. O vídeo
não carregava abaixo de 860 px e o quadro estático de reserva ficava invisível
sob o scrim, então no celular o hero era azul-marinho chapado. A versão vetorial
compõe geometrias distintas para paisagem e retrato (`@media(max-aspect-ratio:1/1)`)
em vez de recortar um frame 16:9, e redesenha a cada retorno ao hero.
Para recuperar os arquivos: `git checkout b87641e -- hero.mp4 hero.webm`.

## Deploy
Render static site, `publishPath: .`, sem build command. Auto-deploy no push para `main`.

## Card de compartilhamento

`og.png` (1200×630) é gerado de `og.source.html`, que reaproveita os ativos exatos
do `index.html`: o símbolo keystone, a paleta, o star-dust e o motivo da
linha-virada — este último em estado final, já que a imagem é estática. Marca não
se aproxima, então o card é renderizado do próprio HTML em vez de redesenhado à
mão ou gerado por modelo.

Para regerar, a partir de `site/`:

```
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --hide-scrollbars \
  --screenshot=og.png --window-size=1200,630 og.source.html
```

Conferir depois: 1200×630 exatos e todo o texto dentro da margem de 72px — as
plataformas cortam até ~5% das bordas ao montar o preview. Se o texto do card
mudar, atualizar junto `og:image:alt` / `twitter:image:alt` no `<head>`.

Trocar o arquivo depois de a página já ter circulado esbarra em cache: LinkedIn e
WhatsApp seguram a versão antiga por dias. O LinkedIn tem o Post Inspector para
forçar a releitura; o WhatsApp não — nesse caso publique com outro nome
(`og-2.png`) e aponte as meta tags para ele.

## Pendências antes de divulgar

Bloqueantes — a página não deve ser divulgada antes disso.

1. **Formulário** — preencha `endpoint` (URL do CRM) **ou** `fallbackEmail` no fim do `index.html`.
   Enquanto os dois estiverem vazios o formulário se desabilita sozinho e avisa o visitante.
   Ele nunca confirma recebimento de mensagem que não recebeu.
2. **Placeholders `[...]`** — oito no total, todos obrigatórios:

   | token | o que preencher |
   |---|---|
   | `[MÊS/ANO]` (×2) | data de apuração dos dados de mercado — nota da seção 01 e rodapé |
   | `[PRAZO DE RETENÇÃO]` | prazo de guarda dos dados do formulário |
   | `[E-MAIL DO ENCARREGADO]` | contato do encarregado de dados (LGPD, art. 41) |
   | `[URL]` | link da Política de Privacidade |
   | `[RAZÃO SOCIAL]` / `[00.000.000/0001-00]` | entidade e CNPJ |
   | `[STATUS REGULATÓRIO]` | registro/autorização aplicável |

   Para localizar todos (sem número de linha, que envelhece a cada edição):

   ```
   grep -nE '\[[^]]{3,40}\]' index.html | grep -viE 'http|inset|rgba|clamp|disabled|type='
   ```

3. **Citação do Riechert** — a atribuição no ar é "CEO do Grupo Genial", sem veículo
   nem data. Confirmar o cargo atual e a fonte da fala antes de divulgar; se a citação
   não fechar, remover o bloco.
4. **Política de Privacidade** — precisa existir antes de o link ir ao ar.
5. **Dados de mercado** — revalidar com compliance. O número de RJs em 2025 e a
   variação sobre 2024 não fechavam entre si; a variação foi removida até conferência.
6. **Selic** — valor fixo de 15% no HTML. Revisar a cada reunião do Copom.
7. **Analytics** — nenhum script incluído de propósito.
8. **Marca** — registrar "Genial Restructuring Advisors" no INPI.

## Revisão pendente

Aplicadas: voz, terminologia, nome do produto, rótulos de CTA, jargão (UPI, stalking horse),
superlativos sem fonte, prazos apresentados como garantia, canonical e metadados sociais.

Não aplicadas — dependem de dado que não está no repo: endereço das unidades de São Paulo
e Rio de Janeiro, telefone e e-mail institucionais, imagem de compartilhamento.
Nada de acessibilidade ou performance foi auditado; a revisão cobriu texto, marca e conformidade.
A nota "Marca sujeita a registro no INPI" foi mantida por ser divulgação honesta;
avalie removê-la depois do depósito.
