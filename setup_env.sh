#!/usr/bin/env bash
# =============================================================================
# setup_env.sh — Cria automaticamente o ambiente conda para a reprodução do
#                DIN-SQL (projeto FPCC2 / Gabriel Dantas de Oliveira).
#
# O QUE FAZ:
#   1. Localiza o conda/mamba na máquina (não precisa estar ativado).
#   2. Cria um env Python isolado (default: "dinsql", Python 3.10).
#   3. Instala o vLLM (que traz torch + transformers + numpy casados à CUDA).
#   4. Instala os extras de requirements.txt (estatística, eval, gráficos).
#   5. Baixa os dados do NLTK e faz checagens de sanidade.
#
# USO (rodar na MÁQUINA COM GPU de 24 GB):
#   bash setup_env.sh                 # cria o env "dinsql"
#   bash setup_env.sh --force         # recria do zero (remove o env existente)
#   ENV_NAME=meuenv bash setup_env.sh # nome customizado
#   VLLM_VERSION=0.6.4 bash setup_env.sh
#
# Depois de rodar:
#   conda activate dinsql
#
# NOTA: este script NÃO baixa o dataset Spider nem os modelos — isso é feito
#       por scripts separados (próximos passos do Dia 1).
# =============================================================================

set -euo pipefail

# ----------------------------- Configuração ---------------------------------
ENV_NAME="${ENV_NAME:-dinsql}"
PYTHON_VERSION="${PYTHON_VERSION:-3.10}"
VLLM_VERSION="${VLLM_VERSION:-0.6.6.post1}"   # versão que suporta Qwen2.5/Llama/DeepSeek
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQ_FILE="${SCRIPT_DIR}/requirements.txt"

FORCE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help) grep -E '^#' "$0" | sed 's/^# \{0,1\}//' | head -40; exit 0 ;;
    *) echo "Argumento desconhecido: $arg (use --help)"; exit 1 ;;
  esac
done

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m    ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    ! %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31mERRO: %s\033[0m\n' "$*" >&2; exit 1; }

# --------------------------- Localizar o conda ------------------------------
log "Localizando conda/mamba"
CONDA_BIN=""
if command -v conda >/dev/null 2>&1; then
  CONDA_BIN="$(command -v conda)"
else
  for cand in "$HOME/miniconda3" "$HOME/anaconda3" "$HOME/miniforge3" "/opt/conda"; do
    if [ -x "$cand/bin/conda" ]; then CONDA_BIN="$cand/bin/conda"; break; fi
  done
fi
[ -n "$CONDA_BIN" ] || die "conda não encontrado. Instale o Miniconda e rode de novo."
ok "conda: $CONDA_BIN ($("$CONDA_BIN" --version))"

# Usa mamba para o solver se existir (bem mais rápido); senão, conda mesmo.
SOLVER="$CONDA_BIN"
if command -v mamba >/dev/null 2>&1; then
  SOLVER="$(command -v mamba)"
  ok "mamba detectado — será usado para criar o env (mais rápido)"
fi

# Helper: roda um comando dentro do env, com saída em tempo real.
run_in_env() { "$CONDA_BIN" run --no-capture-output -n "$ENV_NAME" "$@"; }

# ----------------------- Criar / recriar o ambiente -------------------------
ENV_EXISTS=0
if "$CONDA_BIN" env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
  ENV_EXISTS=1
fi

if [ "$ENV_EXISTS" -eq 1 ] && [ "$FORCE" -eq 1 ]; then
  log "Removendo env existente '$ENV_NAME' (--force)"
  "$CONDA_BIN" env remove -y -n "$ENV_NAME"
  ENV_EXISTS=0
fi

if [ "$ENV_EXISTS" -eq 0 ]; then
  log "Criando env '$ENV_NAME' (Python $PYTHON_VERSION)"
  "$SOLVER" create -y -n "$ENV_NAME" "python=${PYTHON_VERSION}" pip
  ok "env criado"
else
  warn "env '$ENV_NAME' já existe — reaproveitando (use --force para recriar)"
fi

# ------------------------- Ferramentas de build -----------------------------
log "Atualizando pip / setuptools / wheel"
run_in_env python -m pip install --upgrade pip setuptools wheel

# ------------------------------ Instalar vLLM -------------------------------
# Instalado PRIMEIRO: ele fixa torch/transformers/numpy compatíveis com a CUDA.
log "Instalando vLLM ${VLLM_VERSION} (traz torch + transformers)"
run_in_env python -m pip install "vllm==${VLLM_VERSION}"
ok "vLLM instalado"

# ------------------------------ Extras --------------------------------------
# Sem --upgrade: o resolvedor mantém numpy/torch que o vLLM fixou.
[ -f "$REQ_FILE" ] || die "requirements.txt não encontrado em $REQ_FILE"
log "Instalando extras de requirements.txt"
run_in_env python -m pip install --upgrade-strategy only-if-needed -r "$REQ_FILE"
ok "extras instalados"

# --------------------------- Dados do NLTK ----------------------------------
log "Baixando dados do NLTK (punkt)"
run_in_env python - <<'PY' || warn "download do NLTK falhou (não crítico)"
import nltk
for pkg in ("punkt", "punkt_tab"):
    try:
        nltk.download(pkg, quiet=True)
    except Exception as e:
        print(f"  aviso: {pkg} -> {e}")
PY

# --------------------------- Checagem de sanidade ---------------------------
log "Checagem de sanidade do ambiente"
run_in_env python - <<'PY'
import importlib, sys
print(f"    Python: {sys.version.split()[0]}")
mods = ["vllm", "torch", "transformers", "openai", "pandas",
        "scipy", "statsmodels", "sklearn", "nltk", "matplotlib", "seaborn"]
falhou = []
for m in mods:
    try:
        mod = importlib.import_module(m)
        v = getattr(mod, "__version__", "?")
        print(f"    ✓ {m:<14} {v}")
    except Exception as e:
        falhou.append(m); print(f"    ✗ {m:<14} ({e})")

import torch
if torch.cuda.is_available():
    n = torch.cuda.device_count()
    name = torch.cuda.get_device_name(0)
    mem = torch.cuda.get_device_properties(0).total_memory / 1024**3
    print(f"    ✓ CUDA disponível: {n} GPU(s) — {name} ({mem:.1f} GB)")
else:
    print("    ! CUDA NÃO disponível nesta máquina.")
    print("      (OK se este é o host de desenvolvimento; o vLLM exige GPU para inferência.)")

if falhou:
    sys.exit(f"Módulos faltando: {falhou}")
PY

# ------------------------------- Resumo -------------------------------------
log "Ambiente '$ENV_NAME' pronto ✅"
cat <<EOF

  Para usar:
      conda activate $ENV_NAME

  Próximos passos (Dia 1, scripts separados):
      • baixar o Spider (dev set + bancos .sqlite + test-suite-sql-eval)
      • baixar os modelos: Qwen2.5-Coder-7B-Instruct, deepseek-coder-6.7b-instruct, SQLCoder-7B-2
      • subir o servidor vLLM, ex.:
            python -m vllm.entrypoints.openai.api_server \\
                --model Qwen/Qwen2.5-Coder-7B-Instruct \\
                --dtype auto --max-model-len 8192 --port 8000

EOF
