#!/usr/bin/env bash
# =============================================================================
# download_models.sh — Baixa os 3 modelos do Hugging Face para uso com vLLM.
#
# PRÉ-REQUISITO: ambiente conda ativado  ->  conda activate dinsql
#                (o huggingface-cli vem junto com transformers/vLLM)
#
# USO (na máquina de 24 GB):
#   conda activate dinsql
#   bash download_models.sh
#   MODELS_DIR=/dados/models bash download_models.sh   # destino alternativo
#   bash download_models.sh Qwen/Qwen2.5-Coder-7B-Instruct   # só um modelo
#
# ESPAÇO: ~13-15 GB por modelo em FP16  ->  ~45 GB no total para os três.
#
# OBS: o vLLM também consegue baixar sozinho na 1ª execução (basta passar o
#      repo id). Pré-baixar aqui garante reprodutibilidade e runs offline.
# =============================================================================

set -euo pipefail

MODELS_DIR="${MODELS_DIR:-$(pwd)/models}"

# Modelos do plano (backbone principal + 2 de extensão). Pode sobrescrever
# passando os repo ids como argumentos.
DEFAULT_MODELS=(
  "Qwen/Qwen2.5-Coder-7B-Instruct"            # Alibaba (backbone principal)
  "deepseek-ai/deepseek-coder-6.7b-instruct"  # DeepSeek
  "01-ai/Yi-Coder-9B-Chat"                    # 01.AI
  "ibm-granite/granite-8b-code-instruct-128k"  # IBM (contexto 128k; o -4k não comporta os prompts)
  "microsoft/Phi-3.5-mini-instruct"           # Microsoft
)
if [ "$#" -gt 0 ]; then MODELS=("$@"); else MODELS=("${DEFAULT_MODELS[@]}"); fi

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[1;32m    ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    ! %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31mERRO: %s\033[0m\n' "$*" >&2; exit 1; }

# CLI do HF: nas versões novas é "hf", nas antigas "huggingface-cli".
if command -v hf >/dev/null 2>&1; then HF=(hf);
elif command -v huggingface-cli >/dev/null 2>&1; then HF=(huggingface-cli);
else die "huggingface-cli/hf não encontrado (ative o env: conda activate dinsql)"; fi

# Acelerador de download opcional (instala hf_transfer se disponível).
if python3 -c "import hf_transfer" >/dev/null 2>&1; then
  export HF_HUB_ENABLE_HF_TRANSFER=1
  ok "hf_transfer ativo (download mais rápido)"
fi

# Token opcional (nenhum destes modelos é gated, mas respeita se existir).
TOKEN_ARG=()
if [ -n "${HF_TOKEN:-}" ]; then TOKEN_ARG=(--token "$HF_TOKEN"); fi

mkdir -p "$MODELS_DIR"
log "Destino dos modelos: $MODELS_DIR"
echo "    Espaço livre: $(df -h "$MODELS_DIR" | awk 'NR==2{print $4}')"

for repo in "${MODELS[@]}"; do
  name="${repo##*/}"                 # parte final do repo id
  dest="$MODELS_DIR/$name"
  log "Baixando $repo"
  if [ -f "$dest/config.json" ]; then
    warn "$name já presente em $dest — pulando"
    continue
  fi
  # --exclude aceita 1 padrão por vez no CLI (Click) -> repetir o flag.
  # Pula GGUF e pesos "original/" (duplicatas grandes), sem remover os pesos reais.
  "${HF[@]}" download "$repo" \
      --local-dir "$dest" \
      --exclude "*.gguf" \
      --exclude "original/*" \
      "${TOKEN_ARG[@]}"
  ok "$name -> $dest"
done

log "Verificação"
for repo in "${MODELS[@]}"; do
  name="${repo##*/}"; dest="$MODELS_DIR/$name"
  if [ -f "$dest/config.json" ]; then
    sz="$(du -sh "$dest" 2>/dev/null | awk '{print $1}')"
    arch="$(python3 -c "import json;print(json.load(open('$dest/config.json')).get('architectures',['?'])[0])" 2>/dev/null || echo '?')"
    printf '    ✓ %-32s %6s  (%s)\n' "$name" "$sz" "$arch"
  else
    printf '    ✗ %-32s FALTANDO\n' "$name"
  fi
done

log "Modelos prontos ✅"
cat <<EOF

  Para servir com o vLLM (exemplo, backbone principal):
      python -m vllm.entrypoints.openai.api_server \\
          --model $MODELS_DIR/Qwen2.5-Coder-7B-Instruct \\
          --served-model-name qwen2.5-coder-7b \\
          --dtype auto --max-model-len 8192 --port 8000

  (Em 24 GB dá para rodar em FP16; para folga de KV-cache use --quantization
   awq/gptq com um checkpoint quantizado, ou --dtype half.)

EOF
