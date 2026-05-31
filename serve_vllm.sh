#!/usr/bin/env bash
# =============================================================================
# serve_vllm.sh — Sobe o servidor vLLM (API OpenAI-compatible) para o DIN-SQL.
#
# PRÉ-REQUISITO: conda activate dinsql  (e modelo baixado via download_models.sh)
#
# USO (na máquina de 24 GB):
#   bash serve_vllm.sh                                   # Qwen2.5-Coder-7B (default)
#   bash serve_vllm.sh models/deepseek-coder-6.7b-instruct
#   MODEL=models/sqlcoder-7b-2 PORT=8001 bash serve_vllm.sh
#
# Deixe este processo rodando num terminal; em outro, rode o pipeline:
#   python src/din_sql.py --dataset data/spider_data/ --output pred.sql --limit 5
# =============================================================================

set -euo pipefail

MODEL="${1:-${MODEL:-models/Qwen2.5-Coder-7B-Instruct}}"
PORT="${PORT:-8000}"
SERVED_NAME="${SERVED_NAME:-$(basename "$MODEL")}"
MAX_LEN="${MAX_LEN:-8192}"
GPU_UTIL="${GPU_UTIL:-0.90}"          # fração da VRAM para o vLLM
DTYPE="${DTYPE:-auto}"                # auto | half | bfloat16 | float16
EXTRA_ARGS="${EXTRA_ARGS:-}"          # ex.: "--quantization awq" p/ checkpoint quantizado

echo "==> Servindo '$MODEL' como '$SERVED_NAME' na porta $PORT"
echo "    max-model-len=$MAX_LEN  gpu-util=$GPU_UTIL  dtype=$DTYPE  extra='$EXTRA_ARGS'"
echo "    (Ctrl+C para parar. Endpoint: http://localhost:$PORT/v1)"

exec python -m vllm.entrypoints.openai.api_server \
    --model "$MODEL" \
    --served-model-name "$SERVED_NAME" \
    --port "$PORT" \
    --dtype "$DTYPE" \
    --max-model-len "$MAX_LEN" \
    --gpu-memory-utilization "$GPU_UTIL" \
    $EXTRA_ARGS
