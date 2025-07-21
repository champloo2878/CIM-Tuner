from evacim import cim_acc_config as ccfg 
from evacim import nn_config as ncfg 
from evacim import sim
from evacim.sw_func import func_model

from random import seed
from experiments.cim_sa_model import SimulateAnnealing_CIMACC_on_model

model = ncfg.NN("./nn_config/bert_large_sl512.csv") 
cim = ccfg.CIM("./cim_config/TranCIM@ISSCC22.cfg")
acc0 = ccfg.CIMACC(
    cim,
    bus_width = 51.2, 
    macro_row = 3, 
    macro_col = 1, 
    scr = 1,
    is_size = 64, 
    os_size = 128, 
    ) 

ee, df_ee, area_ee = func_model(acc0, model, 'ee_L2')
tt, df_tt, area_tt = func_model(acc0, model, 'throughput')

run_sa = False   
plot_opt = True   

assert area_ee == area_tt, f"## bu dui ##"

seed(44)

print("initial metric:")
print("ee: ", -ee, " TOPS/W")
print("tt: ", -tt, " GOPS")
print("area: ", area_ee)

if run_sa == True:
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
        epoch = 5, 
    )

    sa1.run(write_log=True, logname="./Result/TranCIM_ee.log")
    sa2.run(write_log=True, logname="./Result/TranCIM_tt.log")

    print("initial metric:")
    print("ee: ", -ee, " TOPS/W")
    print("tt: ", -tt, " GOPS")
    print("area: ", area_ee)


if plot_opt == True:
    acc1 = ccfg.CIMACC(
        cim,
        bus_width = 51.2, 
        macro_row = 2, 
        macro_col = 1, 
        scr = 16,
        is_size = 4, 
        os_size = 64, 
        )
    
    ee, df_ee, area_ee = func_model(acc1, model, 'ee_L2')
    tt, df_tt, area_tt = func_model(acc1, model, 'throughput')
    
    print("ee opt metric:")
    print("ee: ", -ee, " TOPS/W")
    print("tt: ", -tt, " GOPS")
    print("area: ", area_ee)
    
    acc2 = ccfg.CIMACC(
        cim,
        bus_width = 51.2, 
        macro_row = 3, 
        macro_col = 1, 
        scr = 2,
        is_size = 2, 
        os_size = 32, 
        )
    
    ee, df_ee, area_ee = func_model(acc2, model, 'ee_L2')
    tt, df_tt, area_tt = func_model(acc2, model, 'throughput')
    
    print("tt opt metric:")
    print("ee: ", -ee, " TOPS/W")
    print("tt: ", -tt, " GOPS")
    print("area: ", area_ee)
    







