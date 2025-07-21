import matplotlib.pyplot as plt
import numpy as np

metrics = ['ee','tt']
networks = [
    'bert_base_sl64',
    'bert_base_sl512',
    'bert_large_sl64',
    'bert_large_sl512',
    'vit_large_sl197',
    'gpt2_large_sl8',
]

macros = [
    'FPCIM@ISSCC23',
    'LCC-CIM@ISSCC20',
]

mean_best_fix = [2.1523, 649.7416]
mean_best = [3.3626, 1375.2998]

best_fix = {metric: {macro: [] for macro in macros} for metric in metrics}
area_fix = {metric: {macro: [] for macro in macros} for metric in metrics}
best = {metric: {macro: [] for macro in macros} for metric in metrics}
area = {metric: {macro: [] for macro in macros} for metric in metrics}
for metric in metrics:
    for macro in macros:
        for nn in networks:
            log_fix = f"./Result/1_compare/{metric}{nn}_{macro}_fix.log"
            log = f"./Result/1_compare/{metric}{nn}_{macro}.log"
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

x = np.arange(len(networks))
dbx = np.arange(len(networks)*2)
width = 0.3
group_width = width * 3 
dbnetwork = networks+networks

fig, axes = plt.subplots(1, 2, figsize=(25, 5), sharey=False, dpi=1000)
for idx, metric in enumerate(metrics):
    ax = axes[idx]
    ax2 = ax.twinx() 
    for i, macro in enumerate(macros):
        pos = x + 6*i
        ax.bar(pos - width/2, best_fix[metric][macro], width, label=f"{macro}_SO", alpha=0.7)
        ax.bar(pos + width/2, best[metric][macro], width, label=f"{macro}_ST", alpha=0.7, hatch='//')
        ax2.scatter(pos - width/2, area_fix[metric][macro], s=50, color='k', marker='^', label=f"{macro}_SO_area" if i==0 else "", zorder=5, alpha = 0.7)
        
        area_fusion = np.arange(len(networks)*2)
        pos_fusion = [i for i in range(len(networks)*2)]
        for fi in range(len(networks)*2):
            if fi%2 == 0:
                area_fusion[fi] = area_fix[metric][macro][int(np.floor(fi/2))]
                pos_fusion[fi] = float(pos[int(np.floor(fi/2))]) - width/2
                print(pos_fusion[fi])
            else:
                area_fusion[fi] = area[metric][macro][int(np.floor(fi/2))]
                pos_fusion[fi] = pos[int(np.floor(fi/2))] + width/2

        ax2.plot(pos_fusion, area_fusion, linestyle = '--', color='grey', alpha = 0.7)
        ax2.scatter(pos + width/2, area[metric][macro], s=50, color='k', marker='^', label=f"{macro}_ST_area" if i==0 else "", zorder=5, alpha = 0.7)
    
    ax.bar(12 - width/2, mean_best_fix[idx], width, color = "#696969")
    ax.bar(12 + width/2, mean_best[idx], width, hatch = '//', color = '#b7b7b7')

    ax.set_xticks(dbx)
    ax.set_xticklabels(dbnetwork, rotation=30)
    ax.set_title(f"{metric}")
    ax.set_ylabel("best")
    ax.grid(axis='y', linestyle='--', alpha=0.5)
    if idx == 0:
        ax.legend(prop={'size': 12}, loc='upper right')
    ax2.set_ylabel("area", color='gray')
    ax2.set_ylim((0,1e7))

plt.tight_layout()
plt.savefig("testcpT.png")


