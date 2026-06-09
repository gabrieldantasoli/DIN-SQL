"""
analyze.py — Análise estatística da reprodução (Bloco 5).

Lê results/correctness_matrix.csv (acerto/erro por query) e produz:
  1. EX por configuração + Bootstrap IC95%        (todas as configs)
  2. Backbones: Friedman + Bonferroni-Holm (McNemar par-a-par) + Cohen's h
  3. Ablation: full vs cada variante (McNemar pareado + delta)
  4. Robustez: média ± desvio + IC do EX por temperatura
Saídas: tabelas no stdout + CSVs/figuras em results/analysis/.

Uso:
  python src/analyze.py
  python src/analyze.py --matrix results/correctness_matrix.csv
"""

import argparse
import math
import os

import numpy as np
import pandas as pd
from scipy import stats
from statsmodels.stats.contingency_tables import mcnemar
from statsmodels.stats.multitest import multipletests

BACKBONES = [
    "Qwen2.5-Coder-7B-Instruct",
    "deepseek-coder-6.7b-instruct",
    "Yi-Coder-9B-Chat",
    "granite-8b-code-instruct-128k",
    "Phi-3.5-mini-instruct",
]
FULL = "Qwen2.5-Coder-7B-Instruct"   # modelo usado no ablation/robustez
RNG = np.random.default_rng(42)


def bootstrap_ci(x, n_boot=1000, alpha=0.05):
    """IC percentil para a média de um vetor 0/1 (EX)."""
    x = np.asarray(x)
    means = [RNG.choice(x, size=len(x), replace=True).mean() for _ in range(n_boot)]
    lo, hi = np.percentile(means, [100 * alpha / 2, 100 * (1 - alpha / 2)])
    return x.mean(), lo, hi


def cohens_h(p1, p2):
    """Tamanho de efeito para duas proporções."""
    return 2 * math.asin(math.sqrt(p1)) - 2 * math.asin(math.sqrt(p2))


