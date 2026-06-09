# Metodologia experimental

Documento de desenho experimental da reprodução do **DIN-SQL** (Pourreza & Rafiei, NeurIPS 2023), alinhado aos requisitos da disciplina (hipóteses testáveis, variáveis, controle de fatores/níveis, repetições, randomização, tratamento estatístico com IC, testes de hipótese, variabilidade e normalidade).

---

## 1. Objeto e cenários comparados

Reprodução parcial do DIN-SQL substituindo o GPT-4 por **LLMs locais abertos** (vLLM, custo $0), avaliando text-to-SQL no **Spider**. Três famílias de cenários são comparadas:

- **A. Backbones** — 5 modelos instruct de 5 provedores, sob o mesmo pipeline DIN-SQL.
- **B. Ablation** — ligar/desligar cada um dos 4 módulos do DIN-SQL (Tabela 5 do paper).
- **C. Robustez** — variar a temperatura de decodificação.

---

## 2. Hipóteses (testáveis)

| # | Hipótese | Teste estatístico |
|---|---|---|
| **H1** | Um code-LLM aberto de ~7B sob DIN-SQL atinge EX **comparável** ao GPT-4 reportado no paper. | EX + IC95% (bootstrap); comparação por dificuldade |
| **H2** | Cada módulo do DIN-SQL **contribui** para o EX (removê-lo reduz o EX). | McNemar pareado (full vs ablado) + Cohen's h |
| **H3** | Há **diferença significativa** de EX entre os 5 backbones. | Friedman + post-hoc McNemar (Bonferroni-Holm) |
| **H4** | Temperatura maior **aumenta a variabilidade** do EX **sem ganho** na média. | Shapiro-Wilk (normalidade) → Levene (variância) + Kruskal/Mann-Whitney (média) |

---

## 3. Variáveis

**Independentes (fatores e níveis):**
| Fator | Níveis |
|---|---|
| Backbone | Qwen2.5-Coder-7B · DeepSeek-Coder-6.7B · Yi-Coder-9B · Granite-8B-code-128k · Phi-3.5-mini-3.8B (5) |
| Configuração de módulos (ablation) | full · sem self-correction · sem schema-linking · sem classificação→few-shot · sem classificação→CoT (5) |
| Temperatura | 0.0 · 0.4 · 0.8 (3) |

**Dependentes:** Execution Accuracy (**EX**, primária) e Exact-Set-Match (**EM**, secundária).

**Controladas (constantes):** subset de avaliação (mesmas 200 queries, `seed=42`), prompts do DIN-SQL, parâmetros de decodificação (max_tokens, stop tokens), avaliador oficial (`test-suite-sql-eval`), hardware (RTX 4090) e serving (vLLM, FP16).

---

## 4. Desenho experimental

- **Amostragem:** aleatória **estratificada** por dificuldade do Spider dev (1.034 → 200), `random_state=42`. Estratos: easy 70 · medium 70 · hard 35 · extra 25. Hash de reprodutibilidade dos índices: `153d3fccf9a49ce6`.
- **Medidas pareadas:** todas as configurações são avaliadas **nas mesmas 200 queries** → permite testes pareados (McNemar/Friedman), mais potentes.
- **Repetições e randomização:**
  - Cenários **determinísticos** (greedy, temperature=0): **N=1** (a saída é determinística; repetir não agrega variância). Backbones e ablation usam greedy.
  - Cenário **estocástico** (temperature>0): **N=5** repetições com `seed=1..5` (reprodutível) para estimar média e variância.
- **Métricas confiáveis:** EX executa a query predita no banco e compara o resultado com o da gold (avaliador oficial do Spider); EM compara as cláusulas como conjuntos.

---

## 5. Tratamento estatístico

| Técnica | Uso | Ferramenta |
|---|---|---|
| **Bootstrap IC95%** (N=1000) | incerteza do EX de cada cenário | `numpy` |
| **McNemar** (pareado) | diferença par-a-par (ablation; backbones) | `statsmodels` |
| **Friedman** + Bonferroni-Holm | diferença global e post-hoc entre backbones | `scipy` + `statsmodels` |
| **Cohen's h** | tamanho de efeito entre proporções | manual |
| **Shapiro-Wilk** | normalidade das amostras de EX entre repetições | `scipy` |
| **Levene** | homogeneidade de variância entre temperaturas | `scipy` |
| **Kruskal-Wallis / Mann-Whitney** | efeito da temperatura na média do EX | `scipy` |

### Justificativa da escolha de testes (normalidade)
O **EX por query é uma variável binária (Bernoulli)** — normalidade **não se aplica** às comparações principais entre cenários; por isso usam-se testes **não-paramétricos pareados** (McNemar para pares; Friedman/Cochran para o conjunto de backbones), que são os corretos para acerto/erro pareado.
A **verificação de normalidade (Shapiro-Wilk)** é aplicada onde faz sentido: nas amostras **contínuas** de EX entre as repetições da robustez. Como elas se mostraram **normais** (Shapiro p>0.05), a comparação de variância (Levene) e de média (além do Kruskal não-paramétrico) é apropriada.

---

## 6. Artefatos e reprodutibilidade

Código, scripts, ambiente (`setup_env.sh` + vLLM pinado), subset determinístico (seed) e avaliador oficial estão no repositório. Pipeline completo:
`setup_env.sh` → `download_spider.sh` → `download_models.sh` → `build_subset.py` → `run_backbones.sh` / `run_ablation.sh` / `run_robustness.sh` → `collect_results.py` → `analyze.py` → `make_figures.py`.

---

## 7. Ameaças à validade (resumo)

- **Amostral:** subset de 200 (estratos pequenos: extra n=25) → maior variância; mitigado com IC e testes pareados.
- **Proporção do subset ≠ dev completo** → comparação com o paper feita **por dificuldade**, não pelo agregado.
- **Avaliação por EX** pode ter falsos positivos (queries diferentes, mesmo resultado no banco específico); EM reportado como complemento.
- **Generalização:** um único benchmark (Spider) e idioma (inglês), como no paper original.
