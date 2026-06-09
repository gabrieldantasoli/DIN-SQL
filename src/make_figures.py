"""
make_figures.py — Gera as figuras da análise a partir dos results/eval_*.txt
(EX/EM por dificuldade). Não precisa da matriz por-query nem de GPU.

Saídas em results/figures/:
  fig1_backbones_ex.png         EX(all) dos backbones + IC95% (Wilson) + linha do paper
  fig2_backbones_dificuldade.png EX por dificuldade (linhas, 1 por backbone)
  fig3_backbones_ex_em.png      EX vs EM por backbone (gap in-context)
  fig4_ablation_ex.png          EX(all) full vs variantes (com Δ)
  fig5_ablation_dificuldade.png EX por dificuldade (full vs variantes)
  fig6_robustez_temperatura.png EX por temperatura (média±desvio + reps)
  fig7_qwen_vs_paper.png        Qwen vs GPT-4 (paper) por dificuldade

Uso: python src/make_figures.py
"""

import glob
import math
import os
import re

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

RESULTS = "results"
OUTDIR = os.path.join(RESULTS, "figures")
LEVELS = ["easy", "medium", "hard", "extra"]
N_SUBSET = 200

# Referência do paper (DIN-SQL + GPT-4, Spider dev) — Tabelas 4a/4b
PAPER_EX = {"easy": 0.911, "medium": 0.798, "hard": 0.649, "extra": 0.434, "all": 0.742}
PAPER_EM_ALL = 0.601

NICE = {
    "Qwen2.5-Coder-7B-Instruct": "Qwen2.5-Coder-7B",
    "deepseek-coder-6.7b-instruct": "DeepSeek-Coder-6.7B",
    "Yi-Coder-9B-Chat": "Yi-Coder-9B",
    "granite-8b-code-instruct-128k": "Granite-8B-code",
    "Phi-3.5-mini-instruct": "Phi-3.5-mini",
}
BACKBONES = list(NICE.keys())


def parse_eval(path):
    """Extrai {metric: {level: val}} de um eval_*.txt."""
    txt = open(path).read()
    out = {}
    for metric, key in [("execution", "EX"), ("exact match", "EM")]:
        m = re.search(rf"^{metric}\s+([\d.\s]+)$", txt, re.MULTILINE)
        if m:
            vals = [float(x) for x in m.group(1).split()]
            if len(vals) >= 5:
                out[key] = dict(zip(LEVELS + ["all"], vals[:5]))
    return out


def cfg_from_path(p):
    b = os.path.basename(p)[len("eval_"):-len(".txt")]
    return b


def wilson_ci(p, n, z=1.96):
    denom = 1 + z * z / n
    center = (p + z * z / (2 * n)) / denom
    half = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / denom
    return center - half, center + half


def load_all():
    data = {}
    for p in glob.glob(os.path.join(RESULTS, "eval_*.txt")):
        if "_smoke" in os.path.basename(p):
            continue
        d = parse_eval(p)
        if d:
            data[cfg_from_path(p)] = d
    return data


