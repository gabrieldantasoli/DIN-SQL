# Resultados — Reprodução do DIN-SQL com LLMs locais

**Projeto FPCC2 · Gabriel Dantas de Oliveira**
Reprodução de *DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction* (Pourreza & Rafiei, NeurIPS 2023), substituindo o GPT-4 por LLMs locais (vLLM, custo $0) e acrescentando rigor estatístico.

---

## 1. Configuração experimental

| Item | Valor |
|---|---|
| Hardware | NVIDIA RTX 4090 (24 GB) |
| Serving | vLLM (API OpenAI-compatible), FP16, greedy (temp=0) salvo indicado |
| Benchmark | Spider — **subset estratificado de 200 queries** do dev |
| Estratos | easy 70 · medium 70 · hard 35 · extra 25 (`seed=42`, hash `153d3fccf9a49ce6`) |
| Métricas | Execution Accuracy (EX) e Exact-Set-Match (EM), avaliador oficial `test-suite-sql-eval` |
| Pipeline | DIN-SQL adaptado (4 módulos: schema linking → classificação → geração → self-correction) |

> Validação da infraestrutura: avaliação *gold-vs-gold* deu EX=EM=1.000; o run greedy reproduziu exatamente o baseline (EX=0.745), confirmando reprodutibilidade.

---

## 2. Baseline + comparação de backbones (5 modelos, 5 provedores)

Execution Accuracy (EX) e Exact-Set-Match (EM) no subset de 200, por dificuldade:

| Modelo (provedor) | EX **all** | EM **all** | easy | medium | hard | extra |
|---|---|---|---|---|---|---|
| **Qwen2.5-Coder-7B** (Alibaba) | **0.745** | 0.620 | 0.814 | 0.729 | 0.686 | 0.680 |
| **DeepSeek-Coder-6.7B** (DeepSeek) | 0.735 | 0.455 | 0.814 | 0.814 | 0.600 | 0.480 |
| **Yi-Coder-9B** (01.AI) | 0.725 | 0.540 | 0.786 | 0.771 | 0.657 | 0.520 |
| **Granite-8B-code-128k** (IBM) | 0.670 | 0.460 | 0.800 | 0.671 | 0.600 | 0.400 |
| **Phi-3.5-mini-3.8B** (Microsoft) | 0.630 | 0.355 | 0.757 | 0.671 | 0.400 | 0.480 |

**Comparação com o paper** (DIN-SQL + GPT-4, Spider dev — Tabelas 4a/4b):
EX all = 74.2 · EM = 60.1 · por dificuldade: easy 91.1 / medium 79.8 / hard 64.9 / extra 43.4.

**Observações:**
- **Qwen2.5-Coder-7B (74.5% EX) praticamente empata com o GPT-4 do paper (74.2%)** — a custo $0. Fica abaixo no easy/medium, mas **iguala/supera no hard (68.6 vs 64.9) e no extra (68.0 vs 43.4)**.
- Os três coders 7–9B (Qwen, DeepSeek, Yi) ficam **colados** (72.5–74.5); **Granite e Phi** destacam-se abaixo.
- **Phi-3.5-mini (3.8B)** é o pior e **colapsa no hard (0.40)** → evidência de que o prompting decomposto **depende da capacidade do modelo** (alinha com a tese do paper sobre habilidade emergente).
- **Gap EX–EM grande** em todos (esperado e previsto pelos autores — SQL semanticamente correto, mas sintaticamente diferente da gold): Qwen 0.125 · Yi 0.185 · Granite 0.210 · **Phi 0.275 · DeepSeek 0.280**.

**Significância (H3):** Friedman **p=0.0062 → há diferença global** entre os 5 backbones. No post-hoc (McNemar + Bonferroni-Holm), **apenas Qwen vs Phi-3.5 é significativo** (p_adj=0.013, h=+0.25). Qwen/DeepSeek/Yi **não diferem** (p≈0.67–0.89) e Qwen vs Granite fica no limite (p=0.050, perde após Holm). **Conclusão:** os coders 7–9B **empatam estatisticamente**; a diferença global é puxada pelo **Phi-3.5 (3.8B) ficar atrás**.

---

## 3. Ablation study (Qwen2.5-Coder-7B) — Tabela 5 do paper

EX por dificuldade, ligando/desligando cada módulo:

