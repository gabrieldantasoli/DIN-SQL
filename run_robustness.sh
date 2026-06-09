#!/usr/bin/env bash
# =============================================================================
# run_robustness.sh — Extensão B: robustez do prompting à TEMPERATURA.
#
# Varre temperaturas e repete N vezes (temperature>0 é estocástico) para medir
# média ± desvio do EX. Roda em UM modelo; o servidor vLLM sobe UMA vez.
#   - temperature = 0.0  -> determinístico (1 repetição)
#   - temperature > 0.0  -> N repetições, com seeds 1..N (reproduzível)
#
# PRÉ-REQUISITO: conda activate dinsql
#
# USO:
#   bash run_robustness.sh                                  # Qwen, temps padrão, N=5
#   TEMPS="0.0 0.5" N=5 bash run_robustness.sh             # escopo reduzido
#   N=3 bash run_robustness.sh                              # menos repetições
#   GPU_UTIL=0.65 bash run_robustness.sh                   # GPU compartilhada
#   LIMIT=5 bash run_robustness.sh                         # smoke
#   bash run_robustness.sh models/deepseek-coder-6.7b-instruct
#
# Saídas (por combinação temperatura×repetição):
#   results/robust_<modelo>_T<temp>_r<rep>.sql
#   results/eval_robust_<modelo>_T<temp>_r<rep>.txt
# =============================================================================

set -uo pipefail   # sem -e: continua mesmo se uma combinação falhar

MODEL="${1:-models/Qwen2.5-Coder-7B-Instruct}"
DATASET="${DATASET:-data/subset/}"
PORT="${PORT:-8000}"
BASE="http://localhost:${PORT}/v1"
READY_TIMEOUT="${READY_TIMEOUT:-900}"
LIMIT="${LIMIT:-0}"
TEMPS="${TEMPS:-0.0 0.4 0.8}"   # temperaturas a testar
N="${N:-5}"                      # repetições para temperature>0
NAME="$(basename "$MODEL")"

mkdir -p results logs

stop_server() { pkill -f "vllm.entrypoints.openai.api_server" 2>/dev/null || true; }

wait_ready() {  # espera o /models responder (só stdlib)
  python - "$BASE" "$READY_TIMEOUT" <<'PY'
import sys, time, json, urllib.request
base, maxs = sys.argv[1], int(sys.argv[2])
url = base.rstrip("/") + "/models"
t = 0
while t < maxs:
    try:
        with urllib.request.urlopen(url, timeout=5) as r:
            if json.loads(r.read().decode()).get("data"):
                sys.exit(0)
    except Exception:
        pass
    time.sleep(5); t += 5
sys.exit(1)
PY
}

trap stop_server EXIT

[ -f "$MODEL/config.json" ] || { echo "[ERRO] modelo não encontrado: $MODEL"; exit 1; }

# modo smoke?
if [ "$LIMIT" -gt 0 ]; then
  limit_arg=(--limit "$LIMIT"); sfx="_smoke"
  gold="results/gold_smoke_${LIMIT}.sql"
  head -n "$LIMIT" "${DATASET%/}/dev_gold.sql" > "$gold"
else
  limit_arg=(); sfx=""
  gold="${DATASET%/}/dev_gold.sql"
fi

echo "==================== ROBUSTEZ (Ext. B): $NAME ===================="
echo "  temperaturas: $TEMPS   N(reps p/ temp>0): $N"

# --- sobe o servidor UMA vez ---
stop_server; sleep 3
echo "  subindo vLLM (log: logs/vllm_${NAME}_robust.log) ..."
nohup bash serve_vllm.sh "$MODEL" > "logs/vllm_${NAME}_robust.log" 2>&1 &
if ! wait_ready; then
  echo "  [ERRO] servidor não ficou pronto — veja logs/vllm_${NAME}_robust.log"
  exit 1
fi
echo "  servidor pronto."

# --- varre temperaturas × repetições ---
for temp in $TEMPS; do
  # temp == 0.0 -> 1 repetição (greedy/determinístico); senão -> N
  if [ "$temp" = "0.0" ] || [ "$temp" = "0" ]; then reps=1; else reps="$N"; fi
  for rep in $(seq 1 "$reps"); do
    pred="results/robust_${NAME}_T${temp}_r${rep}${sfx}.sql"
    echo
    echo "  >>> temperature=${temp}  rep=${rep}/${reps}  (seed=${rep})"
    python src/din_sql.py --dataset "$DATASET" --base-url "$BASE" \
           --temperature "$temp" --seed "$rep" \
           "${limit_arg[@]}" --output "$pred"
    bash run_eval.sh "$pred" "$gold" \
         | tee "results/eval_robust_${NAME}_T${temp}_r${rep}${sfx}.txt" >/dev/null
    ex=$(grep "^execution" "results/eval_robust_${NAME}_T${temp}_r${rep}${sfx}.txt" \
         | awk '{print $NF}')
    echo "      EX(all)=${ex}"
  done
done

stop_server
echo
echo "Robustez concluída. Veja results/eval_robust_${NAME}_T*_r*.txt"
echo "Resumo rápido:"
grep -H "^execution" results/eval_robust_${NAME}_T*_r*${sfx}.txt 2>/dev/null \
     | awk '{print $1, "EX_all="$NF}'
