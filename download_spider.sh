#!/usr/bin/env bash
# =============================================================================
# download_spider.sh — Baixa o dataset Spider (com bancos .sqlite) e prepara
#                      o avaliador oficial test-suite-sql-eval (EX / EM).
#
# PRÉ-REQUISITO: ambiente conda ativado  ->  conda activate dinsql
#
# USO (na máquina de 24 GB, ou em qualquer máquina com internet):
#   conda activate dinsql
#   bash download_spider.sh
#   DATA_DIR=/dados/spider bash download_spider.sh   # diretório alternativo
#
# O QUE BAIXA (em $DATA_DIR, default ./data):
#   • spider_data/         -> dev.json, train_spider.json, tables.json,
#                             dev_gold.sql, database/ (bancos .sqlite)
#   • test-suite-sql-eval/ -> avaliador oficial (evaluation.py)
#   • test_suite_database/ -> bancos do "test suite" (EX mais rigorosa) [opcional]
# =============================================================================

set -euo pipefail

DATA_DIR="${DATA_DIR:-$(pwd)/data}"
SPIDER_ID="1403EGqzIDoHMdQF4c9Bkyl7dZLZ5Wt6J"          # spider.zip oficial (Yale LILY)
TESTSUITE_DB_ID="1mkCx2GOFIqNesD4y8TDAO1yX1QZORP5w"    # bancos do test suite
TESTSUITE_REPO="https://github.com/taoyds/test-suite-sql-eval.git"
GET_TESTSUITE_DB="${GET_TESTSUITE_DB:-1}"              # 0 para pular os bancos do test suite

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m    ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    ! %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31mERRO: %s\033[0m\n' "$*" >&2; exit 1; }

command -v python3 >/dev/null 2>&1 || die "python3 não encontrado (ative o env: conda activate dinsql)"
command -v git     >/dev/null 2>&1 || die "git não encontrado"

mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
log "Diretório de dados: $DATA_DIR"

# ----------------------- garantir gdown ------------------------------------
if ! python3 -c "import gdown" >/dev/null 2>&1; then
  log "Instalando gdown (download do Google Drive)"
  python3 -m pip install --quiet gdown
fi

# ----------------------- helper de unzip (sem depender do 'unzip') ----------
extract() {  # extract <zip> <destino>
  python3 - "$1" "$2" <<'PY'
import sys, zipfile, os
z, dest = sys.argv[1], sys.argv[2]
os.makedirs(dest, exist_ok=True)
with zipfile.ZipFile(z) as f:
    f.extractall(dest)
print(f"    extraído: {z} -> {dest}")
PY
}

# ----------------------- 1) Spider principal --------------------------------
if [ -f "spider_data/dev.json" ] || [ -f "spider/dev.json" ]; then
  warn "Spider já parece extraído — pulando download"
else
  log "Baixando spider.zip (~1.1 GB) do Google Drive"
  python3 -m gdown "https://drive.google.com/uc?id=${SPIDER_ID}" -O spider.zip
  log "Extraindo spider.zip"
  extract spider.zip .
  rm -f spider.zip
  # Normaliza: versões novas extraem em spider_data/, antigas em spider/
  if [ -d "spider_data" ]; then SPIDER_ROOT="spider_data";
  elif [ -d "spider" ]; then SPIDER_ROOT="spider";
  else die "estrutura inesperada do spider.zip"; fi
  ok "Spider em: $DATA_DIR/$SPIDER_ROOT"
fi

# Detecta a raiz para os relatórios abaixo
SPIDER_ROOT="$( [ -d spider_data ] && echo spider_data || echo spider )"

# Remove o macOS __MACOSX se existir
rm -rf __MACOSX 2>/dev/null || true

# ----------------------- 2) test-suite-sql-eval -----------------------------
if [ -d "test-suite-sql-eval/.git" ]; then
  warn "test-suite-sql-eval já clonado — atualizando"
  git -C test-suite-sql-eval pull --ff-only || true
else
  log "Clonando test-suite-sql-eval (avaliador oficial EX/EM)"
  git clone --depth 1 "$TESTSUITE_REPO"
fi
ok "Avaliador em: $DATA_DIR/test-suite-sql-eval/evaluation.py"

# ----------------------- 3) bancos do test suite (opcional) -----------------
if [ "$GET_TESTSUITE_DB" = "1" ]; then
  if [ -d "test_suite_database" ]; then
    warn "Bancos do test suite já presentes — pulando"
  else
    log "Baixando bancos do test suite (EX mais rigorosa)"
    python3 -m gdown "https://drive.google.com/uc?id=${TESTSUITE_DB_ID}" -O test_suite_database.zip
    extract test_suite_database.zip test_suite_database
    rm -f test_suite_database.zip
    ok "Bancos do test suite em: $DATA_DIR/test_suite_database"
  fi
else
  warn "GET_TESTSUITE_DB=0 — pulei os bancos do test suite (EX usará só os bancos do dev)"
fi

# ----------------------- Verificação ----------------------------------------
log "Verificação do conteúdo do Spider"
python3 - "$SPIDER_ROOT" <<'PY'
import json, sys, os
root = sys.argv[1]
def count(p):
    try:
        with open(os.path.join(root, p)) as f: return len(json.load(f))
    except Exception as e: return f"ERRO({e})"
print(f"    dev.json:          {count('dev.json')} exemplos")
print(f"    train_spider.json: {count('train_spider.json')} exemplos")
print(f"    tables.json:       {count('tables.json')} esquemas")
dbdir = os.path.join(root, "database")
if os.path.isdir(dbdir):
    sqlite = sum(1 for d in os.listdir(dbdir)
                 if os.path.exists(os.path.join(dbdir, d, d + ".sqlite")))
    print(f"    database/:         {len(os.listdir(dbdir))} pastas, {sqlite} bancos .sqlite")
else:
    print("    database/:         AUSENTE (!)")
gold = os.path.join(root, "dev_gold.sql")
print(f"    dev_gold.sql:      {'presente' if os.path.exists(gold) else 'ausente'}")
PY

log "Spider + avaliador prontos ✅"
cat <<EOF

  Caminhos (use no código / nos scripts de avaliação):
      SPIDER_DIR  = $DATA_DIR/$SPIDER_ROOT
      DEV_JSON    = $DATA_DIR/$SPIDER_ROOT/dev.json
      DB_DIR      = $DATA_DIR/$SPIDER_ROOT/database
      GOLD        = $DATA_DIR/$SPIDER_ROOT/dev_gold.sql
      TABLES      = $DATA_DIR/$SPIDER_ROOT/tables.json
      EVALUATOR   = $DATA_DIR/test-suite-sql-eval/evaluation.py

  Exemplo de avaliação (EX + EM) depois de gerar as predições:
      cd $DATA_DIR/test-suite-sql-eval
      python3 evaluation.py \\
          --gold   $DATA_DIR/$SPIDER_ROOT/dev_gold.sql \\
          --pred   <suas_predicoes.sql> \\
          --db     $DATA_DIR/$SPIDER_ROOT/database \\
          --table  $DATA_DIR/$SPIDER_ROOT/tables.json \\
          --etype  all

EOF
