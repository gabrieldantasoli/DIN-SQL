"""
build_subset.py — Gera o subset estratificado de 200 queries do Spider dev.

Estratificação por dificuldade usando o classificador OFICIAL do Spider
(`Evaluator.eval_hardness`), os mesmos rótulos do paper. Amostragem
determinística (seed=42), conforme o plano:

    easy=70, medium=70, hard=35, extra=25   (total=200)

Saídas (em --out-dir, default data/subset/):
    dev.json            -> os 200 exemplos (formato idêntico ao dev.json original)
    dev_gold.sql        -> 200 linhas "<SQL>\\t<db_id>" alinhadas ao dev.json
    tables.json         -> cópia (o din_sql.py espera tables.json no dir do dataset)
    manifest.csv        -> orig_index, db_id, hardness, question, gold_sql (rastreio)

A ordem do subset é a dos índices originais em ordem crescente (determinística),
para que a saída do din_sql.py fique alinhada linha-a-linha com dev_gold.sql.

Uso:
    python src/build_subset.py
    python src/build_subset.py --spider-dir data/spider_data --out-dir data/subset
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import random
import shutil
import sys

# Plano de amostragem (estratos -> n)
PLAN = {"easy": 70, "medium": 70, "hard": 35, "extra": 25}
SEED = 42


def _import_evaluator(eval_dir: str):
    """Importa get_schema/Schema/get_sql/Evaluator do test-suite-sql-eval."""
    if not os.path.isdir(eval_dir):
        sys.exit(f"[ERRO] avaliador não encontrado em {eval_dir} "
                 f"(rode download_spider.sh).")
    sys.path.insert(0, eval_dir)
    from process_sql import get_schema, Schema, get_sql      # noqa: E402
    from evaluation import Evaluator                          # noqa: E402
    return get_schema, Schema, get_sql, Evaluator


def main():
    ap = argparse.ArgumentParser(description="Gera subset estratificado do Spider dev.")
    ap.add_argument("--spider-dir", default="data/spider_data",
                    help="dir com dev.json, dev_gold.sql, tables.json, database/")
    ap.add_argument("--eval-dir", default="data/test-suite-sql-eval",
                    help="dir do avaliador oficial (classificador de dificuldade)")
    ap.add_argument("--out-dir", default="data/subset")
    ap.add_argument("--seed", type=int, default=SEED)
    args = ap.parse_args()

    dev_json = os.path.join(args.spider_dir, "dev.json")
    gold_sql = os.path.join(args.spider_dir, "dev_gold.sql")
    tables = os.path.join(args.spider_dir, "tables.json")
    db_root = os.path.join(args.spider_dir, "database")
    for p in (dev_json, gold_sql, tables, db_root):
        if not os.path.exists(p):
            sys.exit(f"[ERRO] não encontrei {p} (rode download_spider.sh).")

    get_schema, Schema, get_sql, Evaluator = _import_evaluator(args.eval_dir)
    evaluator = Evaluator()

    # --- carrega dev.json e dev_gold.sql, conferindo alinhamento ---
    with open(dev_json) as f:
        dev = json.load(f)
    with open(gold_sql) as f:
        gold_lines = [l.strip() for l in f if l.strip()]
    if len(dev) != len(gold_lines):
        sys.exit(f"[ERRO] dev.json ({len(dev)}) e dev_gold.sql ({len(gold_lines)}) "
                 f"têm tamanhos diferentes.")

    # --- classifica dificuldade de cada query (cache de schema por db) ---
    schema_cache = {}
    by_level = {k: [] for k in PLAN}
    failures = []
    for i, (ex, gl) in enumerate(zip(dev, gold_lines)):
        g_str, db = gl.split("\t")
        if ex["db_id"] != db:
            sys.exit(f"[ERRO] desalinhamento na linha {i}: dev db_id={ex['db_id']} "
                     f"vs gold db={db}")
        try:
            if db not in schema_cache:
                schema_cache[db] = Schema(get_schema(
                    os.path.join(db_root, db, db + ".sqlite")))
            sql = get_sql(schema_cache[db], g_str)
            level = evaluator.eval_hardness(sql)
        except Exception as e:
            failures.append((i, db, str(e)))
            continue
        if level in by_level:
            by_level[level].append(i)

    print("Distribuição de dificuldade no dev completo:")
    for lvl in ("easy", "medium", "hard", "extra"):
        print(f"    {lvl:<7}: {len(by_level[lvl])}")
    if failures:
        print(f"  ! {len(failures)} queries não puderam ser parseadas (ignoradas).")

    # --- amostragem estratificada determinística ---
    rng = random.Random(args.seed)
    selected = []
    for lvl, n in PLAN.items():
        pool = sorted(by_level[lvl])  # ordem fixa antes de amostrar
        if len(pool) < n:
            sys.exit(f"[ERRO] estrato '{lvl}' tem só {len(pool)} queries (<{n}).")
        selected.extend(rng.sample(pool, n))
    selected = sorted(selected)  # ordem canônica do subset = índice original crescente

    # --- escreve as saídas ---
    os.makedirs(args.out_dir, exist_ok=True)
    sub_dev = [dev[i] for i in selected]
    with open(os.path.join(args.out_dir, "dev.json"), "w") as f:
        json.dump(sub_dev, f, indent=2, ensure_ascii=False)
    with open(os.path.join(args.out_dir, "dev_gold.sql"), "w") as f:
        for i in selected:
            f.write(gold_lines[i] + "\n")
    shutil.copyfile(tables, os.path.join(args.out_dir, "tables.json"))

    # manifest + hash de reprodutibilidade
    level_of = {i: lvl for lvl in by_level for i in by_level[lvl]}
    with open(os.path.join(args.out_dir, "manifest.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["orig_index", "db_id", "hardness", "question", "gold_sql"])
        for i in selected:
            g_str, db = gold_lines[i].split("\t")
            w.writerow([i, db, level_of.get(i, "?"), dev[i]["question"], g_str])

    digest = hashlib.sha256(
        ",".join(map(str, selected)).encode()).hexdigest()[:16]
    counts = {lvl: sum(1 for i in selected if level_of.get(i) == lvl) for lvl in PLAN}
    print(f"\nSubset gerado em {args.out_dir}/  ({len(selected)} queries)")
    print(f"    composição: {counts}")
    print(f"    seed={args.seed}  sha256(indices)[:16]={digest}")
    print(f"    -> dev.json, dev_gold.sql, tables.json, manifest.csv")


if __name__ == "__main__":
    main()
