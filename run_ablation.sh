#!/usr/bin/env bash
# =============================================================================
# run_ablation.sh — Ablation study do DIN-SQL (Tabela 5 do paper), em UM modelo.
#
# Sobe o vLLM do modelo UMA vez e roda as 4 variantes "ablacionadas" contra ele
# (o "full" é reaproveitado de results/pred_<modelo>.sql, gerado antes).
# Cada variante: gera predições -> avalia EX/EM por dificuldade.
#
# PRÉ-REQUISITO: conda activate dinsql  (e o "full" do modelo já rodado)
#
# USO:
#   bash run_ablation.sh                                   # Qwen (default)
#   bash run_ablation.sh models/deepseek-coder-6.7b-instruct
#   GPU_UTIL=0.65 bash run_ablation.sh                     # GPU compartilhada
#   LIMIT=5 bash run_ablation.sh                           # smoke do ablation
#
# Saídas:
#   results/abl_<modelo>_<variante>.sql   + results/eval_abl_<modelo>_<variante>.txt
#   variantes: no_selfcorr | no_schemalink | fewshot(force easy) | cot(force nested)
# =============================================================================

set -uo pipefail   # sem -e: continua mesmo se uma variante falhar

MODEL="${1:-models/Qwen2.5-Coder-7B-Instruct}"
DATASET="${DATASET:-data/subset/}"
PORT="${PORT:-8000}"
BASE="http://localhost:${PORT}/v1"
READY_TIMEOUT="${READY_TIMEOUT:-900}"
LIMIT="${LIMIT:-0}"
NAME="$(basename "$MODEL")"

mkdir -p results logs

# variantes do ablation: "rótulo:flags do din_sql.py"
VARIANTS=(
  "no_selfcorr:--no-self-correction"
  "no_schemalink:--no-schema-linking"
  "fewshot:--force-class easy"
  "cot:--force-class nested"
)

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

echo "==================== ABLATION: $NAME ===================="
echo "  (o 'full' é reaproveitado de results/pred_${NAME}.sql)"

# --- sobe o servidor UMA vez (mesmo modelo p/ todas as variantes) ---
stop_server; sleep 3
echo "  subindo vLLM (log: logs/vllm_${NAME}_ablation.log) ..."
nohup bash serve_vllm.sh "$MODEL" > "logs/vllm_${NAME}_ablation.log" 2>&1 &
if ! wait_ready; then
  echo "  [ERRO] servidor não ficou pronto — veja logs/vllm_${NAME}_ablation.log"
  exit 1
fi
echo "  servidor pronto."

# --- roda cada variante contra o mesmo servidor ---
for v in "${VARIANTS[@]}"; do
  label="${v%%:*}"; flags="${v#*:}"
  pred="results/abl_${NAME}_${label}${sfx}.sql"
  echo
  echo "  >>> variante '${label}'  (flags: ${flags})"
  python src/din_sql.py --dataset "$DATASET" --base-url "$BASE" \
         $flags "${limit_arg[@]}" --output "$pred"
  echo "  avaliando '${label}' ..."
  bash run_eval.sh "$pred" "$gold" | tee "results/eval_abl_${NAME}_${label}${sfx}.txt"
done

stop_server
echo
echo "Ablation concluído. Resultados em results/abl_${NAME}_*.sql e results/eval_abl_${NAME}_*.txt"
echo "Lembre: o 'full' é o results/eval_${NAME}.txt (run completo já feito)."
