import math as m
from random import random, seed
import matplotlib.pyplot as plt
from evacim import cim_acc_config as ccfg
from evacim import nn_config as ncfg
from evacim import area_modeling

from evacim.sw_func import get_random_bool, func_cima, func_model, func_model_fix_dataflow


class SimulateAnnealing_CIMACC_on_model:
    def __init__(self, func, acc0, model, opt_target, area_const=5e6, iter=5, T0=100, Tf=1e-8, alpha=0.99, epoch=1):
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
        self.model = model
        self.opt_target = opt_target

        self.area_const = area_const       
        self.ms_ratio = 50 if opt_target == 'ee_L2' else 0.05
        # 50 for ee_L2
        # 0.05 for throughput
        self.delta = {
            'macro_row': 1,
            'macro_col': 1,
            'scr_pow': 1,
            'is_size_pow': 1,
            'os_size_pow': 1
        }
        self.history = {'f': [], 'T': [], 'c': []}

    def generate_new_acc(self, acc0):
        while True:
            macro_row_new = acc0.macro_row + get_random_bool()*self.delta['macro_row']
            macro_col_new = acc0.macro_col + get_random_bool()*self.delta['macro_col']
            scr_new_pow = m.log2(acc0.SCR) + get_random_bool()*self.delta['scr_pow']
            is_size_new_pow = m.log2(acc0.is_size) + get_random_bool()*self.delta['is_size_pow']
            os_size_new_pow = m.log2(acc0.os_size) + get_random_bool()*self.delta['os_size_pow']
            
            if macro_row_new > 0 and macro_col_new > 0 and scr_new_pow > 0 and is_size_new_pow > 0 and os_size_new_pow > 0:
                acc_new = ccfg.CIMACC(
                    cim = acc0.cim,
                    bus_width = acc0.bus_width,
                    macro_row = macro_row_new,
                    macro_col = macro_col_new,
                    scr = int(m.pow(2, scr_new_pow)),
                    is_size = int(m.pow(2, is_size_new_pow)),
                    os_size = int(m.pow(2, os_size_new_pow)),
                    )
                area = area_modeling.area_modeling(acc_new)
                if area[7] <= self.area_const:
                    break
        return acc_new

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
            f, _, area = self.func(acc0 = self.accs[i], model = self.model, opt_target = self.opt_target)
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
        plt.savefig("./plot/sa_model.png")

    def run(self, write_log = False, logname = "res.log"):
        count = 0
        # annealing
        while self.epoch != 0:
            # iteration
            for i in range(self.iter):
                f, _, _ = self.func(acc0 = self.accs[i], model = self.model, opt_target = self.opt_target)
                acc_new = self.generate_new_acc(self.accs[i])
                f_new, _, _ = self.func(acc0 = acc_new, model = self.model, opt_target = self.opt_target)
                if self.Metrospolis(f, f_new):
                    self.accs[i] = acc_new
            # save to history
            ft, _, idx = self.get_optimal()
            self.history['f'].append(ft)
            self.history['T'].append(self.T)
            self.history['c'].append(count)
            print(ft, self.T,'\tidx:',idx, self.accs[idx].macro_row, self.accs[idx].macro_col, self.accs[idx].SCR, self.accs[idx].is_size, self.accs[idx].os_size, flush=True)
            # cooling
            self.T = self.T * self.alpha
            count += 1
            if self.T < self.Tf:
                self.epoch -= 1
                self.T = self.T0 
        # get optimal solution
        f_best, area, idx = self.get_optimal()
        self.accs[idx].printf()
        if write_log: 
            self.accs[idx].write_log(logname)
            with open(logname, 'a') as f:
                f.write(f"best={f_best}, area={area}, count={count}")
        print(f"best={f_best}, area={area}", count, flush=True)

if __name__ == '__main__':
    
    model = ncfg.NN("./nn_config/bert_base_sl64.csv") 
    cim = ccfg.CIM("./cim_config/FPCIM@ISSCC23.cfg")
    acc_trancim = ccfg.CIMACC(
        cim,
        bus_width = 25.6, 
        macro_row = 1, 
        macro_col = 3, 
        scr = 1, 
        is_size = 64, 
        os_size = 128, 
        ) 

    seed(43)
    sa = SimulateAnnealing_CIMACC_on_model(
        func_model_fix_dataflow, 
        acc_trancim, 
        model,
        opt_target = 'ee_L2', 
        iter=5, 
        Tf=1, 
        alpha=0.99,
        epoch = 1, 
    )

    sa.run(write_log=True, logname="./Result/test.log")
    sa.plot()