def main():
    os.makedirs(OUTDIR, exist_ok=True)
    data = load_all()
    plt.rcParams.update({"figure.dpi": 120, "font.size": 10, "axes.grid": True,
                         "grid.alpha": 0.3})

    backs = [b for b in BACKBONES if b in data]

    # ---- Fig 1: backbones EX(all) + IC95% Wilson + paper ----
    if backs:
        vals = [(NICE[b], data[b]["EX"]["all"]) for b in backs]
        vals.sort(key=lambda x: x[1])
        names = [v[0] for v in vals]; ex = [v[1] for v in vals]
        cis = [wilson_ci(p, N_SUBSET) for p in ex]
        err = [[p - lo for p, (lo, hi) in zip(ex, cis)],
               [hi - p for p, (lo, hi) in zip(ex, cis)]]
        plt.figure(figsize=(8, 4.2))
        plt.barh(names, ex, xerr=err, capsize=4, color="#4C72B0")
        plt.axvline(PAPER_EX["all"], ls="--", color="crimson",
                    label=f"GPT-4 (paper) = {PAPER_EX['all']:.3f}")
        for i, p in enumerate(ex):
            plt.text(p + 0.005, i, f"{p:.3f}", va="center", fontsize=9)
        plt.xlabel("Execution Accuracy (IC95% Wilson)"); plt.xlim(0, 1)
        plt.title("Backbones — EX no subset (200 queries)")
        plt.legend(loc="lower right"); plt.tight_layout()
        plt.savefig(os.path.join(OUTDIR, "fig1_backbones_ex.png")); plt.close()

        # ---- Fig 2: EX por dificuldade (linhas) ----
        plt.figure(figsize=(8, 4.8))
        x = range(len(LEVELS))
        for b in backs:
            y = [data[b]["EX"][lv] for lv in LEVELS]
            plt.plot(x, y, marker="o", label=NICE[b])
        plt.plot(x, [PAPER_EX[lv] for lv in LEVELS], marker="s", ls="--",
                 color="black", label="GPT-4 (paper)")
        plt.xticks(list(x), LEVELS); plt.ylim(0.3, 1.0)
        plt.ylabel("Execution Accuracy"); plt.xlabel("Dificuldade")
        plt.title("EX por dificuldade — backbones vs. paper")
        plt.legend(fontsize=8); plt.tight_layout()
        plt.savefig(os.path.join(OUTDIR, "fig2_backbones_dificuldade.png")); plt.close()

        # ---- Fig 3: EX vs EM por backbone ----
        order = sorted(backs, key=lambda b: data[b]["EX"]["all"], reverse=True)
        x = np.arange(len(order)); w = 0.38
        plt.figure(figsize=(8.5, 4.2))
        plt.bar(x - w/2, [data[b]["EX"]["all"] for b in order], w, label="EX", color="#4C72B0")
        plt.bar(x + w/2, [data[b]["EM"]["all"] for b in order], w, label="EM", color="#DD8452")
        plt.xticks(x, [NICE[b] for b in order], rotation=20, ha="right")
        plt.ylabel("Acurácia (all)"); plt.ylim(0, 1)
        plt.title("EX vs EM por backbone (gap do in-context)")
        plt.legend(); plt.tight_layout()
        plt.savefig(os.path.join(OUTDIR, "fig3_backbones_ex_em.png")); plt.close()

        # ---- Fig 7: Qwen vs paper por dificuldade ----
        qwen = "Qwen2.5-Coder-7B-Instruct"
        if qwen in data:
            x = np.arange(len(LEVELS)); w = 0.38
            plt.figure(figsize=(7.5, 4.2))
            plt.bar(x - w/2, [data[qwen]["EX"][lv] for lv in LEVELS], w,
                    label="Qwen2.5-Coder-7B (local)", color="#4C72B0")
            plt.bar(x + w/2, [PAPER_EX[lv] for lv in LEVELS], w,
                    label="GPT-4 (paper)", color="crimson")
            plt.xticks(x, LEVELS); plt.ylabel("Execution Accuracy"); plt.ylim(0, 1)
            plt.title("Qwen2.5-Coder-7B local vs. GPT-4 do paper")
            plt.legend(); plt.tight_layout()
            plt.savefig(os.path.join(OUTDIR, "fig7_qwen_vs_paper.png")); plt.close()

    # ---- Ablation ----
    full = "Qwen2.5-Coder-7B-Instruct"
    abl = {c: data[c] for c in data if c.startswith("abl_Qwen")}
    if full in data and abl:
        labels_map = {"no_selfcorr": "sem self-corr", "no_schemalink": "sem schema-link",
                      "fewshot": "few-shot (force easy)", "cot": "CoT (force nested)"}
        items = [("full", data[full]["EX"]["all"])]
        for c in sorted(abl):
            tag = c.split("_", 2)[-1]
            items.append((labels_map.get(tag, tag), abl[c]["EX"]["all"]))
        names = [i[0] for i in items]; ex = [i[1] for i in items]
        colors = ["#55A868"] + ["#4C72B0"] * (len(items) - 1)
        plt.figure(figsize=(8, 4.2))
        bars = plt.bar(names, ex, color=colors)
        full_ex = data[full]["EX"]["all"]
        plt.axhline(full_ex, ls="--", color="#55A868", alpha=0.7)
        for i, (nm, p) in enumerate(items):
            d = p - full_ex
            txt = f"{p:.3f}" + (f"\nΔ={d:+.3f}" if nm != "full" else "")
            plt.text(i, p + 0.01, txt, ha="center", fontsize=8)
        plt.xticks(rotation=20, ha="right"); plt.ylabel("Execution Accuracy"); plt.ylim(0, 1)
        plt.title("Ablation (Qwen2.5-Coder-7B) — EX vs. configuração")
        plt.tight_layout(); plt.savefig(os.path.join(OUTDIR, "fig4_ablation_ex.png")); plt.close()

        # ---- Fig 5: ablation por dificuldade ----
        plt.figure(figsize=(8, 4.8))
        x = range(len(LEVELS))
        plt.plot(x, [data[full]["EX"][lv] for lv in LEVELS], marker="o", lw=2.5,
                 color="#55A868", label="full")
        for c in sorted(abl):
            tag = c.split("_", 2)[-1]
            plt.plot(x, [abl[c]["EX"][lv] for lv in LEVELS], marker="o",
                     label=labels_map.get(tag, tag))
        plt.xticks(list(x), LEVELS); plt.ylim(0.3, 1.0)
        plt.ylabel("Execution Accuracy"); plt.xlabel("Dificuldade")
        plt.title("Ablation — EX por dificuldade")
        plt.legend(fontsize=8); plt.tight_layout()
        plt.savefig(os.path.join(OUTDIR, "fig5_ablation_dificuldade.png")); plt.close()

    # ---- Fig 6: robustez por temperatura ----
    rob = {}
    for c in data:
        m = re.match(r"robust_.*_T([\d.]+)_r(\d+)$", c)
        if m:
            rob.setdefault(float(m.group(1)), []).append(data[c]["EX"]["all"])
    if rob:
        temps = sorted(rob)
        means = [np.mean(rob[t]) for t in temps]
        stds = [np.std(rob[t], ddof=1) if len(rob[t]) > 1 else 0 for t in temps]
        plt.figure(figsize=(7, 4.4))
        plt.errorbar(temps, means, yerr=stds, fmt="-o", capsize=5, lw=2,
                     color="#4C72B0", label="média ± desvio")
        for t in temps:                       # pontos individuais das repetições
            plt.scatter([t] * len(rob[t]), rob[t], color="#C44E52", alpha=0.6, zorder=3,
                        label="repetições" if t == temps[0] else None)
        plt.xlabel("Temperatura"); plt.ylabel("Execution Accuracy (all)")
        plt.title("Robustez à temperatura (Qwen2.5-Coder-7B, N=5)")
        plt.legend(); plt.tight_layout()
        plt.savefig(os.path.join(OUTDIR, "fig6_robustez_temperatura.png")); plt.close()

    figs = sorted(os.listdir(OUTDIR))
    print(f"Figuras geradas em {OUTDIR}/ ({len(figs)}):")
    for f in figs:
        print("  -", f)


if __name__ == "__main__":
    main()
