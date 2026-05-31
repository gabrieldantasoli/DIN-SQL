#!/usr/bin/env bash
# =============================================================================
# run_eval.sh — Avalia um arquivo de predições (1 SQL por linha) com o
#               avaliador OFICIAL do Spider (EX + EM), por nível de dificuldade.
#
# USO:
#   bash run_eval.sh <pred.sql> [gold.sql] [db_dir] [tables.json]
#
# Defaults apontam para o subset:
#   gold     = data/subset/dev_gold.sql
#   db_dir   = data/spider_data/database
#   tables   = data/subset/tables.json
#
# Ex.: bash run_eval.sh pred_subset.sql
# =============================================================================
set -euo pipefail

PRED="${1:?uso: bash run_eval.sh <pred.sql> [gold] [db_dir] [tables]}"
GOLD="${2:-data/subset/dev_gold.sql}"
DB_DIR="${3:-data/spider_data/database}"
TABLES="${4:-data/subset/tables.json}"
EVAL_DIR="data/test-suite-sql-eval"

for p in "$PRED" "$GOLD" "$DB_DIR" "$TABLES" "$EVAL_DIR/evaluation.py"; do
  [ -e "$p" ] || { echo "[ERRO] não encontrei: $p" >&2; exit 1; }
done

# Caminhos absolutos (o evaluation.py roda a partir do dir dele).
PRED="$(readlink -f "$PRED")"; GOLD="$(readlink -f "$GOLD")"
DB_DIR="$(readlink -f "$DB_DIR")"; TABLES="$(readlink -f "$TABLES")"

echo "==> Avaliando $PRED"
echo "    gold=$GOLD  db=$DB_DIR  etype=all"
cd "$EVAL_DIR"
python evaluation.py --gold "$GOLD" --pred "$PRED" \
    --db "$DB_DIR" --table "$TABLES" --etype all
