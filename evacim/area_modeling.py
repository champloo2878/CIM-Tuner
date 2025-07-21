from evacim import cim_acc_config as cfg

#area: 0: fd_is, 1: fd_reg, 2: cims, 3: macros_reg, 4: gd_os, 5: gd_reg, 6: top_reg, 7:total_area;
# for FD.IS( width = 512 ), Area(depth) = 111.288 * depth + 114700.7
# for FD.REG, Area(AL) = 68.05828 * al + 1619.94

def area_modeling(acc0):

    area = [0 for i in range(8)]
    area[0] = acc0.macro_col * (111.288*acc0.IS_DEPTH + 114700.7)
    area[1] = acc0.AL * 68.05828 + 1619.94

    area[2] = (acc0.macro_col*acc0.macro_row) * acc0.cim.macro_area * (acc0.cim.memory_array_ratio * acc0.SCR / acc0.cim.initial_scr + 1 - acc0.cim.memory_array_ratio)

    area[3] = acc0.AL*acc0.PC * 1.290714 + 1622.281
    area[4] = acc0.macro_row * (55.680373377*acc0.OS_DEPTH + 115035.87042)
    area[5] = acc0.PC * 1076.61371 + 1581.7796
    area[6] = acc0.BUS_WIDTH_real * 5.50720922 + 1334.05853
    area[7] = area[0] + area[1] + area[2] + area[3] + area[4] + area[5] + area[6] + area[7] 
    return area 

if __name__ == "__main__":
    # acc0 = cfg.hwc(config = cfg.Config(bus_width = 128,
    #                                is_depth = 2,
    #                                al = 64,
    #                                pc = 8,
    #                                scr = 16,
    #                                os_depth = 4
    #                                ))

    bpcim = cfg.CIM("./cim_config/BPCIM.cfg")
    acc0 = cfg.CIMACC(
        bpcim,
        bus_width = 25.6, 
        macro_row = 2, 
        macro_col = 2, 
        scr = 16, 
        is_size = 64, 
        os_size = 96, 
        freq=500
    )

    for pri in area_modeling(acc0):
        print(pri)






