from evacim import cim_acc_config as ccfg 
from evacim import nn_config as ncfg 
from evacim import sim
from evacim.sw_func import func_model

from random import seed
from experiments.cim_sa_model import SimulateAnnealing_CIMACC_on_model

model = ncfg.NN("./nn_config/bert_large_sl512.csv") 
cim = ccfg.CIM("./cim_config/Sticker-IM@ISSCC21.cfg")
acc0 = ccfg.CIMACC(
    cim,
    bus_width = 25.6, 
    macro_row = 1, 
    macro_col = 4, 
    scr = 8, 
    is_size = 64, 
    os_size = 32, 
    ) 

ee, df_ee, area_ee = func_model(acc0, model, 'ee_L2')
tt, df_tt, area_tt = func_model(acc0, model, 'throughput')

assert area_ee == area_tt, f"## bu dui ##"

seed(3)
print("initial metric:")
print("ee: ", -ee, " TOPS/W")
print("tt: ", -tt, " GOPS")
print("area: ", area_ee)


# modify the area const.

sa1 = SimulateAnnealing_CIMACC_on_model(
    func_model, 
    acc0, 
    model,
    opt_target = 'ee_L2',
    area_const=area_ee,
    iter=5, 
    Tf=1, 
    alpha=0.99,
    epoch = 1, 
)

sa2 = SimulateAnnealing_CIMACC_on_model(
    func_model, 
    acc0, 
    model,
    opt_target = 'throughput',
    area_const=area_ee, 
    iter=5, 
    Tf=1, 
    alpha=0.99,
    epoch = 1, 
)

sa1.run(write_log=True, logname="./Result/StickerIM_ee.log")
sa2.run(write_log=True, logname="./Result/StickerIM_tt.log")

print("initial metric:")
print("ee: ", -ee, " TOPS/W")
print("tt: ", -tt, " GOPS")
print("area: ", area_ee)








