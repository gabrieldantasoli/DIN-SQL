# Plano de escrita do artigo — Reprodução do DIN-SQL com LLMs locais

Documento de **estrutura + plano de escrita** (não é o artigo). Para cada seção: objetivo, o que escrever, artefatos a citar e mensagem-chave. Formato-alvo: artigo curto SBC/IEEE (~8–12 páginas). Fontes de conteúdo já prontas: `METODOLOGIA.md`, `RESULTADOS.md`, `results/figures/*`, `results/analysis/*`.

---

## Título (proposta)
> *Reprodução de baixo custo do DIN-SQL: quão necessário é o prompting decomposto em code-LLMs abertos modernos?*

Subtítulo possível: *um estudo experimental com 5 backbones, ablation e análise de robustez no Spider.*

---

## 0. Resumo / Abstract  *(~150–200 palavras)*
- **Escrever por último.** 1 frase por: problema → o que foi feito → como (subset 200, 5 modelos, ablation, robustez) → principal resultado (Qwen 7B ≈ GPT-4; self-correction é o único módulo que ajuda significativamente) → implicação.
- Incluir 3–5 palavras-chave: text-to-SQL, in-context learning, reprodutibilidade, análise experimental, LLM.

---

## 1. Introdução  *(~1 página)*
- **Objetivo:** contextualizar text-to-SQL e o gap prompting-vs-finetuning que o DIN-SQL atacou.
- **Escrever:** (i) problema (NL→SQL, importância); (ii) o que o DIN-SQL propôs e seu impacto; (iii) **a lacuna**: avaliação original sem rigor estatístico e dependente do GPT-4 (caro/fechado); (iv) **nossa proposta**: reproduzir localmente ($0) e adicionar tratamento estatístico; (v) **contribuições** em lista.
- **Contribuições (bullets):** reprodução $0 com 5 backbones abertos; ablation + robustez com testes de significância; achado de que parte do scaffolding do DIN-SQL é redundante em coders modernos; artefatos públicos.
- **Mensagem-chave:** "reproduzimos e fomos além — com estatística."

## 2. Trabalho de referência e relacionados  *(~0,75 página)*
- **Objetivo:** resumir o DIN-SQL e situar.
- **Escrever:** os 4 módulos (schema linking, classificação/decomposição, geração, self-correction); métricas EX/EM; resultados originais (85.3 test / 74.2 dev EX com GPT-4). Breve menção a trabalhos sucessores (DAIL-SQL, MAC-SQL) e a coders abertos (Qwen-Coder, DeepSeek-Coder).
- **Citar:** Pourreza & Rafiei (2023); Spider (Yu et al. 2018); avaliador test-suite (Zhong et al. 2020).

## 3. Metodologia experimental  *(~1,5–2 páginas — núcleo do rigor)*
> Fonte direta: **METODOLOGIA.md** (já pronto).
### 3.1 Hipóteses
- Listar **H1–H4** com o teste associado (tabela do METODOLOGIA.md).
### 3.2 Variáveis
- Independentes (backbone 5, ablation 5, temperatura 3); dependentes (EX, EM); controladas.
### 3.3 Desenho experimental
- Subset estratificado (200, seed=42, hash); medidas **pareadas**; repetições (N=1 determinístico / N=5 estocástico) com justificativa; randomização.
### 3.4 Instrumentação e ambiente
- vLLM, FP16, RTX 4090; avaliador oficial; pipeline de scripts (citar nomes).
### 3.5 Tratamento estatístico
- Bootstrap IC95%; McNemar; Friedman+Holm; Cohen's h; Shapiro-Wilk; Levene; Kruskal. **Justificar não-paramétrico** (EX binário → Bernoulli).
- **Mensagem-chave:** "desenho controlado, pareado, reprodutível e com testes adequados ao tipo de dado."

## 4. Resultados  *(~2–3 páginas — tabelas + figuras)*
> Fonte direta: **RESULTADOS.md** + figuras.
### 4.1 Reprodução e backbones (H1, H3)
- Tabela EX/EM por dificuldade (5 modelos). Citar **fig1** (EX+IC), **fig2** (por dificuldade), **fig3** (EX vs EM), **fig7** (Qwen vs GPT-4).
- Reportar Friedman (p=0.006) + post-hoc (só Qwen vs Phi significativo).
### 4.2 Ablation (H2)
- Tabela full vs 4 variantes + Δ + McNemar p + Cohen's h. Citar **fig4**, **fig5**.
### 4.3 Robustez à temperatura (H4)
- Tabela média±desvio; Shapiro/Levene/Kruskal. Citar **fig6**.
### 4.4 Incompatibilidade do SQLCoder
- Parágrafo curto: modelo completion sem chat template → não roda no pipeline.
- **Regra:** descrever resultados de forma **neutra** aqui; interpretação fica na Discussão.

