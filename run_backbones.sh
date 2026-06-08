#!/usr/bin/env bash
# =============================================================================
# run_backbones.sh — Roda o DIN-SQL no subset para VÁRIOS modelos, em sequência.
#                    (Extensão A: comparação de backbones — Dia 8-9.)
#
# Para cada modelo: sobe o vLLM -> espera ficar pronto -> roda din_sql no subset
# -> avalia EX/EM -> derruba o vLLM (libera a VRAM) -> próximo modelo.
#
# PRÉ-REQUISITO: conda activate dinsql   (modelos baixados em models/)
#
# USO:
#   bash run_backbones.sh                         # os 3 modelos, subset completo
#   LIMIT=5 bash run_backbones.sh                 # SMOKE: só 5 queries por modelo
#   bash run_backbones.sh models/sqlcoder-7b-2    # só um/alguns
#
# Saídas:
#   results/pred_<modelo>.sql   results/eval_<modelo>.txt   logs/vllm_<modelo>.log
#   (no modo smoke, sufixo _smoke nos arquivos)
# =============================================================================

set -uo pipefail   # sem -e: queremos continuar mesmo se um modelo falhar

MODELS=( "$@" )
if [ ${#MODELS[@]} -eq 0 ]; then
  MODELS=( models/Qwen2.5-Coder-7B-Instruct \
           models/deepseek-coder-6.7b-instruct \
           models/Yi-Coder-9B-Chat \
           models/granite-8b-code-instruct-4k \
           models/Phi-3.5-mini-instruct )
fi
DATASET="${DATASET:-data/subset/}"
PORT="${PORT:-8000}"
BASE="http://localhost:${PORT}/v1"
READY_TIMEOUT="${READY_TIMEOUT:-900}"   # segundos p/ o servidor subir
LIMIT="${LIMIT:-0}"                      # >0 = modo smoke (só N queries/modelo)

mkdir -p results logs

stop_server() { pkill -f "vllm.entrypoints.openai.api_server" 2>/dev/null || true; }

wait_ready() {  # espera o endpoint /models responder
  python - "$BASE" "$READY_TIMEOUT" <<'PY'
import sys, time
from openai import OpenAI
base, maxs = sys.argv[1], int(sys.argv[2])
c = OpenAI(base_url=base, api_key="EMPTY")
t = 0
while t < maxs:
    try:
        if c.models.list().data:
            sys.exit(0)
    except Exception:
        pass
    time.sleep(5); t += 5
sys.exit(1)
PY
}

trap stop_server EXIT   # garante limpeza se o script for interrompido

for model in "${MODELS[@]}"; do
  name="$(basename "$model")"
  echo
  echo "==================== $name ===================="
  if [ ! -f "$model/config.json" ]; then
    echo "  [skip] não encontrado: $model (rode download_models.sh)"; continue
  fi

  stop_server; sleep 3                       # garante GPU livre
  echo "  subindo vLLM (log: logs/vllm_${name}.log) ..."
  nohup bash serve_vllm.sh "$model" > "logs/vllm_${name}.log" 2>&1 &

  if ! wait_ready; then
    echo "  [ERRO] servidor não ficou pronto p/ $name — veja logs/vllm_${name}.log"
    stop_server; continue
  fi
  # modo smoke (LIMIT>0): só N queries + gold das N primeiras
  if [ "$LIMIT" -gt 0 ]; then
    limit_arg=(--limit "$LIMIT"); sfx="_smoke"
    gold="results/gold_smoke_${LIMIT}.sql"
    head -n "$LIMIT" "${DATASET%/}/dev_gold.sql" > "$gold"
    echo "  servidor pronto. SMOKE: $LIMIT queries ..."
  else
    limit_arg=(); sfx=""
    gold="${DATASET%/}/dev_gold.sql"
    echo "  servidor pronto. Rodando DIN-SQL no subset completo ($DATASET) ..."
  fi
  pred="results/pred_${name}${sfx}.sql"

  python src/din_sql.py --dataset "$DATASET" --base-url "$BASE" \
         "${limit_arg[@]}" --output "$pred"

  echo "  avaliando EX/EM ..."
  bash run_eval.sh "$pred" "$gold" | tee "results/eval_${name}${sfx}.txt"

  stop_server; sleep 5                        # libera VRAM antes do próximo
done

echo
echo "Concluído. Veja results/pred_*.sql e results/eval_*.txt"
