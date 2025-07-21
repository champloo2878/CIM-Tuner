import math as m
from random import random, seed
import matplotlib.pyplot as plt
from evacim import cim_acc_config as cfg
from evacim import area_modeling
from evacim import sim

def func_cima(acc0, gli, dataflow):
    m = sim.evaluate(acc0, gli, dataflow)
    return -m['throughput'], m['area'][7]*1e-6

def get_random_bool():
    dice = random()
    if dice<1/3: 
        return -1
    elif dice < 2/3: 
        return 0
    else:
        return 1

class SimulateAnnealing_CIMACC_on_gli:
    def __init__(self, func, acc0, gli, dataflow, iter=5, T0=100, Tf=1e-8, alpha=0.99, epoch=1, input_weight_switch_enable=True,input_weight_scheduling_enable = True, weight_tiling_enable = True):
        """
        Annealing parameters
        :param iter: Number of internal cycles
        :param T0: Initial temperature
        :param Tf: Final temperature
        :param alpha: Cooling factor
        """
        self.func = func
        self.iter = iter
        self.alpha = alpha
        self.T0 = T0
        self.Tf = Tf
        self.T = T0
        self.epoch = epoch

        self.accs = [acc0 for i in range(self.iter)]
        self.glis = [gli for i in range(self.iter)]
        self.dataflows = [dataflow for i in range(self.iter)]

        self.area_const = 5       
        self.ms_ratio = 0.08
        # 50 for ee_L2
        # 0.05 for throughput
        self.delta = {
            'macro_row': 1,
            'macro_col': 1,
            'scr_pow': 1,
            'is_size_pow': 1,
            'os_size_pow': 1
        }
        self.df_var = (input_weight_scheduling_enable, input_weight_scheduling_enable, weight_tiling_enable)
        self.history = {'f': [], 'T': [], 'c': []}

    def generate_new_acc(self, acc0):
        while True:
            macro_row_new = acc0.macro_row + get_random_bool()*self.delta['macro_row']
            macro_col_new = acc0.macro_col + get_random_bool()*self.delta['macro_col']
            scr_new_pow = m.log2(acc0.SCR) + get_random_bool()*self.delta['scr_pow']
            is_size_new_pow = m.log2(acc0.is_size) + get_random_bool()*self.delta['is_size_pow']
            os_size_new_pow = m.log2(acc0.os_size) + get_random_bool()*self.delta['os_size_pow']
            
            
            if macro_row_new > 0 and macro_col_new > 0 and scr_new_pow > 0 and is_size_new_pow > 0 and os_size_new_pow > 0:
                acc_new = cfg.CIMACC(
                    cim = acc0.cim,
                    bus_width = acc0.bus_width,
                    macro_row = macro_row_new,
                    macro_col = macro_col_new,
                    scr = int(m.pow(2, scr_new_pow)),
                    is_size = int(m.pow(2, is_size_new_pow)),
                    os_size = int(m.pow(2, os_size_new_pow)),
                    )
                area = area_modeling.area_modeling(acc_new)
                if area[7]*1e-6 <= self.area_const:
                    break
        return acc_new

    def generate_new_gli(self, gli):
        if random()>0.5 and self.df_var[0]:
            return (gli[0],(gli[1][2], gli[1][1], gli[1][0]))
        else:
            return gli

    def generate_new_dataflow(self, dataflow):
        if self.df_var[1] and not self.df_var[2]:
            if random()>0.5: return 'is'+dataflow[2:]
            else: return 'ws'+dataflow[2:]
        elif self.df_var[1] and self.df_var[2]:
            dice = random()
            if dice>0 and dice <= 0.25: return 'isap'
            elif dice>0.25 and dice <= 0.5: return 'ispp'
            elif dice>0.5 and dice <= 0.75: return 'wsap'
            else: return 'wspp'
        else: return dataflow

    def Metrospolis(self, f, f_new):
        if f_new <= f:
            return 1
        else:
            p = m.exp((f - f_new) * self.ms_ratio / self.T)
            if random() < p:
                return 1
            else:
                return 0

    def get_optimal(self):
        f_list = []
        area_list = []
        for i in range(self.iter):
            f, area = self.func(acc0 = self.accs[i], gli = self.glis[i], dataflow = self.dataflows[i])
            f_list.append(f)
            area_list.append(area)
        f_best = min(f_list)
        idx = f_list.index(f_best)
        return - f_best, area_list[idx], idx

    def plot(self, xlim=None, ylim=None):
        plt.plot(self.history['c'], self.history['f'])
        plt.title('Simulate Annealing')
        # plt.xlabel('Temperature')
        plt.xlabel('Count')
        plt.ylabel('f value')
        if xlim:
            plt.xlim(xlim[0], xlim[-1])
        if ylim:
            plt.ylim(ylim[0], ylim[-1])
        # plt.gca().invert_xaxis()
        plt.show()
        plt.savefig("./plot/sa_gli.png")

    def run(self):
        count = 0
        # annealing
        while self.epoch != 0:
            # iteration
            for i in range(self.iter):
                f, _ = self.func(acc0 = self.accs[i], gli = self.glis[i], dataflow = self.dataflows[i])
                acc_new = self.generate_new_acc(self.accs[i])
                gli_new = self.generate_new_gli(self.glis[i])
                dataflow_new = self.generate_new_dataflow(self.dataflows[i])
                f_new, _ = self.func(acc0 = acc_new, gli = gli_new, dataflow = dataflow_new)
                if self.Metrospolis(f, f_new):
                    self.accs[i] = acc_new
                    self.glis[i] = gli_new
                    self.dataflows[i] = dataflow_new
            # save to history
            ft, _, idx = self.get_optimal()
            self.history['f'].append(ft)
            self.history['T'].append(self.T)
            self.history['c'].append(count)
            print(ft, self.T,'\tidx:',idx, self.glis[idx], self.dataflows[idx], self.accs[idx].macro_row, self.accs[idx].macro_col, self.accs[idx].SCR, self.accs[idx].is_size, self.accs[idx].os_size)
            # cooling
            self.T = self.T * self.alpha
            count += 1
            if self.T < self.Tf:
                self.epoch -= 1
                self.T = self.T0 
        # get optimal solution
        f_best, area, idx = self.get_optimal()
        self.accs[idx].printf()
        print(f"best={f_best}, area={area}", count)

if __name__ == '__main__':
 
    cim = cfg.CIM("./cim_config/FPCIM@ISSCC23.cfg")
    gli = ('proj', [512,512,512])

    acc0 = cfg.CIMACC(
        cim,
        bus_width = 25.6, 
        macro_row = 3, 
        macro_col = 1, 
        scr = 16, 
        is_size = 64, 
        os_size = 64, 
        )

    seed(42)
    sa = SimulateAnnealing_CIMACC_on_gli(
        func_cima, 
        acc0, 
        gli, 
        "isap", 
        iter=5, 
        Tf=1, 
        alpha=0.99,
        epoch = 1, 
        input_weight_switch_enable = True,
        input_weight_scheduling_enable = True,
        weight_tiling_enable = True
    )

    sa.run()
    sa.plot()
    

