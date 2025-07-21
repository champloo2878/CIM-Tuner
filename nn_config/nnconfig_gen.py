import csv

class gen_transformer_config:
    def __init__(self, model, seq_len, hidden_size, head_num):
        self.model = model
        self.seq_len = seq_len
        self.hidden_size = hidden_size
        self.head_num = head_num
        self.fname = './nn_config/'+model+'_sl'+str(seq_len)+'.csv'

    def gen(self):
        rows = [["Layer", "M", "N", "K"]]
        for name in ['Q','K','V']:
            rows.append([name+"gen", self.seq_len, self.hidden_size, self.hidden_size])
        for h in range(self.head_num):
            rows.append(['QKT-H'+str(h), self.seq_len, self.seq_len, int(self.hidden_size/self.head_num)])
            rows.append(['PV-H'+str(h), self.seq_len, int(self.hidden_size/self.head_num), self.seq_len])
        rows.append(["Concat", self.seq_len, self.hidden_size, self.hidden_size])
        rows.append(["Linear-1", self.seq_len, self.hidden_size*4, self.hidden_size])
        rows.append(["Linear-2", self.seq_len, self.hidden_size, self.hidden_size*4])

        with open(self.fname, "w", newline='') as f:
            writer = csv.writer(f)
            writer.writerows(rows)


gb = gen_transformer_config(
    model= 'gpt2_large',
    seq_len= 8,
    hidden_size= 1024,
    head_num= 16
)

gb.gen()