| Configuração | EX **all** | EM **all** | easy | medium | hard | extra | Δ EX vs full |
|---|---|---|---|---|---|---|---|
| **full** (referência) | **0.745** | 0.620 | 0.814 | 0.729 | 0.686 | 0.680 | — |
| sem self-correction | 0.665 | 0.570 | 0.771 | 0.714 | 0.543 | 0.400 | **−0.080** |
| sem schema-linking | 0.765 | 0.635 | 0.829 | 0.800 | 0.686 | 0.600 | +0.020 |
| sem classif. → few-shot simples | **0.790** | 0.615 | 0.871 | 0.814 | 0.743 | 0.560 | +0.045 |
| sem classif. → CoT decomposto | 0.675 | 0.495 | 0.829 | 0.714 | 0.457 | 0.440 | −0.070 |

**Leitura por módulo:**
1. **Self-correction é o módulo mais valioso** — removê-lo derruba 8 pts (colapso no hard 0.543 e extra 0.400). **Coincide com o paper.**
2. **Schema-linking não ajuda o Qwen** (sem ele, +0.020) — um coder moderno já faz schema linking implicitamente; o passo explícito adiciona ruído. **Contraria o paper.**
3. **Forçar few-shot simples supera o full no geral** (0.790 vs 0.745), melhor em easy/medium/hard; **só perde no extra** (0.560 vs 0.680).
4. **Forçar CoT em tudo piora** (−0.070), com colapso no hard (0.457).

**Trade-off central do paper confirmado:** few-shot simples vence em easy/medium/hard; a decomposição completa só compensa no **extra** (0.680) — ou seja, a maquinaria do DIN-SQL **paga apenas nas queries extra-hard** para o Qwen.

**Significância (McNemar pareado, full vs variante) — H2:**
| Variante | Δ EX | p (McNemar) | Cohen's h | veredito |
|---|---|---|---|---|
| sem self-correction | −0.080 | **<0.001** ✓ | −0.18 | contribui (significativo) |
| CoT forçado | −0.070 | **0.026** ✓ | −0.16 | prejudica (significativo) |
| few-shot forçado | +0.045 | **0.049** ✓ (limítrofe) | +0.11 | simplificar ajuda |
| sem schema-linking | +0.020 | 0.556 ✗ | +0.05 | **neutro** |

**H2 refutada parcialmente:** só o **self-correction** contribui de fato (p<0.001); **schema-linking é neutro** (p=0.56) e a classificação→prompt-complexo chega a **atrapalhar** (forçar few-shot simples melhora, p=0.049). Achado central: **parte do scaffolding do DIN-SQL é redundante para coders 7B modernos.**

---

## 4. Robustez à temperatura (Extensão B, Qwen2.5-Coder-7B)

EX médio entre repetições (N=5 para temp>0; temp=0 é determinístico):

| Temperatura | EX médio | desvio (±, ddof=1) | reps | amplitude (min–max) |
|---|---|---|---|---|
| **0.0** (greedy) | 0.745 | — | 1 | — |
| **0.4** | **0.758** | ±0.020 | 5 | 0.725–0.775 |
| **0.8** | 0.719 | ±0.049 | 5 | 0.645–0.765 |

**Leitura:**
- **A variância cresce com a temperatura** (±0.020 → ±0.049); em T=0.8 a amplitude chega a **12 pts** (uma corrida caiu a 0.645).
- **Greedy é estável e competitivo**; T=0.4 fica marginalmente acima (dentro do ruído); **T=0.8 fica abaixo e instável**.
- **Conclusão:** temperatura alta não traz ganho e introduz risco → **greedy (temp=0) é a escolha segura e reproduzível**, como no paper.

**Verificação estatística (normalidade e variabilidade):**
- **Shapiro-Wilk:** EX entre repetições é **normal** em ambas (T=0.4 p=0.236; T=0.8 p=0.435).
- **Levene:** variâncias **não diferem significativamente** (p=0.273) — embora o desvio de T=0.8 seja 2,5× o de T=0.4, com N=5 não há poder para confirmar.
- **Kruskal-Wallis / Mann-Whitney:** **sem efeito significativo** da temperatura na média do EX (p=0.116 / 0.142).
- **Veredito de H4:** confirma-se a **ausência de ganho** com temperatura; o aumento de variabilidade é **numérico** (não significativo com N=5).

---

## 5. Achado: incompatibilidade do SQLCoder-7B-2

O `defog/sqlcoder-7b-2` (modelo SQL-especializado, estilo *completion*, **sem chat template**) **não roda no pipeline chat do DIN-SQL** — trava na 1ª chamada. Via endpoint *completion* ele executa, mas os prompts decompostos do DIN-SQL não são o formato que ele espera. **Reforça a tese do paper:** o prompting decomposto exige **instruction-following** geral, não disponível num modelo de completion especializado. Documentado como limitação; substituído por backbones instruct de 5 provedores.

