"""
collect_results.py — Consolida as predições numa matriz de acerto/erro POR QUERY
(Execution Accuracy 0/1) para cada configuração, usando o avaliador OFICIAL
(eval_exec_match). É a base para a análise estatística (analyze.py).

Lê:
  - gold:      data/subset/dev_gold.sql   ("<SQL>\\t<db>" por linha)
  - manifest:  data/subset/manifest.csv   (orig_index, db_id, hardness, ...)
  - predições: results/*.sql              (1 SQL por linha, alinhado ao subset)

Saídas:
  - results/correctness_matrix.csv  (query_idx, db, hardness, <config1>, <config2>, ...)
  - imprime EX agregado por dificuldade (sanity check vs. eval_*.txt)

Uso:
  python src/collect_results.py                       # auto-descobre results/*.sql
  python src/collect_results.py results/pred_*.sql    # arquivos específicos
"""

import argparse
import csv
import glob
import os
import sys

SPIDER_DIR = "data/spider_data"
EVAL_DIR = "data/test-suite-sql-eval"
SUBSET_DIR = "data/subset"
LEVELS = ["easy", "medium", "hard", "extra"]


def load_evaluator():
    if not os.path.isdir(EVAL_DIR):
        sys.exit(f"[ERRO] avaliador não encontrado em {EVAL_DIR} (rode download_spider.sh).")
    sys.path.insert(0, EVAL_DIR)
    from exec_eval import eval_exec_match
    return eval_exec_match


def read_gold(path):
    rows = []
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line:
                sql, db = line.split("\t")
                rows.append((sql, db))
    return rows


def read_hardness(path):
    with open(path) as f:
        return [row["hardness"] for row in csv.DictReader(f)]


def config_name(path):
    b = os.path.basename(path)
    if b.endswith(".sql"):
        b = b[:-4]
    if b.startswith("pred_"):       # baseline/backbone -> nome do modelo
        b = b[len("pred_"):]
    return b


def main():
    ap = argparse.ArgumentParser(description="Matriz de acerto/erro por query (EX).")
    ap.add_argument("preds", nargs="*",
                    help="arquivos de predição (.sql); default: results/*.sql relevantes")
    ap.add_argument("--gold", default=os.path.join(SUBSET_DIR, "dev_gold.sql"))
    ap.add_argument("--manifest", default=os.path.join(SUBSET_DIR, "manifest.csv"))
    ap.add_argument("--db-dir", default=os.path.join(SPIDER_DIR, "database"))
    ap.add_argument("--out", default="results/correctness_matrix.csv")
    args = ap.parse_args()

    eval_exec_match = load_evaluator()
    gold = read_gold(args.gold)
    hardness = read_hardness(args.manifest)
    n = len(gold)
    if len(hardness) != n:
        sys.exit(f"[ERRO] manifest ({len(hardness)}) != gold ({n})")

    preds = args.preds or sorted(
        p for p in glob.glob("results/*.sql")
        if "_smoke" not in os.path.basename(p)
        and not os.path.basename(p).startswith("gold")
    )
    if not preds:
        sys.exit("[ERRO] nenhuma predição encontrada em results/")

    matrix, skipped = {}, []
    for pf in preds:
        cfg = config_name(pf)
        with open(pf) as f:
            plines = [l.rstrip("\n") for l in f]
        if len(plines) != n:
            skipped.append(f"{cfg} ({len(plines)}≠{n})")
            continue
        sys.stdout.write(f"avaliando {cfg} ...")
        sys.stdout.flush()
        ex = []
        for i in range(n):
            g_sql, db = gold[i]
            dbpath = os.path.join(args.db_dir, db, db + ".sqlite")
            try:
                score = eval_exec_match(db=dbpath, p_str=plines[i], g_str=g_sql,
                                        plug_value=False, keep_distinct=False,
                                        progress_bar_for_each_datapoint=False)
                ex.append(1 if score else 0)
            except Exception:
                ex.append(0)
        matrix[cfg] = ex
        print(f" EX(all)={sum(ex)/n:.3f}")

    if skipped:
        print(f"\n[aviso] pulados (linhas ≠ {n}, run parcial?): {', '.join(skipped)}")

    configs = sorted(matrix)
    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    with open(args.out, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["query_idx", "db", "hardness"] + configs)
        for i in range(n):
            w.writerow([i, gold[i][1], hardness[i]] + [matrix[c][i] for c in configs])
    print(f"\nMatriz salva: {args.out}  ({n} queries × {len(configs)} configs)")

    # --- EX agregado por dificuldade (sanity check vs eval_*.txt) ---
    print("\nEX por dificuldade (confira contra os eval_*.txt):")
    print("config".ljust(46) + "".join(l.ljust(8) for l in LEVELS) + "all")
    idx_by_level = {lv: [i for i in range(n) if hardness[i] == lv] for lv in LEVELS}
    for c in configs:
        line = c.ljust(46)
        for lv in LEVELS:
            idx = idx_by_level[lv]
            line += (f"{sum(matrix[c][i] for i in idx)/len(idx):.3f}" if idx else "-").ljust(8)
        line += f"{sum(matrix[c])/n:.3f}"
        print(line)


if __name__ == "__main__":
    main()
