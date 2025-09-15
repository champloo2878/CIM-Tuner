import math as m
from random import random, seed
import matplotlib.pyplot as plt
from evacim import cim_acc_config as ccfg
from evacim import nn_config as ncfg
from evacim import area_modeling

from evacim.sw_func import get_random_bool, func_cima, func_model, func_model_fix_dataflow

from experiments.cim_sa_model import SimulateAnnealing_CIMACC_on_model

flist = "resnet_18"


macro = [
    'FPCIM@ISSCC23',
    'LCC-CIM@ISSCC20',
]

ee=True
tt=True

for mac in macro:
    model = ncfg.NN("./nn_config/"+flist+".csv") 
    cim = ccfg.CIM("./cim_config/"+mac+".cfg")
    acc_trancim = ccfg.CIMACC(
        cim,
        bus_width = 25.6, 
        macro_row = 3, 
        macro_col = 1, 
        scr = 1, 
        is_size = 64, 
        os_size = 128, 
        ) 

    seed(2)
    if ee:
        sa1 = SimulateAnnealing_CIMACC_on_model(
            func_model_fix_dataflow, 
            acc_trancim, 
            model,
            opt_target = 'ee_L2', 
            iter=5, 
            Tf=1, 
            alpha=0.99,
            epoch = 1, 
        )
        sa2 = SimulateAnnealing_CIMACC_on_model(
            func_model, 
            acc_trancim, 
            model,
            opt_target = 'ee_L2', 
            iter=5, 
            Tf=1, 
            alpha=0.99,
            epoch = 1, 
        )

        import time
        sa1.run(write_log=True, logname="./Result/ee"+flist+"_"+mac+"_fix.log")
        print(f"{flist}_{mac}_ee_running start at {time.time()}", flush=True)
        sa2.run(write_log=True, logname="./Result/ee"+flist+"_"+mac+".log")
        print(f"{flist}_{mac}_ee_running end at {time.time()}", flush=True)

    if tt:
        sa3 = SimulateAnnealing_CIMACC_on_model(
            func_model_fix_dataflow, 
            acc_trancim, 
            model,
            opt_target = 'throughput', 
            iter=5, 
            Tf=1, 
            alpha=0.99,
            epoch = 1, 
        )
        sa4 = SimulateAnnealing_CIMACC_on_model(
            func_model, 
            acc_trancim, 
            model,
            opt_target = 'throughput', 
            iter=5, 
            Tf=1, 
            alpha=0.99,
            epoch = 1, 
        )

        sa3.run(write_log=True, logname="./Result/tt"+flist+"_"+mac+"_fix.log")
        print(f"{flist}_{mac}_tt_running start at {time.time()}", flush=True)
        sa4.run(write_log=True, logname="./Result/tt"+flist+"_"+mac+".log")   
        print(f"{flist}_{mac}_tt_running end at {time.time()}", flush=True)