## 5. Discussão  *(~1–1,5 página)*
- **Objetivo:** interpretar e responder as hipóteses.
- **Escrever:** veredito de H1–H4 (sustentada/parcial/refutada) com evidência. Destacar o **achado central**: em coders 7B modernos, **self-correction é o que importa**; schema-linking neutro; classificação→prompt-complexo pode atrapalhar → *scaffolding redundante*. Conectar com a tese do paper (habilidade emergente) via o caso SQLCoder. Discutir gap EX–EM. Comparar com o paper **por dificuldade**.
- **Mensagem-chave:** "reproduzimos o desempenho, mas a anatomia da contribuição mudou com modelos melhores."

## 6. Ameaças à validade  *(~0,5 página)*
> Fonte: seção 7 do RESULTADOS.md / METODOLOGIA.md.
- **Interna:** EX com possíveis falsos positivos; parsing chat→SQL (mitigado por `clean_sql`).
- **Externa:** 1 benchmark (Spider), inglês, ablation em 1 modelo.
- **De conclusão:** estratos pequenos (extra n=25); subset ≠ proporção do dev → comparar por dificuldade; few-shot ablation p=0.049 limítrofe.
- **Construto:** subset de 200 vs dev completo.

## 7. Conclusão  *(~0,5 página)*
- Recapitular: reprodução $0 bem-sucedida; estatística adicionada; achado sobre redundância do scaffolding; robustez do greedy.
- **Trabalhos futuros:** eixo #few-shot; ablation multi-modelo; benchmark BIRD; outros idiomas.

## 8. Reprodutibilidade / Disponibilidade  *(~0,25 página)*
- Link do repositório (após `git push`); listar artefatos (código, scripts, subset com seed, ambiente, dados de resultado, figuras). Comando único de reprodução (pipeline).

## Referências
- DIN-SQL (Pourreza & Rafiei 2023); Spider (Yu et al. 2018); test-suite eval (Zhong et al. 2020); NatSQL; modelos: Qwen2.5-Coder, DeepSeek-Coder, Yi-Coder, Granite-Code, Phi-3.5; vLLM.

---

## Mapa: onde está cada conteúdo (para acelerar a escrita)

| Seção do artigo | Material pronto |
|---|---|
| 3. Metodologia | `METODOLOGIA.md` (copiar/adaptar quase direto) |
| 4.1 Backbones | `RESULTADOS.md §2`, fig1/2/3/7, `results/analysis/ex_ci.csv`, `backbones_pairwise.csv` |
| 4.2 Ablation | `RESULTADOS.md §3`, fig4/5, `results/analysis/ablation.csv` |
| 4.3 Robustez | `RESULTADOS.md §4`, fig6, `results/analysis/robustness.csv` |
| 5. Discussão | `RESULTADOS.md §6` (achados) + veredito H1–H4 |
| 6. Ameaças | `RESULTADOS.md §7` |

---

## Ordem de escrita sugerida (não a ordem das seções)
1. **Metodologia (3)** — já está pronta, é só formatar → ganha momentum.
2. **Resultados (4)** — colar tabelas + inserir figuras + p-values.
3. **Discussão (5)** + **Ameaças (6)** — interpretar.
4. **Introdução (1)** + **Trabalho de referência (2)** — agora que os resultados estão claros.
5. **Conclusão (7)** + **Reprodutibilidade (8)**.
6. **Resumo (0)** — por último.

## Checklist de submissão
- [ ] Todas as figuras citadas no texto (fig1–fig7) e legendadas.
- [ ] Todas as tabelas com n, métrica e teste indicados.
- [ ] Cada hipótese (H1–H4) explicitamente respondida na Discussão.
- [ ] p-values, IC e tamanho de efeito reportados (não só "significativo").
- [ ] Link do repositório público ativo (`git push` feito).
- [ ] Ameaças à validade declaradas (incl. eixo #few-shot não executado).
- [ ] Formato/template da disciplina (SBC/IEEE) aplicado.
