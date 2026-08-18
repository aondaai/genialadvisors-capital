#!/usr/bin/env bash
# Publica genialadvisors.capital — rode na SUA máquina (aqui o GitHub não é bloqueado).
# Uso:  bash deploy.sh
set -euo pipefail

RENDER_KEY="rnd_qAF0VFuE0TqRxd02ucEuBT3rdDcZ"
OWNER_ID="tea-d6j2mj75r7bs73ep2bq0"
REPO="aondaai/genialadvisors-capital"
SVC="genialadvisors-capital"
API="https://api.render.com/v1"
H=(-H "Authorization: Bearer $RENDER_KEY" -H "Content-Type: application/json" -H "Accept: application/json")

say(){ printf "\n\033[1;33m▸ %s\033[0m\n" "$*"; }

# ---------- 1. repositório ----------
say "Criando o repositório e subindo os arquivos"
if command -v gh >/dev/null 2>&1; then
  gh repo create "$REPO" --public --source=. --remote=origin --push 2>/dev/null \
    || { git remote add origin "https://github.com/$REPO.git" 2>/dev/null || true; git push -u origin main; }
else
  echo "  gh CLI não encontrado — crie o repo em https://github.com/new (nome: genialadvisors-capital) e rode:"
  echo "    git remote add origin https://github.com/$REPO.git && git push -u origin main"
  read -rp "  Pressione ENTER quando o push tiver terminado..."
fi

# ---------- 2. serviço na Render ----------
say "Criando o site estático na Render"
CREATE=$(curl -s -X POST "${H[@]}" "$API/services" -d @- <<JSON
{"type":"static_site","name":"$SVC","ownerId":"$OWNER_ID",
 "repo":"https://github.com/$REPO","branch":"main","autoDeploy":"yes",
 "serviceDetails":{"publishPath":".","buildCommand":""}}
JSON
)
SID=$(printf '%s' "$CREATE" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('service',{}).get('id') or '')")
if [ -z "$SID" ]; then
  SID=$(curl -s "${H[@]}" "$API/services?name=$SVC&limit=1" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d[0]['service']['id'] if d else '')")
fi
[ -n "$SID" ] || { echo "Falhou ao criar/localizar o serviço:"; echo "$CREATE"; exit 1; }
echo "  serviço: $SID"

# ---------- 3. domínios ----------
say "Ligando genialadvisors.capital e www"
for d in genialadvisors.capital www.genialadvisors.capital; do
  curl -s -X POST "${H[@]}" "$API/services/$SID/custom-domains" -d "{\"name\":\"$d\"}" >/dev/null || true
  echo "  + $d"
done

# ---------- 4. esperar ficar no ar ----------
say "Aguardando o primeiro deploy (o DNS já está apontado)"
for i in $(seq 1 40); do
  st=$(curl -s "${H[@]}" "$API/services/$SID/deploys?limit=1" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d[0]['deploy']['status'] if d else '?')")
  printf "  [%02d] deploy: %s\n" "$i" "$st"
  [ "$st" = "live" ] && break
  case "$st" in build_failed|update_failed|canceled) echo "  deploy falhou — veja o log em https://dashboard.render.com/static/$SID"; exit 1;; esac
  sleep 15
done

say "Verificando"
curl -sI "https://$SVC.onrender.com" | head -1
curl -sI "https://genialadvisors.capital" | head -1
echo
echo "  Pronto: https://genialadvisors.capital"
echo "  (o certificado TLS do domínio custom leva alguns minutos a mais para emitir)"
