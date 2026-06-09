# Reprodução do DIN-SQL — Projeto FPCC2

Reprodução de **DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction**
(Pourreza & Rafiei, NeurIPS 2023 — [arXiv:2304.11015](https://arxiv.org/abs/2304.11015)), trocando o
GPT-4 por LLMs locais (custo $0) e acrescentando o **rigor estatístico** ausente no paper original.

> **Autor:** Gabriel Dantas de Oliveira · **Backbone principal:** Qwen2.5-Coder-7B-Instruct via vLLM
> **Avaliação:** subset estratificado de 200 queries do Spider dev · métricas EX e EM.

---

## ✅ Pré-requisitos

- **GPU com ~24 GB de VRAM** (onde rodam os experimentos) + `conda`/`miniconda`.
- ~50 GB de disco livre (modelos ~45 GB + Spider ~1 GB).
- Acesso à internet para baixar dados e modelos.

---

## 🚀 Como rodar (passo a passo)

Todos os comandos a partir da raiz do projeto (`replicacao/`).

### 1. Ambiente

```bash
bash setup_env.sh          # cria o env conda "dinsql" (vLLM + libs)
conda activate dinsql
```

### 2. Dados (Spider + avaliador oficial)

```bash
bash download_spider.sh    # baixa Spider (c/ bancos .sqlite) + test-suite-sql-eval
```

### 3. Modelos

```bash
bash download_models.sh    # Qwen2.5-Coder-7B, DeepSeek-Coder-6.7B, SQLCoder-7B-2
```

### 3b. Subset estratificado de avaliação (não precisa de GPU)

```bash
python src/build_subset.py    # gera data/subset/ (200 queries: 70E/70M/35H/25X, seed=42)
```

> **NatSQL:** *não é necessário rodar* o `check_and_preprocess.sh`. As representações
> intermediárias já estão embutidas nos prompts do `DIN-SQL.py`. (Detalhe em [Notas](#-notas).)

### 4. Servir o modelo (deixe rodando num terminal)

```bash
bash serve_vllm.sh                       # Qwen2.5-Coder-7B (default) na porta 8000
# ou: bash serve_vllm.sh models/deepseek-coder-6.7b-instruct
```

### 5. Rodar o pipeline DIN-SQL (em outro terminal)

```bash
# smoke test: só as 5 primeiras queries
python src/din_sql.py \
    --dataset data/spider_data/ \
    --output pred_smoke.sql \
    --limit 5

# run sobre o subset estratificado (200 queries)
python src/din_sql.py --dataset data/subset/ --output pred_subset.sql
```

O modelo é **auto-detectado** via `/models`; para fixar, use `--model <nome>`.
Teste rápido da conexão com o servidor: `python src/llm_client.py`.

### 6. Avaliar (EX + EM por dificuldade)

```bash
bash run_eval.sh pred_subset.sql      # usa data/subset/dev_gold.sql por default
```

---

## 📂 Estrutura do projeto

```
replicacao/
├── README.md                       # este arquivo (atualizado a cada etapa)
├── setup_env.sh                    # [Dia 1] cria o ambiente conda
├── requirements.txt                # extras instalados após o vLLM
├── download_spider.sh              # [Dia 1] baixa Spider + avaliador EX/EM
├── download_models.sh              # [Dia 1] baixa os 3 modelos do HF
├── serve_vllm.sh                   # [Dia 2] sobe o servidor vLLM
├── run_eval.sh                     # [Dia 3] avalia EX/EM (wrapper do avaliador oficial)
├── run_backbones.sh                # [Ext.A] roda os modelos em sequência (serve->roda->avalia)
├── run_ablation.sh                 # [Ablation] 4 variantes (Tabela 5) num modelo, servidor 1x
├── run_robustness.sh               # [Ext.B] robustez à temperatura (temps × N reps), servidor 1x
├── src/
│   ├── llm_client.py               # [Dia 2] wrapper vLLM (OpenAI-compatible)
│   ├── din_sql.py                  # [Dia 2] DIN-SQL adaptado (API antiga -> vLLM)
│   ├── build_subset.py             # [Dia 3] subset estratificado (200, seed=42)
│   ├── collect_results.py          # [Bloco 5] matriz acerto/erro por query (EX)
│   └── analyze.py                  # [Bloco 5] McNemar, Bootstrap, Friedman+Holm, Cohen's h
├── Few-shot-NL2SQL-with-prompting/ # repo original do DIN-SQL (código + prompts)
├── NatSQL/                         # repo NatSQL (não usado em inferência)
├── data/                           # (criado) Spider + test-suite-sql-eval
├── models/                         # (criado) checkpoints dos 3 modelos
└── 2304.11015v3.pdf                # artigo
```

---

## 🗓️ Progresso (cronograma de 14 dias · 31/05 → 14/06)

- [x] **Dia 1 — Setup & dados:** scripts de ambiente, download do Spider e dos modelos.
- [x] **Dia 2 — Adaptação do código:** `src/llm_client.py` (API antiga → endpoint vLLM) + `src/din_sql.py` refatorado + `serve_vllm.sh`.
- [x] **Dia 3 — Subset & métricas:** subset estratificado (200, seed=42) gerado + avaliação EX/EM validada (gold-vs-gold = 100%). *Falta só o smoke test de inferência real (precisa do servidor vLLM na GPU).*
- [ ] **Dias 4–5 — Baseline:** reprodução por dificuldade vs. paper.
- [ ] **Dias 6–7 — Ablation:** 5 configurações (Tabela 5).
- [ ] **Dias 8–9 — Extensão A:** comparação de 3 backbones.
- [ ] **Dias 10–11 — Extensão B:** robustez (temperature × #few-shot, N=5).
- [ ] **Dias 12–13 — Estatística:** McNemar, Bootstrap IC95%, Friedman+Holm, Cohen's h.
- [ ] **Dia 14 — Entrega:** relatório técnico + repositório público.

---

## 📊 Avaliação (EX / EM)

Depois de gerar as predições (`.sql`, uma por linha):

```bash
cd data/test-suite-sql-eval
python3 evaluation.py \
    --gold  ../spider_data/dev_gold.sql \
    --pred  <suas_predicoes.sql> \
    --db    ../spider_data/database \
    --table ../spider_data/tables.json \
    --etype all          # EX + EM
```

---

## 📝 Notas

- **Hardware:** os experimentos rodam numa máquina dedicada com GPU de **24 GB**; em 24 GB os três
  modelos de 7B cabem (FP16 ou quantizados) via vLLM.
- **Ordem de instalação:** o `setup_env.sh` instala o **vLLM primeiro** (ele fixa `torch`/`transformers`/`numpy`
  casados à CUDA) e só depois os extras — evita conflito de versões.
- **NatSQL não é usado em inferência:** o `DIN-SQL.py` não importa o NatSQL; as representações
  intermediárias estão *hardcoded* nas demonstrações few-shot dos prompts. O `check_and_preprocess.sh`
  só serviria para *regenerar* esses exemplos (stack legada com `spacy==2.2.3`, fora do escopo).
- **Spider:** baixado do Google Drive oficial (Yale LILY) porque o dataset do Hugging Face não inclui
  os bancos `.sqlite`, indispensáveis para a Execution Accuracy.

---

*README atualizado incrementalmente conforme o projeto avança. Última etapa concluída: **Dia 3** (subset + avaliação validados sem GPU; smoke test de inferência pendente na máquina com GPU).*
