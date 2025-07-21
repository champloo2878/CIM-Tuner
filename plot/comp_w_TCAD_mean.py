import matplotlib.pyplot as plt
import numpy as np

metrics = ['ee','tt']
networks = [
    'bert_base_sl64',
    'bert_base_sl512',
    'bert_large_sl64',
    'bert_large_sl512',
    'gpt2_large_sl8',
    'vit_large_sl197'
]

macros = [
    'FPCIM@ISSCC23',
    'LCC-CIM@ISSCC20',
]

best_fix = {metric: {macro: [] for macro in macros} for metric in metrics}
area_fix = {metric: {macro: [] for macro in macros} for metric in metrics}
best = {metric: {macro: [] for macro in macros} for metric in metrics}
area = {metric: {macro: [] for macro in macros} for metric in metrics}
for metric in metrics:
    for macro in macros:
        for nn in networks:
            log_fix = f"./Result/{metric}{nn}_{macro}_fix.log"
            log = f"./Result/{metric}{nn}_{macro}.log"
            with open(log_fix, 'r') as f:
                for line in f:
                    if line.startswith("best="):
                        parts = line.strip().split(',')
                        best_fix[metric][macro].append(float(parts[0].split('=')[1]))
                        area_fix[metric][macro].append(float(parts[1].split('=')[1]))

            with open(log, 'r') as f:
                for line in f:
                    if line.startswith("best="):
                        parts = line.strip().split(',')
                        best[metric][macro].append(float(parts[0].split('=')[1]))
                        area[metric][macro].append(float(parts[1].split('=')[1]))

for metric in metrics:
    print(f"Metric: {metric}")
    all_best = []
    all_best_fix = []
    for macro in macros:
        best_arr = np.array(best[metric][macro])
        best_fix_arr = np.array(best_fix[metric][macro])
        mean_best = np.mean(best_arr)
        mean_best_fix = np.mean(best_fix_arr)
        speedup = mean_best / mean_best_fix if mean_best_fix != 0 else float('inf')
        print(f"  Macro: {macro}, mean_best {mean_best:.4f}, mean_best_fix {mean_best_fix:.4f}, speedup {speedup:.4f}")
        all_best.append(best_arr)
        all_best_fix.append(best_fix_arr)
    all_best = np.concatenate(all_best)
    all_best_fix = np.concatenate(all_best_fix)
    mean_all_best = np.mean(all_best)
    mean_all_best_fix = np.mean(all_best_fix)
    speedup_all = mean_all_best / mean_all_best_fix if mean_all_best_fix != 0 else float('inf')
    print(f"  Overall mean_best {mean_all_best:.4f}, mean_best_fix {mean_all_best_fix:.4f}, speedup {speedup_all:.4f}")