def mcnemar_test(a, b):
    """McNemar pareado entre dois vetores 0/1. Retorna (b01, b10, p)."""
    a, b = np.asarray(a), np.asarray(b)
    b01 = int(np.sum((a == 0) & (b == 1)))   # a erra, b acerta
    b10 = int(np.sum((a == 1) & (b == 0)))   # a acerta, b erra
    table = [[int(np.sum((a == 1) & (b == 1))), b10],
             [b01, int(np.sum((a == 0) & (b == 0)))]]
    exact = (b01 + b10) < 25
    p = mcnemar(table, exact=exact).pvalue
    return b01, b10, p


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--matrix", default="results/correctness_matrix.csv")
    ap.add_argument("--outdir", default="results/analysis")
    args = ap.parse_args()

    df = pd.read_csv(args.matrix)
    os.makedirs(args.outdir, exist_ok=True)
    configs = [c for c in df.columns if c not in ("query_idx", "db", "hardness")]
    n = len(df)
    print(f"Matriz: {n} queries × {len(configs)} configs\n")

    # ---------- 1. EX + Bootstrap IC95% (todas as configs) ----------
    print("=" * 70)
    print("1) Execution Accuracy + IC95% (bootstrap N=1000)")
    print("=" * 70)
    rows = []
    for c in configs:
        ex, lo, hi = bootstrap_ci(df[c].values)
        rows.append({"config": c, "EX": ex, "ci_low": lo, "ci_high": hi})
        print(f"  {c:<46} EX={ex:.3f}  IC95%=[{lo:.3f}, {hi:.3f}]")
    pd.DataFrame(rows).to_csv(os.path.join(args.outdir, "ex_ci.csv"), index=False)

    # ---------- 2. Backbones: Friedman + Holm(McNemar) + Cohen's h ----------
    present = [b for b in BACKBONES if b in configs]
    if len(present) >= 3:
        print("\n" + "=" * 70)
        print(f"2) Backbones ({len(present)} modelos)")
        print("=" * 70)
        data = [df[b].values for b in present]
        chi, p = stats.friedmanchisquare(*data)
        print(f"  Friedman: chi2={chi:.3f}  p={p:.4g}  "
              f"({'há diferença global' if p < 0.05 else 'sem diferença global'})")

        # McNemar par-a-par + correção Holm
        pairs, pvals = [], []
        for i in range(len(present)):
            for j in range(i + 1, len(present)):
                _, _, pv = mcnemar_test(df[present[i]].values, df[present[j]].values)
                pairs.append((present[i], present[j])); pvals.append(pv)
        rej, padj, _, _ = multipletests(pvals, method="holm")
        print("\n  McNemar par-a-par (p ajustado por Bonferroni-Holm):")
        prows = []
        for (a, b), pv, pa, r in zip(pairs, pvals, padj, rej):
            h = cohens_h(df[a].mean(), df[b].mean())
            sig = "*" if r else " "
            print(f"    {a:<32} vs {b:<32} p={pv:.3f} p_adj={pa:.3f} {sig}  h={h:+.3f}")
            prows.append({"a": a, "b": b, "p": pv, "p_holm": pa,
                          "signif": bool(r), "cohens_h": h})
        pd.DataFrame(prows).to_csv(os.path.join(args.outdir, "backbones_pairwise.csv"),
                                   index=False)
    else:
        print("\n[2] backbones insuficientes na matriz — pulado.")

    # ---------- 3. Ablation: full vs variantes ----------
    abl = [c for c in configs if c.startswith("abl_")]
    if abl and FULL in configs:
        print("\n" + "=" * 70)
        print("3) Ablation (full vs variantes) — McNemar pareado")
        print("=" * 70)
        full_ex = df[FULL].mean()
        print(f"  full ({FULL}): EX={full_ex:.3f}")
        arows = []
        for c in sorted(abl):
            b01, b10, pv = mcnemar_test(df[FULL].values, df[c].values)
            delta = df[c].mean() - full_ex
            h = cohens_h(df[c].mean(), full_ex)
            sig = "*" if pv < 0.05 else " "
            print(f"    {c:<48} EX={df[c].mean():.3f}  Δ={delta:+.3f}  "
                  f"p={pv:.3f}{sig}  h={h:+.3f}")
            arows.append({"variant": c, "EX": df[c].mean(), "delta_vs_full": delta,
                          "p_mcnemar": pv, "signif": pv < 0.05, "cohens_h": h})
        pd.DataFrame(arows).to_csv(os.path.join(args.outdir, "ablation.csv"), index=False)
    else:
        print("\n[3] sem colunas de ablation (abl_*) — pulado.")

    # ---------- 4. Robustez: por temperatura ----------
    robust = [c for c in configs if c.startswith("robust_")]
    if robust:
        print("\n" + "=" * 70)
        print("4) Robustez — EX por temperatura (média ± desvio entre repetições)")
        print("=" * 70)
        # parse robust_<modelo>_T<temp>_r<rep>
        recs = []
        for c in robust:
            try:
                temp = c.split("_T")[1].split("_r")[0]
            except IndexError:
                continue
            recs.append({"config": c, "temp": float(temp), "EX": df[c].mean()})
        rdf = pd.DataFrame(recs)
        rrows, groups = [], []
        for temp, grp in rdf.groupby("temp"):
            exs = grp["EX"].values
            mean, sd = exs.mean(), (exs.std(ddof=1) if len(exs) > 1 else 0.0)
            # normalidade (Shapiro-Wilk) por temperatura, quando n>=3
            if len(exs) >= 3:
                sw_p = stats.shapiro(exs).pvalue
                norm = f"Shapiro p={sw_p:.3f} ({'normal' if sw_p>0.05 else 'não-normal'})"
            else:
                sw_p, norm = float("nan"), "n<3 (sem teste)"
            print(f"  T={temp:<4}  EX={mean:.3f} ± {sd:.3f}  (n_reps={len(exs)})  {norm}")
            rrows.append({"temp": temp, "EX_mean": mean, "EX_std": sd,
                          "n_reps": len(exs), "shapiro_p": sw_p})
            if len(exs) >= 2:
                groups.append(exs)
        pd.DataFrame(rrows).to_csv(os.path.join(args.outdir, "robustness.csv"), index=False)

        # variabilidade entre temperaturas (Levene) + efeito da temperatura (Kruskal)
        if len(groups) >= 2:
            lev_p = stats.levene(*groups).pvalue
            kw_p = stats.kruskal(*groups).pvalue
            print(f"\n  Levene (homogeneidade de variância): p={lev_p:.3f} "
                  f"({'variâncias iguais' if lev_p>0.05 else 'variâncias diferentes'})")
            print(f"  Kruskal-Wallis (efeito da temperatura no EX): p={kw_p:.3f} "
                  f"({'há efeito' if kw_p<0.05 else 'sem efeito significativo'})")
    else:
        print("\n[4] sem colunas de robustez (robust_*) — pulado.")

    # ---------- nota metodológica sobre normalidade ----------
    print("\n" + "-" * 70)
    print("Nota: o EX por query é BINÁRIO (Bernoulli) — normalidade não se aplica às")
    print("comparações principais; por isso usam-se testes NÃO-PARAMÉTRICOS pareados")
    print("(McNemar/Friedman). A normalidade (Shapiro-Wilk) é verificada nas amostras")
    print("contínuas de EX entre repetições (robustez), justificando Levene/Kruskal.")

    # ---------- gráficos ----------
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        exdf = pd.DataFrame(rows)
        bb = exdf[exdf["config"].isin(present)] if len(present) >= 3 else exdf.head(0)
        if len(bb):
            bb = bb.sort_values("EX")
            err = [bb["EX"] - bb["ci_low"], bb["ci_high"] - bb["EX"]]
            plt.figure(figsize=(8, 4))
            plt.barh(bb["config"], bb["EX"], xerr=err, color="#4C72B0", capsize=4)
            plt.xlabel("Execution Accuracy (IC95%)"); plt.title("Backbones — EX no subset (200)")
            plt.tight_layout(); plt.savefig(os.path.join(args.outdir, "backbones_ex.png"), dpi=120)
            print(f"\nGráfico salvo: {os.path.join(args.outdir, 'backbones_ex.png')}")
    except Exception as e:
        print(f"\n[aviso] gráfico não gerado: {e}")

    print(f"\nConcluído. Tabelas/figuras em {args.outdir}/")


if __name__ == "__main__":
    main()