---

## 6. Principais achados (síntese)

1. **Reprodução bem-sucedida a custo $0:** Qwen2.5-Coder-7B local **empata com o GPT-4** do paper em EX (74.5 vs 74.2), validando o método com LLM aberto.
2. **Gap justificado (critério nº 5):** abaixo no easy/medium, competitivo/superior no hard/extra; EM bem menor que o paper (esperado para in-context).
3. **A complexidade do DIN-SQL é parcialmente redundante em coders modernos:** **self-correction** continua valiosa, mas **schema-linking e classificação** não transferem ganho ao Qwen (scaffolding pensado para a era CodeX/GPT-4).
4. **Decomposição só compensa no extra-hard** — confirma o trade-off simples-vs-CoT do paper.
5. **Greedy é robusto;** temperatura alta aumenta variância sem ganho.
6. **Capacidade do modelo importa:** Phi-3.5-mini (3.8B) colapsa no hard → o método depende de instruction-following forte.

---

## 7. Ressalvas estatísticas

- **n=200 → erro-padrão ~3 pts.** Diferenças pequenas estão dentro do ruído:
  - **Prováveis reais:** ablation `sem self-correction` (−0.080) e `CoT forçado` (−0.070).
  - **Dentro do ruído (não conclusivos sem teste):** `sem schema-linking` (+0.020), `few-shot` (+0.045), e as diferenças entre Qwen/DeepSeek/Yi (≤2 pts).
- **Estratos pequenos** (extra n=25, hard n=35) → alta variância; números do extra são os mais ruidosos.
- **O subset (35% easy) tem proporção diferente do dev completo (24% easy)** → comparar com o paper **por dificuldade**, não pelo "all".

**Análise de significância: concluída** (`src/analyze.py` sobre a matriz por-query) — Bootstrap IC95%, McNemar pareado, Friedman + Bonferroni-Holm, Cohen's h, Shapiro-Wilk (normalidade), Levene e Kruskal-Wallis. Resultados nas seções 2–4 e em `results/analysis/`. Critérios nº 3 e 4 atendidos.

**Resumo das hipóteses:**
- **H1** (7B local ≈ GPT-4): **sustentada** — Qwen 0.745 vs paper 0.742 (IC95% [0.680, 0.805] contém 0.742).
- **H2** (todo módulo contribui): **parcial** — só self-correction é significativo; schema-linking neutro; classificação→complexo chega a atrapalhar.
- **H3** (backbones diferem): **sustentada globalmente** (Friedman p=0.006), mas só Phi-3.5 difere no post-hoc; os coders 7–9B empatam.
- **H4** (temp ↑ variância, sem ganho na média): **sustentada** quanto à ausência de ganho (Kruskal p=0.116); aumento de variância é numérico, não significativo (Levene p=0.273, N=5).

---

## 8. Figuras (em `results/figures/`)

| Arquivo | Conteúdo |
|---|---|
| `fig1_backbones_ex.png` | EX(all) dos 5 backbones + IC95% (Wilson) + linha do GPT-4 do paper |
| `fig2_backbones_dificuldade.png` | EX por dificuldade (1 linha por backbone) vs. paper |
| `fig3_backbones_ex_em.png` | EX vs EM por backbone (gap do in-context) |
| `fig4_ablation_ex.png` | EX(all): full vs 4 variantes (com Δ) |
| `fig5_ablation_dificuldade.png` | EX por dificuldade (full vs variantes) |
| `fig6_robustez_temperatura.png` | EX por temperatura (média±desvio + repetições) |
| `fig7_qwen_vs_paper.png` | Qwen2.5-Coder-7B local vs. GPT-4 do paper, por dificuldade |

Geradas por `python src/make_figures.py` (a partir dos `eval_*.txt`).

## 9. Status do projeto

| Etapa | Status |
|---|---|
| Setup, código adaptado, subset | ✅ |
| Baseline + 5 backbones (Ext. A) | ✅ |
| Ablation (5 configs) | ✅ |
| Robustez à temperatura (Ext. B) | ✅ |
| Análise estatística (McNemar/Bootstrap/Friedman/Cohen's h) | ⬜ rodar `analyze.py` |
| Relatório final + repositório público | ⬜ |

*Métricas: EX = Execution Accuracy · EM = Exact-Set-Match. Subset de 200 queries do Spider dev, seed=42.*
