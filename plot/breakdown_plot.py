from evacim import cim_acc_config as ccfg 
from evacim import nn_config as ncfg 
from evacim import sim
from evacim import sw_func
import matplotlib.pyplot as plt
import numpy as np
import palettable

cims_name = [
    "./cim_config/FPCIM@ISSCC23.cfg",
    "./cim_config/LCC-CIM@ISSCC20.cfg",
    ]

mappings = [
    "isap",
    "ispp",
]

glis = [
    ('proj', [512, 1024, 1024]),
    ('proj', [512, 4096, 1024]),
    ('proj', [512, 1024, 4096]),
]

cim = ccfg.CIM(cfgname = cims_name[1])

acc0 = ccfg.CIMACC(
    cim,
    bus_width = 25.6, 
    macro_row = 2, 
    macro_col = 2, 
    scr = 16, 
    is_size = 1024, 
    os_size = 128, 
    ) 
 
c = palettable.tableau.GreenOrange_12.hex_colors[2:7]
c = [c[0], c[2], c[1], c[3], "silver"]
c = [
    "salmon",
    "#6bbc6b",
    "orange",
    "skyblue",
    "silver",
]

fig, ax1 = plt.subplots(figsize=(7, 7), dpi = 1000)
# ax2 = ax1.twinx()
width = 0.5
dx = 0.1

for ig in range(len(glis)):


    m=[[] for i in range(2)]
    energy = np.zeros((2,5))

    for i in range(2):
        m[i] = sim.evaluate(acc0, glis[ig], mappings[i]) 
        energy[i,0] = m[i]['energy'][18, 0] + m[i]['energy'][18, 1] # IS
        energy[i,1] = m[i]['energy'][18, 4] + m[i]['energy'][18, 5] # OS
        energy[i,2] = m[i]['energy'][18, 2] + m[i]['energy'][18, 3] # CIM
        energy[i,3] = m[i]['energy_on_L2'] # EMA
        energy[i,4] = m[i]['energy'][18, 7] - energy[i,0] - energy[i,1] - energy[i,2] # Reg

    x = np.array([0+dx, 1-dx]) + ig*2
    bottom = np.zeros(2)
    for i in range(5):
        ax1.bar(x, energy[:, i], bottom=bottom, width = width, color=c[i])
        bottom += energy[:, i]
    # ax2.plot(x, [m[0]['latency'], m[1]['latency']], c='k', marker='^', markersize=12, linewidth=1.5, linestyle = '--')

ax1.grid(axis='y', linestyle='--', alpha=0.7)

# ax2.set_ylim((0,8e6))
# ax2.set_ylim((0,3e7))
plt.savefig("breakdown_cim1.png")
