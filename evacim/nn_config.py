import csv
import numpy as np

class NN:
    def __init__(self, cfgname):
        self.cfgname = cfgname
        self.gli_list = []
        self.gli_list_rdc = []
        self.gli_cnt = []

        self.read_csv()
        self.gli_reduction()

    def read_csv(self):
        with open(self.cfgname, newline='') as f:
            reader = csv.DictReader(f)
            for row in reader:
                M = int(row['M'])
                K = int(row['K'])
                N = int(row['N'])
                self.gli_list.append((N, K, M))

    def gli_reduction(self):
        self.gli_list_rdc, self.gli_cnt = np.unique(self.gli_list, axis=0, return_counts=True)



if __name__ == "__main__":
    nnb = NN("./nn_config/bert_large_sl512.csv")
    print(nnb.gli_list_rdc, nnb.gli_cnt)





