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
#   bash run_backbones.sh                         # os 3 modelos do plano
#   bash run_backbones.sh models/sqlcoder-7b-2    # só um/alguns
#
# Saídas:
#   results/pred_<modelo>.sql   results/eval_<modelo>.txt   logs/vllm_<modelo>.log
# =============================================================================

set -uo pipefail   # sem -e: queremos continuar mesmo se um modelo falhar

MODELS=( "$@" )
if [ ${#MODELS[@]} -eq 0 ]; then
  MODELS=( models/Qwen2.5-Coder-7B-Instruct \
           models/deepseek-coder-6.7b-instruct \
           models/sqlcoder-7b-2 )
fi
DATASET="${DATASET:-data/subset/}"
PORT="${PORT:-8000}"
BASE="http://localhost:${PORT}/v1"
READY_TIMEOUT="${READY_TIMEOUT:-900}"   # segundos p/ o servidor subir

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
  echo "  servidor pronto. Rodando DIN-SQL no subset ($DATASET) ..."

  python src/din_sql.py --dataset "$DATASET" --base-url "$BASE" \
         --output "results/pred_${name}.sql"

  echo "  avaliando EX/EM ..."
  bash run_eval.sh "results/pred_${name}.sql" | tee "results/eval_${name}.txt"

  stop_server; sleep 5                        # libera VRAM antes do próximo
done

echo
echo "Concluído. Veja results/pred_*.sql e results/eval_*.txt"
