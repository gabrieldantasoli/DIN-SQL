# Reprodução de baixo custo do DIN-SQL: quão necessário é o prompting decomposto em code-LLMs abertos modernos?

**Gabriel Dantas de Oliveira**

COPIN — Coordenação de Pós-Graduação em Ciência da Computação
Universidade Federal de Campina Grande (UFCG)

---

## Resumo

O DIN-SQL mostrou que decompor a tarefa de *text-to-SQL* em sub-passos encadeados permite a um LLM de propósito geral, sem ajuste de pesos, alcançar o estado da arte no *benchmark* Spider. Sua avaliação original, contudo, depende do GPT-4 — modelo fechado e pago — e reporta apenas pontos de acurácia, sem intervalos de confiança, testes de significância ou tamanhos de efeito. Neste trabalho reproduzimos o DIN-SQL substituindo o GPT-4 por cinco *code-LLMs* abertos servidos localmente em uma única GPU de consumo, a custo financeiro nulo, e submetemos cada afirmação a tratamento estatístico adequado. Sobre um subconjunto estratificado de 200 consultas do Spider dev, o Qwen2.5-Coder-7B atingiu *Execution Accuracy* de 0,745, praticamente idêntica ao 0,742 do GPT-4, com intervalo de confiança que contém o valor de referência. Um estudo de ablação revela que apenas a autocorreção contribui de forma estatisticamente robusta, enquanto o *linking* explícito de esquema é neutro e a classificação que conduz a *prompts* complexos pode até prejudicar o desempenho. Concluímos que parte do *scaffolding* concebido para a era do GPT-4 tornou-se redundante em *coders* abertos modernos.

**Palavras-chave:** *text-to-SQL*, aprendizado em contexto, reprodutibilidade, análise experimental, modelos de linguagem abertos.

## Abstract

DIN-SQL showed that decomposing the text-to-SQL task into chained sub-steps lets a general-purpose LLM, without any weight tuning, reach state-of-the-art performance on the Spider benchmark. Its original evaluation, however, relies on GPT-4 — a closed, paid model — and reports only accuracy points, with no confidence intervals, significance tests, or effect sizes. In this work we reproduce DIN-SQL by replacing GPT-4 with five open code-LLMs served locally on a single consumer GPU, at zero financial cost, and we subject every claim to proper statistical treatment. On a stratified subset of 200 Spider dev queries, Qwen2.5-Coder-7B reaches an Execution Accuracy of 0.745, virtually identical to GPT-4's 0.742, with a confidence interval that contains the reference value. An ablation study reveals that only self-correction contributes robustly, while explicit schema linking is neutral and the classification step leading to complex prompts can even hurt performance. We conclude that part of the scaffolding designed for the GPT-4 era has become redundant in modern open code-LLMs.

---

# 1. Introdução

Traduzir automaticamente linguagem natural para SQL (*text-to-SQL*) é um problema antigo na fronteira entre processamento de linguagem natural e bancos de dados: dada uma pergunta em linguagem natural e o esquema de um banco, queremos gerar a consulta SQL que a responde corretamente. O apelo prático é evidente, pois permitiria que usuários sem domínio de SQL interrogassem bases relacionais diretamente, democratizando o acesso à informação estruturada. A dificuldade, contudo, está nos detalhes. O sistema precisa ancorar as entidades mencionadas na pergunta às tabelas e colunas corretas, raciocinar sobre junções, aninhamentos e agregações e, ao final, produzir uma consulta sintaticamente válida e fiel à intenção do usuário, tudo isso sobre esquemas que jamais viu durante o treinamento.

Por muito tempo, o estado da arte nesse problema foi dominado por modelos especializados, ajustados (*fine-tuned*) sobre os próprios dados do *benchmark*. O surgimento dos grandes modelos de linguagem (LLMs) deslocou parte dessa atenção para abordagens baseadas em *prompting*, nas quais o modelo não é retreinado, mas guiado por instruções e exemplos em contexto (*in-context learning*). É nesse cenário que se insere o DIN-SQL (Pourreza & Rafiei, 2023), trabalho que atacou de frente o *gap* entre *prompting* e *fine-tuning* ao mostrar que um LLM de propósito geral, sem qualquer ajuste de pesos, poderia alcançar e até superar modelos especializados. A receita do DIN-SQL foi decompor a tarefa: em vez de pedir a consulta de uma só vez, o método a fragmenta em sub-passos encadeados — *linking* de esquema, classificação e decomposição, geração e autocorreção —, apostando na hipótese de que LLMs raciocinam melhor sobre problemas complexos quando estes são quebrados em partes menores. Aplicado ao *benchmark* Spider com o GPT-4, o DIN-SQL atingiu desempenho de ponta e validou o *prompting* decomposto como alternativa viável ao *fine-tuning*.

Apesar do impacto da proposta, enxergamos duas lacunas relevantes na avaliação original. A primeira é metodológica: os resultados são reportados como pontos de acurácia, sem intervalos de confiança, testes de significância ou tamanhos de efeito que permitam distinguir um ganho real do mero ruído amostral — e tampouco que digam o quanto cada um dos quatro módulos efetivamente contribui para o resultado final. A segunda é de acessibilidade e custo: todo o *pipeline* depende do GPT-4, um modelo fechado, pago e acessível apenas via API, o que compromete a reprodutibilidade e levanta a dúvida de saber se a contribuição de cada componente do *scaffolding* se mantém quando trocamos o motor por trás dele. Desde a publicação do DIN-SQL, surgiram modelos abertos e relativamente pequenos — como o Qwen2.5-Coder e o DeepSeek-Coder — que rivalizam com modelos fechados em tarefas de programação e podem ser executados localmente a custo essencialmente nulo. Isso abre uma pergunta natural, ainda não respondida com rigor: quão necessário é o *prompting* decomposto do DIN-SQL quando o aplicamos a esses *coders* abertos modernos?

Neste trabalho, reproduzimos o DIN-SQL substituindo o GPT-4 por LLMs locais executados em uma única GPU de consumo, a custo financeiro zero, e submetemos cada afirmação a tratamento estatístico adequado. Avaliamos cinco *backbones* abertos de cinco provedores distintos sob o mesmo *pipeline*, conduzimos um estudo de ablação para isolar a contribuição de cada módulo e analisamos a robustez do método à temperatura de decodificação. Constatamos que um *coder* de 7B reproduz o desempenho do GPT-4 reportado no artigo original, mas que a anatomia da contribuição muda: parte do *scaffolding* que fazia sentido na era do GPT-4 mostra-se redundante diante de *coders* modernos.

## Contribuições

Resumimos nossas contribuições principais a seguir:

