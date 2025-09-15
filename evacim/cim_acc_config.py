import configparser

class CIM:
    def __init__(
        self, 
        cfgname = "./cim_config/BPCIM.cfg",
    ):
        config = configparser.ConfigParser()        
        config.read(cfgname)

        self.name = config['name']['cim_name']

        # data precision
        self.data_width_input = int(config['data precision']['data_width_input'])
        self.data_width_weight = int(config['data precision']['data_width_weight'])
        self.data_width_output = int(config['data precision']['data_width_output'])

        # arch paras
        self.single_macro_al = int(config['arch paras']['single_macro_al'])
        self.single_macro_pc = int(config['arch paras']['single_macro_pc'])
        self.initial_scr = int(config['arch paras']['initial_scr'])
        self.input_compute_bw = int(config['arch paras']['input_compute_bw'])
        self.weight_update_bw = int(config['arch paras']['weight_update_bw'])
        self.pingpong = bool(config['arch paras']['simultaneously_write_compute'])
        self.freq = int(config['arch paras']['frequency']) 

        self.ee = float(config['energy_efficiency TOPS/W']['energy_efficiency'])

        self.cim_cap = self.single_macro_al *self.single_macro_pc * self.initial_scr * self.data_width_weight /1024 /8 # kB

        # compute power mW
        op_every_cycle = self.single_macro_pc * 2 * self.input_compute_bw / self.data_width_input
        compute_energy_per_cycle = op_every_cycle / self.ee

        self.compute_allbank_power = compute_energy_per_cycle * self.freq / 1000
        
        # static power 
        self.static_power = 1.4372

        # write power mW
        write_bit_energy = 0.27
        self.write_onerow_power = write_bit_energy * self.weight_update_bw *self.freq / 1000    

        # area um^2
        self.macro_area = float(config['area um^2']['macro_area'])
        
        sram_6T_area_8kB = 21015
        self.memory_array_ratio = self.cim_cap / 8 * sram_6T_area_8kB / self.macro_area
        

class CIMACC:
    def __init__(
        self,
        cim,
        bus_width = 25.6, # GBps 
        macro_row = 2, 
        macro_col = 2, 
        scr = 16, 
        is_size = 64, # kB 
        os_size = 64, # kB
    ):
        self.cim = cim
        self.bus_width = bus_width
        self.macro_row = macro_row
        self.macro_col = macro_col
        self.is_size = is_size
        self.os_size = os_size
        self.AL = self.cim.single_macro_al * macro_col
        self.PC = self.cim.single_macro_pc * macro_row
        self.SCR = scr
        self.IS_DEPTH = int(is_size *1024 *8 / (self.AL * self.cim.data_width_input))
        self.OS_DEPTH = int(os_size *1024 *8 / (self.PC * self.cim.data_width_output))
        self.BUS_WIDTH_for_Compile = bus_width * (1000/cim.freq) * 8 * (8/self.cim.data_width_input)
        self.BUS_WIDTH_real = bus_width * (1000/cim.freq) * 8 # GBps

        self.CIMsComputeWidth = self.cim.input_compute_bw * macro_col
        self.CIMsWriteWidth = self.cim.weight_update_bw * macro_col
        self.freq = cim.freq

        self.bit_energy_L2 = 1 # pJ/bit

    
    def printf(self, power_print = 0):
        print("###### ACC Parameters ######", flush=True)
        print("cim type:   ", self.cim.name, flush=True)
        print("bus_width:  ", self.bus_width, flush=True)
        print("macros_row: ", self.macro_row, flush=True)
        print("macros_col: ", self.macro_col, flush=True)
        print("scr:        ", self.SCR, flush=True)
        print("is_size:    ", self.is_size, flush=True)
        print("os_size:    ", self.os_size, flush=True)
        if power_print:
            print(self.cim.compute_allbank_power, flush=True)
            print(self.cim.write_onerow_power, flush=True)
            print(self.cim.static_power, flush=True)
            print(self.cim.memory_array_ratio, flush=True)

    def write_log(self, filename):
        with open(filename, 'w') as f:
            f.write("###### ACC Parameters ######\n")
            f.write(f"cim type:   {self.cim.name}\n")
            f.write(f"bus_width:  {self.bus_width}\n")
            f.write(f"macros_row: {self.macro_row}\n")
            f.write(f"macros_col: {self.macro_col}\n")
            f.write(f"scr:        {self.SCR}\n")
            f.write(f"is_size:    {self.is_size}\n")
            f.write(f"os_size:    {self.os_size}\n")
            f.write(f"compute_allbank_power: {self.cim.compute_allbank_power}\n")
            f.write(f"write_onerow_power: {self.cim.write_onerow_power}\n")
            f.write(f"static_power: {self.cim.static_power}\n")
            f.write(f"memory_array_ratio: {self.cim.memory_array_ratio}\n")



if __name__ == "__main__":
    # cim = CIM(cfgname="./cim_config/BPCIM.cfg")
    cim = CIM(cfgname="./cim_config/LCC-CIM@ISSCC20.cfg")
    
    acc0 = CIMACC(cim,bus_width=25.6, macro_row=2, macro_col=4, scr=16, is_size=64, os_size=64)
    
    acc0.printf(1)


