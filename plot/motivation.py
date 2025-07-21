from evacim import cim_acc_config as ccfg 
from evacim import nn_config as ncfg 
from evacim import sim
from evacim import sw_func
import matplotlib.pyplot as plt
import numpy as np

mapping1 = "isap"
mapping2 = "wsap"
df = mapping1

gli = ('proj', [512, 1024, 1024])
cim = ccfg.CIM("./cim_config/FPCIM@ISSCC23.cfg")
acc0 = ccfg.CIMACC(
    cim,
    bus_width = 25.6, 
    macro_row = 4, 
    macro_col = 2, 
    scr = 16, 
    is_size = 32, 
    os_size = 4, 
    ) 

acc1 = ccfg.CIMACC(
    cim,
    bus_width = 25.6, 
    macro_row = 2, 
    macro_col = 2, 
    scr = 16, 
    is_size = 512, 
    os_size = 256, 
    ) 

acc2 = ccfg.CIMACC(
    cim,
    bus_width = 25.6, 
    macro_row = 2, 
    macro_col = 1, 
    scr = 16, 
    is_size = 1024, 
    os_size = 256, 
    ) 

m0 = sim.evaluate(acc0, gli, df) 
m1 = sim.evaluate(acc1, gli, df) 
m2 = sim.evaluate(acc2, gli, df) 

df = mapping2

m3 = sim.evaluate(acc0, gli, df) 
m4 = sim.evaluate(acc1, gli, df) 
m5 = sim.evaluate(acc2, gli, df) 

# 提取每个acc的area breakdown（第0、2、4个元素）
area0 = [m0['area'][2], m0['area'][0], m0['area'][4]]
area1 = [m1['area'][2], m1['area'][0], m1['area'][4]]
area2 = [m2['area'][2], m2['area'][0], m2['area'][4]]

latency = [m0['latency'], m1['latency'], m2['latency']]
latency_2 = [m3['latency'], m4['latency'], m5['latency']]

areas = np.array([area0, area1, area2])  # shape: (3, 3)

labels = ['acc0', 'acc1', 'acc2']
parts = ['CIM Array', 'Input SRAM', 'Output SRAM']
x = np.array([0,1,2])
x_2 = np.array([3,4,5])

width = 0.5
color = ["silver","orange", "skyblue",]

fig, ax1 = plt.subplots(figsize=(7, 7), dpi = 1000)
bottom = np.zeros(len(labels))
for i in range(3):
    ax1.bar(x, areas[:, i], bottom=bottom, label=parts[i], width = width, color = color[i])
    bottom += areas[:, i]

bottom_2 = np.zeros(len(labels))
for i in range(3):
    ax1.bar(x_2, areas[:, i], bottom=bottom_2, label=parts[i], width = width, color = color[i])
    bottom_2 += areas[:, i]

ax2=ax1.twinx()
ax2.set_ylim([0, 6e6])
# ax1.set_ylim([0, 5e6])

ax2.plot(x, latency, c='k', marker='^', markersize=12, linewidth=1.5, linestyle = '--')

ax2.plot(x_2, latency_2, c='k', marker='^', markersize=12, linewidth=1.5, linestyle = '--')
ax2.grid(axis='y', linestyle='--', alpha=0.7)


plt.savefig("testmt.png")
print(m0['latency'], m1['latency'], m2['latency'])
print(m0['area'][7], m1['area'][7], m2['area'][7])