- **Reprodução de baixo custo (US$ 0).** Reproduzimos o DIN-SQL inteiramente com LLMs abertos servidos localmente (vLLM, FP16, RTX 4090), substituindo o GPT-4 por cinco *backbones* de provedores distintos — Alibaba, DeepSeek, 01.AI, IBM e Microsoft — sob um *pipeline* idêntico e controlado.
- **Rigor estatístico ausente na avaliação original.** Acrescentamos intervalos de confiança por *bootstrap*, testes de hipótese apropriados ao tipo de dado (McNemar pareado, Friedman com correção de Bonferroni-Holm, Shapiro-Wilk, Levene e Kruskal-Wallis) e tamanhos de efeito (*Cohen's h*), o que nos permite separar ganhos reais de variação amostral.
- **Evidência de que parte do *scaffolding* do DIN-SQL é redundante em *coders* modernos.** Por meio de ablação com testes de significância, mostramos que apenas a autocorreção contribui de forma estatisticamente robusta, enquanto o *linking* explícito de esquema é neutro e a etapa de classificação que conduz a *prompts* complexos pode até prejudicar o desempenho.
- **Análise de robustez e de capacidade.** Caracterizamos o comportamento do método sob diferentes temperaturas de decodificação e documentamos como modelos menores degradam nas consultas mais difíceis; somamos a isso um achado de incompatibilidade que reforça a tese de que o *prompting* decomposto exige *instruction-following* emergente.
- **Artefatos públicos.** Disponibilizamos código, *scripts*, *subset* determinístico (com semente e *hash*), ambiente fixado e resultados, viabilizando a reprodução completa do estudo.

# 2. Trabalho de referência e trabalhos relacionados

## 2.1 O DIN-SQL

O DIN-SQL (Pourreza & Rafiei, 2023) resolve *text-to-SQL* por meio de aprendizado em contexto decomposto, sem ajustar os pesos do modelo. Sua tese central é que gerar SQL complexo diretamente a partir da pergunta sobrecarrega o modelo, e que decompor a tarefa em sub-problemas mais simples e encadeados melhora substancialmente o desempenho. O *pipeline* organiza-se em quatro módulos sucessivos:

1. **Linking de esquema (*schema linking*).** A partir da pergunta, identifica quais tabelas e colunas do esquema são relevantes, além de literais e valores mencionados. A intenção é reduzir o espaço de busca e ancorar a geração nos elementos corretos do banco.
2. **Classificação e decomposição.** Classifica a consulta por dificuldade — por exemplo, simples, junção não aninhada ou aninhada — e, conforme a classe, escolhe a estratégia de *prompting*: exemplos diretos para consultas simples ou uma decomposição em sub-questões (cadeia de raciocínio) para as mais complexas.
3. **Geração da SQL.** Produz a consulta propriamente dita, combinando o *prompt* apropriado à classe identificada com as informações do *linking* de esquema.
4. **Autocorreção (*self-correction*).** Submete a consulta gerada a um passo adicional em que o modelo revisa e corrige erros comuns — problemas de sintaxe ou de uso de colunas, por exemplo — antes de produzir a resposta final.

A avaliação foi conduzida sobre o Spider (Yu et al., 2018), *benchmark* de *text-to-SQL* *cross-domain* amplamente adotado, cujos esquemas de teste diferem dos de treino e exigem, portanto, generalização para bancos não vistos. São reportadas duas métricas. A **Execution Accuracy (EX)** executa tanto a consulta predita quanto a de referência no banco e compara os resultados retornados, capturando a corretude semântica e tolerando formulações sintaticamente distintas que produzem a mesma resposta. Já a **Exact-Set-Match (EM)** compara as cláusulas da consulta como conjuntos, exigindo correspondência estrutural com a consulta de referência e sendo, por isso, mais sensível a diferenças de forma. Para tornar a avaliação por execução mais confiável, adota-se o avaliador oficial de *test-suite* (Zhong et al., 2020), que reduz falsos positivos ao testar as consultas contra múltiplas instâncias de banco.

Com o GPT-4, o DIN-SQL alcançou resultados de ponta à época: cerca de **85,3% de EX no conjunto de teste** e **74,2% de EX no conjunto de desenvolvimento** do Spider, com EM de 60,1% no *dev* e desempenho por dificuldade de 91,1% (*easy*), 79,8% (*medium*), 64,9% (*hard*) e 43,4% (*extra*). São esses números que servem de referência direta para a nossa reprodução: é precisamente o desempenho no conjunto de desenvolvimento, decomposto por dificuldade, que tomamos como alvo de comparação ao trocar o GPT-4 por modelos abertos.

## 2.2 Trabalhos relacionados

A linha de *prompting* para *text-to-SQL* inaugurada pelo DIN-SQL teve continuidade em trabalhos que exploram seleção de exemplos e organização multiagente do *pipeline*, como o DAIL-SQL e o MAC-SQL, preservando a ideia de estruturar a geração em etapas. Em paralelo, a evolução dos modelos de código abertos tornou viável reexaminar essas receitas fora do regime do GPT-4. Modelos como o Qwen2.5-Coder e o DeepSeek-Coder, na faixa de poucos bilhões de parâmetros, atingem forte desempenho em programação e podem ser servidos localmente, o que os torna candidatos naturais a substituir o *backbone* fechado original. É justamente essa combinação — o método decomposto do DIN-SQL aplicado a *coders* abertos modernos e avaliado com o rigor estatístico ausente na proposta original — que investigamos nas seções seguintes.

# 3. Metodologia experimental

Esta seção apresenta o desenho que conduziu à reprodução do DIN-SQL com LLMs locais. Uma das nossas contribuições é justamente devolver rigor estatístico a uma avaliação que, no trabalho original, foi reportada de forma essencialmente descritiva; por isso organizamos a metodologia em torno de hipóteses testáveis, fatores e níveis bem definidos, medidas pareadas e testes escolhidos conforme o tipo de dado coletado. Comparamos três famílias de cenários sob o mesmo pipeline DIN-SQL: (A) cinco *backbones* abertos servidos localmente; (B) a ablação dos módulos do método; e (C) a robustez à temperatura de decodificação.

## 3.1 Hipóteses

Formulamos quatro hipóteses e associamos cada uma a um teste específico, de modo que aceitá-las ou rejeitá-las não dependesse da mera inspeção visual das médias.

- **H1 — Equivalência ao GPT-4.** Um *code-LLM* aberto de aproximadamente 7B de parâmetros, operando sob o pipeline DIN-SQL, alcança uma *Execution Accuracy* (EX) comparável à reportada para o GPT-4 no artigo original. Avaliamos a hipótese pelo intervalo de confiança de 95% (bootstrap) do EX — verificando se ele contém o valor de referência — e por uma comparação desagregada por dificuldade.
- **H2 — Contribuição de cada módulo.** Cada módulo do DIN-SQL contribui para o EX, de modo que removê-lo deveria reduzi-lo. Testamos cada par *full*-versus-ablado com o teste de McNemar pareado, acompanhado do tamanho de efeito *h* de Cohen.
- **H3 — Diferença entre backbones.** Há diferença significativa de EX entre os cinco modelos. Aplicamos o teste de Friedman para a diferença global e, em caso de rejeição, um post-hoc de McNemar com correção de Bonferroni-Holm para as comparações par a par.
- **H4 — Efeito da temperatura.** Temperaturas mais altas aumentam a variabilidade do EX sem produzir ganho na média. Verificamos a normalidade das amostras com Shapiro-Wilk e, em seguida, comparamos a variância com Levene e a média com Kruskal-Wallis (complementado por Mann-Whitney).

## 3.2 Variáveis

Tratamos o estudo como três experimentos fatoriais que compartilham as mesmas variáveis dependentes e o mesmo conjunto de variáveis controladas.

**Variáveis independentes (fatores e níveis).** O primeiro fator é o *backbone*, com cinco níveis correspondentes a cinco modelos *instruct* de cinco provedores distintos: Qwen2.5-Coder-7B (Alibaba), DeepSeek-Coder-6.7B (DeepSeek), Yi-Coder-9B (01.AI), Granite-8B-code-128k (IBM) e Phi-3.5-mini-3.8B (Microsoft). O segundo fator é a configuração de módulos, manipulada na ablação sobre o Qwen, também com cinco níveis: a configuração *full* e quatro variantes que desligam ou substituem um componente — sem self-correction, sem schema-linking, sem a etapa de classificação forçando o caminho de *few-shot* simples e sem a classificação forçando o caminho de *Chain-of-Thought* decomposto. O terceiro fator é a temperatura de decodificação, com três níveis (0,0, 0,4 e 0,8).

**Variáveis dependentes.** Adotamos a *Execution Accuracy* (EX) como métrica primária e o *Exact-Set-Match* (EM) como métrica secundária. O EX executa a consulta predita no banco e compara o resultado com o da consulta de referência; o EM compara as cláusulas como conjuntos. Usá-las em conjunto permite separar acertos semânticos de coincidências sintáticas — uma distinção que se mostra relevante quando reportamos os resultados.

**Variáveis controladas.** Mantivemos constantes, em todos os cenários, o subconjunto de avaliação (as mesmas 200 consultas, `seed=42`), os prompts do DIN-SQL, os parâmetros de decodificação (`max_tokens` e *stop tokens*), o avaliador oficial (test-suite-sql-eval), o hardware (RTX 4090) e a infraestrutura de serving (vLLM em precisão FP16). Esse controle assegura que qualquer variação observada no EX possa ser atribuída ao fator efetivamente manipulado.

## 3.3 Desenho experimental

**Amostragem.** Em vez de avaliar todo o conjunto de desenvolvimento do Spider (1.034 consultas) — custoso quando multiplicado por cinco modelos e várias configurações —, construímos um subconjunto de 200 consultas por amostragem aleatória estratificada por dificuldade, com `random_state=42`. Os estratos resultantes são *easy* 70, *medium* 70, *hard* 35 e *extra* 25, e registramos um *hash* dos índices (`153d3fccf9a49ce6`) para garantir que qualquer reexecução opere exatamente sobre as mesmas instâncias. Vale notar que, por privilegiarmos um número razoável de exemplos difíceis, a proporção dos estratos do subset difere da do dev completo. É por isso que, ao confrontar nossos números com os do artigo original, fazemos a comparação por dificuldade, e não pelo agregado.

**Medidas pareadas.** Como todas as configurações são avaliadas sobre exatamente as mesmas 200 consultas, dispomos de medidas pareadas no nível da instância: para cada consulta, sabemos se cada cenário acertou ou errou. Esse pareamento habilita o uso de testes como McNemar e Friedman, mais potentes do que suas contrapartes para amostras independentes, pois removem a variância atribuível à dificuldade intrínseca de cada consulta.

**Repetições e randomização.** O número de repetições seguiu a natureza de cada cenário. Os cenários determinísticos — os cinco backbones e as configurações de ablação — usam decodificação *greedy* (temperatura 0), cuja saída é, por construção, determinística; repetir uma execução nesse regime não acrescenta variância, de modo que adotamos N=1. Já o cenário estocástico de robustez, com temperatura maior que zero, exige estimar média e dispersão: para T=0,4 e T=0,8 realizamos N=5 repetições com sementes `seed=1..5`, conciliando reprodutibilidade com a amostragem da variabilidade introduzida na decodificação. Antes dos experimentos, validamos a infraestrutura: uma avaliação *gold-vs-gold* produziu EX=EM=1,000, e a execução *greedy* do baseline reproduziu exatamente o EX=0,745, o que confirmou a estabilidade do pipeline.

## 3.4 Instrumentação e ambiente

Todos os modelos foram servidos localmente com vLLM, por meio de sua API compatível com OpenAI, em precisão FP16 e sobre uma única NVIDIA RTX 4090 (24 GB) — um ambiente acessível e de custo operacional nulo, em contraste com a dependência do GPT-4 no trabalho original. As predições foram avaliadas com o avaliador oficial test-suite-sql-eval do Spider, que computa EX e EM a partir das consultas geradas.

O experimento é orquestrado por um conjunto de scripts versionados, executável de ponta a ponta: o preparo do ambiente e dos dados (`setup_env.sh`, `download_spider.sh`, `download_models.sh`), a construção do subset determinístico (`build_subset.py`), a execução dos três blocos de cenários (`run_backbones.sh`, `run_ablation.sh`, `run_robustness.sh`) e, por fim, a coleta, a análise estatística e a geração das figuras (`collect_results.py`, `analyze.py`, `make_figures.py`). Desses artefatos resultam as Figuras 1 a 7 — da Figura 1, com o EX agregado e seus intervalos de confiança, até a Figura 7, que confronta diretamente o Qwen com o GPT-4 por dificuldade.

## 3.5 Tratamento estatístico

A escolha dos testes decorre da própria natureza dos dados. O ponto de partida é que **o EX de uma consulta é uma variável binária (Bernoulli)**: cada instância é acerto ou erro. A suposição de normalidade, portanto, simplesmente não se aplica às comparações principais entre cenários, e por isso recorremos a testes não-paramétricos pareados, adequados a dados de acerto/erro emparelhados. Para as comparações par a par — tanto na ablação quanto entre pares de backbones — empregamos o teste de McNemar, que analisa as discordâncias entre dois cenários sobre as mesmas consultas. Para a comparação simultânea dos cinco backbones, usamos o teste de Friedman, seguido, quando indicado, de um post-hoc de McNemar com correção de Bonferroni-Holm para controlar a taxa de erro sob múltiplas comparações. Como o p-valor isolado não comunica magnitude, reportamos o tamanho de efeito pelo *h* de Cohen entre proporções.

A incerteza de cada estimativa de EX foi quantificada por intervalos de confiança de 95% via bootstrap (1.000 reamostragens), o que nos permite julgar H1 de modo formal: basta verificar se o intervalo do Qwen contém o valor de referência do paper. A verificação de normalidade por Shapiro-Wilk ficou reservada ao único ponto em que faz sentido — as amostras contínuas de EX médio entre as cinco repetições do experimento de robustez. Como essas amostras se mostraram compatíveis com a normalidade (Shapiro p=0,236 em T=0,4 e p=0,435 em T=0,8), prosseguimos com o teste de Levene para a homogeneidade de variância entre temperaturas e, para o efeito sobre a média, com Kruskal-Wallis (complementado por Mann-Whitney), mantendo a abordagem não-paramétrica como salvaguarda diante do tamanho amostral reduzido (N=5). As análises foram implementadas com `numpy`, `scipy` e `statsmodels`, sobre a matriz de acertos por consulta gerada por `analyze.py`. Em síntese, o desenho é controlado, pareado e reprodutível, e cada inferência repousa sobre um teste apropriado ao tipo de dado que a sustenta.

# 4. Resultados

Apresentamos nesta seção os achados de forma estritamente descritiva, organizados em torno das quatro hipóteses do estudo; a interpretação aprofundada e os vereditos das hipóteses ficam reservados para a Discussão. Salvo indicação em contrário, todos os números reportam Execution Accuracy (EX) e Exact-Set-Match (EM) sobre o subset estratificado de 200 queries do Spider dev (easy 70, medium 70, hard 35, extra 25; `seed=42`, hash `153d3fccf9a49ce6`), com decodificação gulosa (temperatura zero) e o avaliador oficial `test-suite-sql-eval`. A título de controle de infraestrutura, a avaliação *gold-vs-gold* retornou EX=EM=1,000 e o run greedy reproduziu exatamente o baseline (EX=0,745), o que confirma a reprodutibilidade do pipeline.

## 4.1 Reprodução e comparação de backbones (H1, H3)

Avaliamos cinco modelos *instruct* de cinco provedores distintos sob o mesmo pipeline DIN-SQL. A Tabela 1 resume o EX e o EM agregados, bem como o EX desagregado por estrato de dificuldade.

**Tabela 1.** EX e EM no subset de 200 queries, por dificuldade. A última linha reproduz o DIN-SQL+GPT-4 do paper (Spider dev) como referência.

| Modelo (provedor) | EX all | EM all | easy | medium | hard | extra |
|---|---|---|---|---|---|---|
| Qwen2.5-Coder-7B (Alibaba) | **0,745** | 0,620 | 0,814 | 0,729 | 0,686 | 0,680 |
| DeepSeek-Coder-6.7B (DeepSeek) | 0,735 | 0,455 | 0,814 | 0,814 | 0,600 | 0,480 |
| Yi-Coder-9B (01.AI) | 0,725 | 0,540 | 0,786 | 0,771 | 0,657 | 0,520 |
| Granite-8B-code-128k (IBM) | 0,670 | 0,460 | 0,800 | 0,671 | 0,600 | 0,400 |
| Phi-3.5-mini-3.8B (Microsoft) | 0,630 | 0,355 | 0,757 | 0,671 | 0,400 | 0,480 |
| *DIN-SQL+GPT-4 (paper, ref.)* | *0,742* | *0,601* | *0,911* | *0,798* | *0,649* | *0,434* |

O melhor backbone aberto, o Qwen2.5-Coder-7B, atingiu EX=0,745, valor praticamente idêntico ao 0,742 que o DIN-SQL alcança com GPT-4. O intervalo de confiança bootstrap de 95% para esse EX é [0,680, 0,805] e contém o valor de referência do paper. Os demais coders de 7-9B ficaram pouco abaixo — DeepSeek-Coder-6.7B em [0,665, 0,790] e Yi-Coder-9B em [0,660, 0,790] —, enquanto Granite-8B [0,605, 0,740] e Phi-3.5-mini [0,560, 0,695] ocuparam a faixa inferior. A Figura 1 dispõe esses cinco valores de EX com seus IC95% e a linha horizontal do GPT-4 do paper, deixando visível a ampla sobreposição dos intervalos dos três coders maiores.

![Figura 1](results/figures/fig1_backbones_ex.png)

**Figura 1:** Execution Accuracy agregado (EX all) dos cinco backbones, com intervalos de confiança de 95% por bootstrap, e a linha de referência do DIN-SQL+GPT-4 do paper.

Quando decompomos o desempenho por dificuldade (Figura 2), surge um padrão claro: o Qwen fica abaixo do GPT-4 nos estratos easy (0,814 contra 0,911) e medium (0,729 contra 0,798), mas alcança ou supera a referência justamente nos estratos mais difíceis — hard (0,686 contra 0,649) e extra (0,680 contra 0,434). A Figura 7 detalha esse confronto direto, estrato a estrato, entre o Qwen local e o GPT-4 do paper. No extremo oposto situa-se o Phi-3.5-mini, cujo EX no estrato hard desaba para 0,400.

![Figura 2](results/figures/fig2_backbones_dificuldade.png)

**Figura 2:** EX por estrato de dificuldade (uma curva por backbone), confrontado com o desempenho do DIN-SQL+GPT-4 do paper.

Observamos ainda uma diferença consistente entre EX e EM em todos os backbones (Figura 3): o gap (EX menos EM) foi de 0,125 no Qwen, 0,185 no Yi, 0,210 no Granite, 0,275 no Phi e 0,280 no DeepSeek. Note-se que o melhor modelo é também o de menor gap, ao passo que DeepSeek e Phi acumulam as maiores distâncias entre acerto de execução e correspondência exata.

![Figura 3](results/figures/fig3_backbones_ex_em.png)

**Figura 3:** Comparação entre EX e EM por backbone; a distância entre as duas barras revela o gap característico da geração em contexto.

Quanto à hipótese H3, o teste de Friedman sobre a matriz por-query indicou diferença global significativa entre os cinco backbones (χ²=14,379; p=0,0062). No post-hoc, as comparações pareadas de McNemar com correção de Bonferroni-Holm revelaram um único par significativo: Qwen2.5-Coder-7B contra Phi-3.5-mini (p=0,001; p_aj=0,013; Cohen h=+0,249). Os contrastes entre os coders maiores não atingiram significância — Qwen vs DeepSeek p=0,890 e Qwen vs Yi p=0,665 —, e Qwen vs Granite ficou exatamente no limiar (p=0,050), mas não sobreviveu à correção de Holm. Em suma, a diferença global é puxada pelo Phi-3.5; os coders de 7-9B empatam entre si.

![Figura 7](results/figures/fig7_qwen_vs_paper.png)

**Figura 7:** Confronto direto, por dificuldade, entre o Qwen2.5-Coder-7B local e o DIN-SQL+GPT-4 do paper.

## 4.2 Estudo de ablação (H2)

Para isolar a contribuição de cada módulo do DIN-SQL, fixamos o Qwen2.5-Coder-7B (configuração completa: EX=0,745) e desligamos ou substituímos um módulo por vez. A Tabela 2 reúne, para cada variante, o EX agregado e por dificuldade, o delta em relação à configuração full, o p-valor do teste de McNemar pareado e o tamanho de efeito de Cohen h.

**Tabela 2.** Ablação no Qwen2.5-Coder-7B. Δ EX e testes são calculados em relação à configuração full.

| Configuração | EX all | easy | medium | hard | extra | Δ EX | p (McNemar) | Cohen h |
|---|---|---|---|---|---|---|---|---|
| full (referência) | 0,745 | 0,814 | 0,729 | 0,686 | 0,680 | — | — | — |
| sem self-correction | 0,665 | 0,771 | 0,714 | 0,543 | 0,400 | −0,080 | <0,001 | −0,176 |
| CoT forçado (force nested) | 0,675 | 0,829 | 0,714 | 0,457 | 0,440 | −0,070 | 0,026 | −0,155 |
| few-shot forçado (force easy) | 0,790 | 0,871 | 0,814 | 0,743 | 0,560 | +0,045 | 0,049 | +0,107 |
| sem schema-linking | 0,765 | 0,829 | 0,800 | 0,686 | 0,600 | +0,020 | 0,556 | +0,049 |

A remoção do self-correction produziu a maior queda (−0,080), estatisticamente significativa (p<0,001; h=−0,176), com colapso acentuado nos estratos hard (0,543) e extra (0,400). Forçar a geração via CoT decomposto em todas as queries também reduziu o EX de forma significativa (−0,070; p=0,026; h=−0,155), novamente com forte impacto no hard (0,457). Em sentido oposto, forçar o caminho few-shot simples elevou o EX para 0,790 (+0,045), efeito significativo ainda que limítrofe (p=0,049; h=+0,107), com ganhos em easy, medium e hard e perda isolada apenas no extra (0,560 contra 0,680). Por fim, remover o schema-linking deslocou o EX em apenas +0,020, variação que não atingiu significância (p=0,556; h=+0,049). A Figura 4 ilustra o EX agregado das cinco configurações com seus respectivos deltas, enquanto a Figura 5 detalha o comportamento de cada variante por dificuldade.

![Figura 4](results/figures/fig4_ablation_ex.png)

**Figura 4:** EX agregado das cinco configurações de ablação no Qwen2.5-Coder-7B, com o delta de cada variante em relação à configuração full.

![Figura 5](results/figures/fig5_ablation_dificuldade.png)

**Figura 5:** EX por dificuldade para a configuração full e as quatro variantes de ablação, evidenciando o trade-off entre prompts simples e decompostos.

## 4.3 Robustez à temperatura (H4)

Variamos a temperatura de decodificação do Qwen2.5-Coder-7B em três níveis, com N=5 repetições (`seed=1..5`) nos níveis estocásticos; o nível greedy é determinístico (N=1). A Tabela 3 reporta a média e o desvio-padrão (ddof=1) do EX por temperatura.

**Tabela 3.** EX por temperatura de decodificação no Qwen2.5-Coder-7B.

| Temperatura | EX médio | desvio (±) | reps | amplitude |
|---|---|---|---|---|
| 0,0 (greedy) | 0,745 | — | 1 | — |
| 0,4 | 0,758 | ±0,020 | 5 | 0,725–0,775 |
| 0,8 | 0,719 | ±0,049 | 5 | 0,645–0,765 |

O desvio-padrão cresceu de ±0,020 em T=0,4 para ±0,049 em T=0,8, nível no qual a amplitude entre repetições passou a cobrir de 0,645 a 0,765. Em termos de média, T=0,4 ficou marginalmente acima do greedy e T=0,8, abaixo. A Figura 6 apresenta as médias com seus desvios e os pontos das repetições individuais.

![Figura 6](results/figures/fig6_robustez_temperatura.png)

**Figura 6:** EX por temperatura de decodificação no Qwen2.5-Coder-7B; barras indicam média e desvio, e os pontos, as repetições individuais.

A verificação estatística seguiu três etapas encadeadas. Primeiro, o teste de Shapiro-Wilk não rejeitou a normalidade das amostras de EX entre repetições (T=0,4 p=0,236; T=0,8 p=0,435), o que habilita os testes subsequentes. Em seguida, o teste de Levene não detectou diferença significativa de variância entre os níveis (p=0,273). Por fim, o teste de Kruskal-Wallis não acusou efeito significativo da temperatura sobre a média do EX (p=0,116).

## 4.4 Incompatibilidade do SQLCoder-7B-2

O modelo `defog/sqlcoder-7b-2`, especializado em SQL e do tipo *completion*, não dispõe de *chat template* e, por isso, não executa no pipeline chat do DIN-SQL: a primeira chamada trava. Acessado por endpoint *completion*, ele de fato roda, mas os prompts decompostos do DIN-SQL não correspondem ao formato que espera. Documentamos o caso como uma limitação de compatibilidade e o substituímos pelos cinco backbones *instruct* descritos na Seção 4.1.

# 5. Discussão

Os experimentos da Seção 4 permitem responder, uma a uma, às quatro hipóteses formuladas na metodologia. Adiantamos a conclusão: a reprodução do desempenho global do DIN-SQL foi bem-sucedida com um modelo aberto a custo zero, mas a *anatomia* da contribuição de cada parte do método mudou de forma relevante quando trocamos o GPT-4 por *code-LLMs* abertos contemporâneos. É nessa mudança que reside o achado central deste trabalho.

## 5.1 H1: um coder de 7B local iguala o GPT-4 do paper

Nossa primeira hipótese sustentava que um *code-LLM* aberto de aproximadamente 7B, operado sob o mesmo pipeline DIN-SQL, atingiria EX comparável ao GPT-4 reportado no artigo original. Os dados confirmam essa expectativa de maneira quase literal: o Qwen2.5-Coder-7B obteve EX = 0,745 no subset, contra 0,742 do DIN-SQL+GPT-4 no Spider dev. A diferença é de três décimos de ponto percentual, e o intervalo de confiança bootstrap de 95% do Qwen, [0,680, 0,805], contém com folga o valor de referência do paper. Não há, portanto, qualquer evidência de que o modelo aberto seja inferior ao GPT-4 nesta tarefa e neste regime de avaliação. **Consideramos H1 sustentada.**

A leitura por dificuldade, ilustrada na Figura 7, qualifica o que significa "empatar" e torna o resultado mais interessante. O Qwen fica abaixo do GPT-4 nos estratos mais fáceis (easy 0,814 vs 0,911; medium 0,729 vs 0,798), mas alcança e supera o paper nas faixas difíceis: 0,686 vs 0,649 no hard e 0,680 vs 0,434 no extra. O ganho no extra é expressivo — cerca de 25 pontos percentuais. Esse padrão sugere que o empate agregado não vem de um desempenho uniformemente equivalente, e sim de uma compensação: o Qwen perde um pouco onde já era fácil acertar e recupera onde está o desafio real. É justamente por causa desse contraste que reportamos a comparação com o paper sempre por dificuldade, e não pelo número agregado — ponto ao qual voltaremos na Seção 6.

## 5.2 H2 e o achado central: o scaffolding é parcialmente redundante

A segunda hipótese — de que *cada* módulo do DIN-SQL contribui para o EX, de modo que removê-lo o degradaria — produziu os resultados mais surpreendentes, e é onde o estudo de fato vai além de uma simples reprodução. A ablação no Qwen, resumida na Tabela 2 e nas Figuras 4 e 5, revela um quadro bem mais matizado do que a hipótese previa. **Consideramos H2 parcialmente refutada.**

O único módulo que se comporta como o paper antecipa é a **self-correction**. Removê-la derruba o EX de 0,745 para 0,665 (Δ = −0,080), com efeito altamente significativo no McNemar pareado (p < 0,001, Cohen's h = −0,176). O colapso concentra-se exatamente onde mais dói: o EX no hard cai para 0,543 e no extra para 0,400. Esse é, isoladamente, o componente mais valioso do andaime do DIN-SQL, e o achado coincide com o relato original dos autores.

Os demais módulos contam outra história. O **schema-linking** explícito mostrou-se **neutro**: ao desligá-lo, o EX subiu marginalmente (Δ = +0,020), e o McNemar não detectou diferença (p = 0,556). A interpretação mais natural é que um coder moderno como o Qwen já realiza o vínculo entre pergunta e esquema de forma implícita, durante a própria geração, de modo que o passo explícito acrescenta sobretudo ruído. Mais provocativo ainda é o comportamento da etapa de **classificação → prompt complexo**: forçar o caminho de *few-shot* simples para todas as queries elevou o EX a 0,790 (Δ = +0,045, p = 0,049, h = +0,107), enquanto forçar o caminho de CoT decomposto para todas piorou para 0,675 (Δ = −0,070, p = 0,026, h = −0,155). Ou seja, em vez de ajudar uniformemente, a maquinaria de decomposição chega a *atrapalhar* quando aplicada de forma indiscriminada.

Daí emerge o que chamamos de **achado central**: nos *code-LLMs* de 7B contemporâneos, parte do andaime concebido para a era CodeX/GPT-4 tornou-se redundante. O que ainda paga é a self-correction; o schema-linking ficou neutro; e a decomposição em prompts complexos só se justifica nos casos mais difíceis. A leitura por dificuldade da ablação confirma o *trade-off* simples-vs-decomposto que o próprio paper descreve: o *few-shot* simples vence o full no easy (0,871 vs 0,814), no medium (0,814 vs 0,729) e no hard (0,743 vs 0,686), e só perde no **extra** (0,560 vs 0,680). A decomposição completa, portanto, paga sua complexidade apenas nas queries extra-difíceis. Para o Qwen, a engrenagem inteira do DIN-SQL é vantajosa precisamente quando o problema é mais duro, e não como regra geral.

## 5.3 H3: os backbones diferem, mas os coders 7–9B empatam entre si

A terceira hipótese previa diferença significativa de EX entre os cinco backbones. O teste de Friedman a sustenta no agregado (χ² = 14,379, p = 0,0062): existe, sim, heterogeneidade global entre os modelos, visível na Figura 1. **Consideramos H3 sustentada globalmente**, mas com uma ressalva importante revelada pelo post-hoc.

Ao decompor a diferença par a par com McNemar e correção de Bonferroni-Holm, apenas o contraste **Qwen vs Phi-3.5** sobrevive (p = 0,001, p_adj = 0,013, h = +0,249). Os demais pares entre os coders maiores não se distinguem: Qwen vs DeepSeek (p = 0,890), Qwen vs Yi (p = 0,665) e Qwen vs Granite no limiar (p = 0,050, perdendo a significância após Holm). Em outras palavras, a diferença global é puxada essencialmente pelo Phi-3.5-mini (3,8B) ficar atrás; os três coders de 7–9B (Qwen, DeepSeek, Yi) **empatam estatisticamente**, com EX entre 0,725 e 0,745. Dentro dessa faixa de capacidade, a escolha do backbone é praticamente indiferente para o desempenho final — uma boa notícia para quem pretende reproduzir o método com recursos limitados.

## 5.4 H4: greedy é estável; temperatura alta não compensa

A quarta hipótese afirmava que aumentar a temperatura elevaria a variabilidade do EX *sem* ganho na média. Os dados de robustez (Figura 6) confirmam a ausência de ganho de forma clara, e essa é a parte mais sólida do veredito. **Consideramos H4 sustentada.** O greedy (T = 0,0) entrega EX = 0,745; T = 0,4 fica marginalmente acima, em 0,758 ± 0,020; e T = 0,8 cai para 0,719 ± 0,049. O teste de Kruskal-Wallis não detecta efeito da temperatura sobre a média (p = 0,116), de modo que nenhuma temperatura positiva supera o greedy de forma estatisticamente defensável.

Quanto à parte da hipótese que tratava da variabilidade, a evidência é sugestiva, porém mais frágil. O desvio em T = 0,8 é cerca de 2,5 vezes o de T = 0,4, e a amplitude observada em T = 0,8 chega a 12 pontos (de 0,645 a 0,765 — ou seja, uma corrida isolada despencou para 0,645). Ainda assim, o teste de Levene não confirma diferença significativa entre as variâncias (p = 0,273): com apenas N = 5 repetições, falta poder estatístico para cravar o aumento. O crescimento da variabilidade é, então, *numérico* e plausível, mas não significativo no nosso desenho. Vale registrar que as amostras de EX entre repetições passaram no Shapiro-Wilk (T = 0,4 p = 0,236; T = 0,8 p = 0,435), o que legitima o uso dos testes paramétricos de variância nesse ponto. A recomendação prática é direta e alinhada ao paper: **greedy (temp = 0) é a escolha segura e reprodutível**, pois entrega desempenho competitivo sem o risco de quedas pontuais.

## 5.5 SQLCoder e a tese da habilidade emergente

Um episódio à margem do desenho principal reforça, de modo eloquente, a leitura acima sobre dependência de capacidade. O `defog/sqlcoder-7b-2`, modelo SQL-especializado em estilo *completion* e sem *chat template*, simplesmente **não roda no pipeline chat do DIN-SQL**: trava já na primeira chamada, porque os prompts decompostos não correspondem ao formato que ele espera. Esse não é um defeito de configuração contornável, e sim uma incompatibilidade de fundo — o prompting decomposto pressupõe *instruction-following* geral, habilidade que um modelo de completion estritamente especializado não possui. O caso conecta-se diretamente à tese do artigo original sobre a natureza emergente do método: o DIN-SQL não é apenas um conjunto de prompts, mas uma técnica que só "pega" sobre modelos com capacidade de seguir instruções complexas. A mesma lógica explica, no outro extremo de capacidade, por que o Phi-3.5-mini (3,8B) colapsa no hard (EX = 0,400): quando a habilidade subjacente enfraquece, o andaime deixa de sustentar o desempenho.

## 5.6 O gap EX–EM e a natureza do in-context learning

Por fim, todos os backbones exibem um descompasso considerável entre EX e EM (Figura 3), conforme já antecipado pelos autores do DIN-SQL. O gap vai de 0,125 no Qwen, passando por Yi (0,185) e Granite (0,210), até Phi (0,275) e DeepSeek (0,280). A interpretação é a esperada para geração in-context: os modelos produzem SQL **semanticamente correto** — que retorna o resultado certo no banco, e portanto acerta o EX — mas **sintaticamente diverso** da consulta de referência, o que penaliza o EM, métrica de casamento exato de cláusulas. Curiosamente, em EM o próprio Qwen (0,620) fica acima do valor de referência do GPT-4 (0,601); o que distingue os modelos abertos é, antes, a *largura* do gap interno entre suas duas métricas. O caso do DeepSeek-Coder é ilustrativo: ele praticamente empata com o Qwen em EX (0,735 vs 0,745), mas tem o maior gap (0,280), o que aponta um modelo que "resolve" a query por caminhos sintáticos próprios, distantes da formulação canônica. É por gerar SQL correto em execução, mas idiossincrático em forma, que tratamos o EX como métrica primária e o EM apenas como complemento.

# 6. Ameaças à validade

Como em qualquer estudo empírico, nossos resultados estão sujeitos a limitações que delimitam o alcance das conclusões. Organizamo-las segundo os tipos clássicos de validade.

## 6.1 Validade interna

A principal ameaça interna decorre da própria métrica primária. A **Execution Accuracy compara o resultado da query predita com o da query de referência no banco específico**, o que pode gerar **falsos positivos**: duas consultas distintas — uma correta e outra apenas acidentalmente coincidente — podem retornar o mesmo conjunto de linhas naquele banco particular e ambas serem contadas como acerto. Mitigamos parcialmente esse risco ao adotar o avaliador oficial test-suite-sql-eval, que reduz coincidências espúrias, e ao reportar o EM como métrica complementar — embora, como discutido em 5.6, o próprio EM tenha suas limitações no contexto de geração in-context.

Uma segunda ameaça interna está no **parsing da saída do modelo**: como operamos os backbones em formato de chat, é preciso extrair a SQL final do texto gerado, e uma extração imperfeita poderia subestimar o desempenho real. Esse risco foi mitigado pela rotina de limpeza (`clean_sql`) e validado pelo teste de sanidade *gold-vs-gold*, que produziu EX = EM = 1,000, confirmando que o pipeline de avaliação não introduz perdas espúrias.

## 6.2 Validade externa

A generalização dos resultados é limitada por três fatores. Primeiro, avaliamos sobre **um único benchmark, o Spider, e em um único idioma, o inglês** — a mesma restrição do trabalho original, mas que impede afirmar que os achados se transferem para bancos de domínios distintos, esquemas mais complexos (como em BIRD) ou perguntas em outras línguas. Segundo, e mais importante, **a ablação foi conduzida em um único modelo, o Qwen2.5-Coder-7B**. O achado central sobre a redundância parcial do scaffolding — schema-linking neutro, classificação que pode atrapalhar — é, a rigor, uma afirmação sobre *este* coder, e não está demonstrado que se mantém nos demais backbones. É plausível que modelos mais fracos, como o Phi, ainda se beneficiem do schema-linking explícito, justamente por não realizarem o vínculo implicitamente. Generalizar o achado exigiria replicar a ablação em múltiplos modelos.

## 6.3 Validade de conclusão

Várias ressalvas estatísticas pesam sobre a força das nossas inferências. O subset tem **n = 200**, o que implica erro-padrão da ordem de 3 pontos no EX; diferenças menores que isso estão, em princípio, dentro do ruído. O problema se agrava nos **estratos pequenos**, em particular o **extra (n = 25)** e o hard (n = 35): os números desses estratos — incluindo a vantagem expressiva do Qwen sobre o GPT-4 no extra — são os mais voláteis e devem ser lidos com cautela.

Há ainda uma assimetria de composição: **o subset não reproduz a proporção de dificuldades do dev completo** (cerca de 35% de easy no subset contra 24% no dev). Por isso, e como já frisado, comparamos com o paper **por dificuldade**, e não pelo número agregado — o "all" do nosso subset e o "all" do dev não são diretamente comparáveis. Por fim, parte dos resultados da ablação é **estatisticamente limítrofe**: o ganho do *few-shot* forçado tem p = 0,049, exatamente na borda do limiar convencional de 0,05. Tratamos esse achado como sugestivo, não como definitivo, e o mesmo cuidado vale para o contraste Qwen vs Granite (p = 0,050), que não sobrevive à correção de Holm.

## 6.4 Limitação do desenho de robustez

Cabe registrar, com transparência, que o estudo de robustez explorou **apenas o eixo da temperatura**. O eixo do **número de exemplos few-shot**, igualmente previsto como fonte de variabilidade no desempenho in-context, **não foi executado**. Assim, a conclusão de H4 sobre estabilidade vale especificamente para a decodificação por temperatura; a sensibilidade do método à quantidade e à seleção dos exemplos in-context permanece em aberto e fica indicada como trabalho futuro. Soma-se a isso o baixo número de repetições no regime estocástico (N = 5) que, como apontado em 5.4, limita o poder para confirmar diferenças de variância via Levene.

# 7. Conclusão

Neste trabalho reproduzimos o DIN-SQL substituindo o GPT-4 por code-LLMs abertos servidos localmente, e mostramos que o método pode ser replicado a custo zero sem perda mensurável de desempenho. Sobre o subset estratificado de 200 consultas do Spider dev, o Qwen2.5-Coder-7B alcançou EX de 0,745, praticamente idêntico ao 0,742 relatado para o DIN-SQL com GPT-4. O intervalo de confiança bootstrap de 95% que obtivemos para o nosso modelo, [0,680, 0,805], contém esse valor original — sinal de que a diferença entre os dois é indistinguível do ruído amostral. A comparação por dificuldade (Figura 7) detalha o quadro: ficamos abaixo nas consultas *easy* e *medium*, mas igualamos ou superamos o GPT-4 nas faixas *hard* (0,686 contra 0,649) e *extra* (0,680 contra 0,434). Confirma-se, assim, a hipótese H1: um *coder* aberto de cerca de 7B parâmetros, sob o pipeline DIN-SQL, atinge desempenho comparável ao de um modelo proprietário muito maior.

Não nos limitamos a reproduzir. Acrescentamos o tratamento estatístico que faltava à avaliação original, partindo de uma matriz de acertos por consulta — um desenho pareado sobre as mesmas 200 instâncias. Sobre ela aplicamos testes adequados ao tipo de dado: *bootstrap* para os intervalos de confiança, McNemar para as comparações par-a-par, Friedman com correção de Bonferroni-Holm para o conjunto de *backbones*, e Shapiro-Wilk, Levene e Kruskal-Wallis para a robustez à temperatura. Essa camada nos permitiu separar diferenças reais do ruído amostral — distinção nada trivial num subset em que o erro-padrão ronda os três pontos percentuais.

O achado central, contudo, não está na reprodução em si, mas no que ela revela sobre a anatomia do método. O *ablation* sobre o Qwen (Figuras 4 e 5) mostra que, dos módulos do DIN-SQL, apenas a *self-correction* contribui de forma inequívoca: removê-la derruba o EX em oito pontos (delta -0,080; McNemar p < 0,001; Cohen *h* = -0,176), com colapso justamente nas faixas *hard* (de 0,686 para 0,543) e *extra* (de 0,680 para 0,400). O *schema-linking*, em contraste, mostrou-se neutro para um *coder* moderno (delta +0,020; p = 0,556). E há um resultado que vai além da neutralidade: forçar a classificação para o caminho mais simples de *few-shot* chegou a melhorar o resultado geral (delta +0,045; p = 0,049), enquanto forçar o caminho de raciocínio decomposto o prejudicou (delta -0,070; p = 0,026). Em outras palavras, reproduzimos o desempenho do DIN-SQL, mas constatamos que **parte do andaime de *prompting* concebido para a era CodeX/GPT-4 tornou-se redundante** em code-LLMs abertos atuais, que parecem internalizar o alinhamento entre esquema e pergunta. A maquinaria completa do método só compensa nas consultas extra-difíceis. Essa leitura sustenta apenas parcialmente H2 e dialoga com a tese de habilidade emergente do artigo original — tese reforçada pelo caso do SQLCoder-7B-2, um modelo de *completion* especializado que sequer roda no pipeline de *chat* por não seguir instruções gerais.

Quanto aos demais vereditos, observamos diferença global significativa entre os cinco *backbones* (Friedman chi2 = 14,379; p = 0,0062), mas o *post-hoc* mostra que essa diferença é puxada pelo Phi-3.5-mini (3,8B), o único par estatisticamente distinto do Qwen após a correção de Holm (p = 0,001; p_adj = 0,013; Cohen *h* = +0,249). Os *coders* de 7 a 9B empatam entre si: Qwen contra DeepSeek (p = 0,890), contra Yi (p = 0,665) e, no limite, contra Granite (p = 0,050, que perde a significância após Holm). H3, portanto, é sustentada no agregado, mas com a nuance de que apenas o modelo menor se separa do grupo. Por fim, a análise de robustez confirma que a decodificação *greedy* (temperatura 0) é a escolha segura e reprodutível: temperaturas mais altas não trouxeram ganho de média (Kruskal-Wallis p = 0,116) e o aumento de variância foi apenas numérico — o desvio sobe de ±0,020 em T = 0,4 para ±0,049 em T = 0,8, mas sem significância com N = 5 (Levene p = 0,273) —, o que sustenta H4.

Vários caminhos ficam em aberto. O mais imediato é o eixo de *few-shot*: como simplificar a classificação ajudou de forma limítrofe, vale isolar o efeito do número e da seleção de exemplos *in-context*, hoje fixos no pipeline. Em segundo lugar, o nosso *ablation* concentrou-se no Qwen; estendê-lo aos demais *backbones* permitiria verificar se a redundância do *scaffolding* é uma propriedade geral dos *coders* modernos ou particularidade de um único modelo. Seria igualmente proveitoso ampliar a avaliação para além do Spider — em especial para o BIRD, com esquemas maiores e mais ruidosos — e para outros idiomas, já que tanto o nosso estudo quanto o original se restringem ao inglês. Cada um desses eixos ataca uma das ameaças à validade que declaramos e ajudaria a delinear, com mais precisão, onde e para quem a decomposição do DIN-SQL ainda compensa.

# 8. Reprodutibilidade e disponibilidade

Todo o material necessário para reproduzir o estudo é público. O repositório reúne (i) o código do pipeline DIN-SQL adaptado e os *scripts* de execução; (ii) a definição do subset determinístico — as 200 consultas estratificadas (easy 70, medium 70, hard 35, extra 25) com `seed=42` e hash de verificação `153d3fccf9a49ce6`; (iii) a especificação do ambiente (`setup_env.sh` com o vLLM pinado), que fixa o *serving* em FP16 sobre a RTX 4090; (iv) os dados brutos de resultado (saídas por consulta e relatórios do avaliador oficial `test-suite-sql-eval`); (v) as tabelas de análise estatística em `results/analysis/`; e (vi) as sete figuras do artigo em `results/figures/`. A própria validação da infraestrutura está entre os artefatos: a avaliação *gold-vs-gold* retorna EX = EM = 1,000, e o *run greedy* reproduz exatamente o baseline de EX = 0,745.

O pipeline de reprodução é encadeado em etapas, uma por comando, na seguinte ordem:

```
setup_env.sh        # cria o ambiente e instala o vLLM pinado
download_spider.sh  # baixa o Spider e o avaliador test-suite-sql-eval
download_models.sh  # baixa os 5 backbones instruct
build_subset.py     # gera o subset estratificado (seed=42, hash 153d3fccf9a49ce6)
run_backbones.sh    # avalia os 5 backbones (greedy, Extensao A)
run_ablation.sh     # roda as 5 configuracoes de ablation no Qwen
run_robustness.sh   # roda a robustez a temperatura (N=5 para temp>0)
collect_results.py  # consolida as saidas por consulta
analyze.py          # bootstrap, McNemar, Friedman+Holm, Cohen's h, Shapiro/Levene/Kruskal
make_figures.py     # gera as Figuras 1 a 7
```

Como os cenários de *backbones* e de *ablation* usam decodificação *greedy* (temperatura 0), suas saídas são determinísticas e dispensam repetição; apenas o experimento de robustez (temperaturas 0,4 e 0,8) emprega N = 5 repetições, com `seed=1..5`, igualmente reprodutíveis. Quem dispuser do hardware indicado deve, portanto, obter exatamente os números reportados nas Seções 4 a 6.

# Referências

Pourreza, M.; Rafiei, D. (2023). **DIN-SQL: Decomposed In-Context Learning of Text-to-SQL with Self-Correction.** In: Advances in Neural Information Processing Systems (NeurIPS), 2023.

Yu, T.; Zhang, R.; Yang, K.; Yasunaga, M.; Wang, D.; Li, Z.; Ma, J.; Li, I.; Yao, Q.; Roman, S.; Zhang, Z.; Radev, D. (2018). **Spider: A Large-Scale Human-Labeled Dataset for Complex and Cross-Domain Semantic Parsing and Text-to-SQL Task.** In: Proceedings of the Conference on Empirical Methods in Natural Language Processing (EMNLP), 2018.

Zhong, R.; Yu, T.; Klein, D. (2020). **Semantic Evaluation for Text-to-SQL with Distilled Test Suites.** In: Proceedings of the Conference on Empirical Methods in Natural Language Processing (EMNLP), 2020.

Hui, B.; Yang, J.; et al. (2024). **Qwen2.5-Coder Technical Report.** Alibaba Group. arXiv:2409.12186.

Guo, D.; Zhu, Q.; Yang, D.; et al. (2024). **DeepSeek-Coder: When the Large Language Model Meets Programming — The Rise of Code Intelligence.** DeepSeek-AI. arXiv:2401.14196.

01.AI (2024). **Yi-Coder: A Series of Open-Source Code Language Models.** 01.AI Technical Blog/Report.

Mishra, M.; Stallone, M.; et al. (2024). **Granite Code Models: A Family of Open Foundation Models for Code Intelligence.** IBM Research. arXiv:2405.04324.

Abdin, M.; et al. (2024). **Phi-3 Technical Report: A Highly Capable Language Model Locally on Your Phone.** Microsoft. arXiv:2404.14219.

Kwon, W.; Li, Z.; Zhuang, S.; Sheng, Y.; Zheng, L.; Yu, C. H.; Gonzalez, J. E.; Zhang, H.; Stoica, I. (2023). **Efficient Memory Management for Large Language Model Serving with PagedAttention (vLLM).** In: Proceedings of the ACM Symposium on Operating Systems Principles (SOSP), 2023.
