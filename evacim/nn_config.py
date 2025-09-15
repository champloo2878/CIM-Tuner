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
            reader_t = csv.DictReader(f)
            try:
                for row in reader_t:
                    Test = int(row['M'])
                Test = True
            except:
                Test = False

        with open(self.cfgname, newline='') as f:
            reader = csv.DictReader(f)
            if Test: # for Transformers
                for row in reader:
                    M = int(row['M'])
                    K = int(row['K'])
                    N = int(row['N'])
                    self.gli_list.append((N, K, M))

            else: # for CNNs
                for row in reader:
                    ifmap_h = int(row['IFMAPH'])
                    ifmap_w = int(row['IFMAPW'])
                    filter_h = int(row['Filter H'])
                    filter_w = int(row['Filter W'])
                    channels = int(row['Channels'])
                    num_filter = int(row['Num Filter'])
                    strides = int(row['Strides'])
                    
                    p_h = (filter_h - 1) // 2
                    p_w = (filter_w - 1) // 2
                    
                    h_o = (ifmap_h + 2 * p_h - filter_h) // strides + 1
                    w_o = (ifmap_w + 2 * p_w - filter_w) // strides + 1
                    
                    M = h_o * w_o
                    N = num_filter
                    K = channels * filter_h * filter_w
                    
                    self.gli_list.append((N, K, M))


    def gli_reduction(self):
        self.gli_list_rdc, self.gli_cnt = np.unique(self.gli_list, axis=0, return_counts=True)



if __name__ == "__main__":
    networks = [
    'resnet_18',
    'bert_base_sl64',
    'bert_base_sl512',
    'bert_large_sl64',
    'bert_large_sl512',
    'vit_large_sl197',
    'gpt2_large_sl8',
    ]
    for nn in networks:
        nnb = NN(f"./nn_config/{nn}.csv")
        print(len(nnb.gli_list)/len(nnb.gli_list_rdc))





