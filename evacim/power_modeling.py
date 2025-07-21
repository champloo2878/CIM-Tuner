import numpy as np
import pickle as pk
from evacim import cim_acc_config as cfg

# mW
# 0: fd_is, 1: fd_reg, 2: cims, 3: macros_reg, 4: gd_os, 5: gd_reg, 6: top_reg, 7:total;

def power_modeling(acc0):

    instructions = [
            "Lin", # 0
            "Linp", # 1
            "Lwt", # 2
            "Lwtp", # 3
            "Cmpfis_aor", # 4
            "Cmpfis_tos", # 5
            "Cmpfis_aos", # 6
            "Cmpfis_ptos", # 7
            "Cmpfis_paos", # 8 
            "Cmpfgt_aor", # 9   
            "Cmpfgt_tos", # 10
            "Cmpfgt_aos", # 11
            "Cmpfgt_ptos", # 12
            "Cmpfgt_paos", # 13
            "Cmpfgtp", # 14
            "Lpenalty", # 15
            "Nop", # 16
            "Nop_w_rd" # 17
            ]

    power = np.zeros((18,8))

    for i in range(18):
        with open("./evacim/power_paras/"+instructions[i]+".pk","rb") as pkf:
            kbs = pk.load(pkf)
            # fd.is
            power[i][0] = (acc0.AL/64)*(acc0.IS_DEPTH*kbs[0][0] + kbs[0][2])
            # fd.reg 
            power[i][1] = acc0.BUS_WIDTH_real*kbs[1][0] + acc0.AL*kbs[1][1] + kbs[1][2]

            # cims
            if i == 2: # weight update
                power[i][2] = acc0.macro_col * acc0.cim.write_onerow_power + acc0.macro_col*(acc0.macro_row-1) * acc0.cim.static_power
            elif i >= 4 and i <= 13: # compute
                power[i][2] = acc0.macro_col*acc0.macro_row * acc0.cim.compute_allbank_power
            else: # cim static
                power[i][2] = acc0.macro_col*acc0.macro_row * acc0.cim.compute_allbank_power

            # cim_reg
            power[i][3] = acc0.AL*kbs[3][0] + acc0.PC*kbs[3][1] + kbs[3][2]
            # gd_os
            power[i][4] = (acc0.PC/8)*(acc0.OS_DEPTH*kbs[4][0] + kbs[4][2])
            # gd_reg
            power[i][5] = acc0.PC*kbs[5][0] + acc0.BUS_WIDTH_real*kbs[5][1] + kbs[5][2]
            # top_reg
            power[i][6] = acc0.BUS_WIDTH_real*kbs[6][0] + kbs[6][2]
            power[i][7] = power[i][0] + power[i][1] + power[i][2] + power[i][3] + power[i][4] + power[i][5] + power[i][6]

    return power



if __name__ == "__main__":
    bpcim = cfg.CIM("./cim_config/BPCIM.cfg")
    acc0 = cfg.CIMACC(
        bpcim,
        bus_width = 25.6, 
        macro_row = 2, 
        macro_col = 2, 
        scr = 16, 
        is_size = 64, 
        os_size = 64, 
        freq=500
    )

    cnt = 0
    print(power_modeling(acc0))

