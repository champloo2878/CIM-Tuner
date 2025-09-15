import os
import json

metrics = ['ee','tt']
networks = [
    'resnet_18',
    'bert_base_sl64',
    'bert_base_sl512',
    'bert_large_sl64',
    'bert_large_sl512',
    'vit_large_sl197',
    'gpt2_large_sl8',
]

macros = [
    'FPCIM@ISSCC23',
    'LCC-CIM@ISSCC20',
]

def extract_parameters_from_log(log_file):
    """从log文件中提取参数"""
    params = {}
    best_value = None
    area_value = None
    count_value = None
    
    if not os.path.exists(log_file):
        print(f"Warning: {log_file} not found")
        return None
    
    with open(log_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("cim type:"):
                params['cim_type'] = line.split(':')[1].strip()
            elif line.startswith("bus_width:"):
                params['bus_width'] = float(line.split(':')[1].strip())
            elif line.startswith("macros_row:"):
                params['macros_row'] = int(line.split(':')[1].strip())
            elif line.startswith("macros_col:"):
                params['macros_col'] = int(line.split(':')[1].strip())
            elif line.startswith("scr:"):
                params['scr'] = int(line.split(':')[1].strip())
            elif line.startswith("is_size:"):
                params['is_size'] = int(line.split(':')[1].strip())
            elif line.startswith("os_size:"):
                params['os_size'] = int(line.split(':')[1].strip())
            elif line.startswith("compute_allbank_power:"):
                params['compute_allbank_power'] = float(line.split(':')[1].strip())
            elif line.startswith("write_onerow_power:"):
                params['write_onerow_power'] = float(line.split(':')[1].strip())
            elif line.startswith("static_power:"):
                params['static_power'] = float(line.split(':')[1].strip())
            elif line.startswith("memory_array_ratio:"):
                params['memory_array_ratio'] = float(line.split(':')[1].strip())
            elif line.startswith("best="):
                # 解析 best=value, area=value, count=value
                parts = line.split(',')
                best_value = float(parts[0].split('=')[1])
                area_value = float(parts[1].split('=')[1])
                count_value = int(parts[2].split('=')[1])
    
    if params and best_value is not None:
        params['best'] = best_value
        params['area'] = area_value
        params['count'] = count_value
        return params
    else:
        print(f"Warning: Could not extract complete parameters from {log_file}")
        return None

def main():
    """主函数：提取所有网络的最优参数（非fix）"""
    all_results = {}
    
    for metric in metrics:
        all_results[metric] = {}
        print(f"\n=== Processing {metric.upper()} metric ===")
        
        for macro in macros:
            all_results[metric][macro] = {}
            print(f"\n--- {macro} ---")
            
            for network in networks:
                # 只处理非fix的log文件
                log_file = f"./Result/{metric}{network}_{macro}.log"
                params = extract_parameters_from_log(log_file)
                
                if params:
                    all_results[metric][macro][network] = params
                    print(f"{network}: best={params['best']:.4f}, area={params['area']:.0f}, "
                          f"bus_width={params['bus_width']}, macros={params['macros_row']}x{params['macros_col']}, "
                          f"scr={params['scr']}, is_size={params['is_size']}, os_size={params['os_size']}")
                else:
                    print(f"{network}: No data found")
    
    # 保存结果到JSON文件
    output_file = "./Result/best_params_non_fix.json"
    with open(output_file, 'w') as f:
        json.dump(all_results, f, indent=2)
    
    print(f"\n=== Results saved to {output_file} ===")
    
    # 生成CSV格式的汇总表
    generate_summary_csv(all_results)

def generate_summary_csv(all_results):
    """生成CSV格式的汇总表"""
    import csv
    
    csv_file = "./Result/best_params_summary.csv"
    
    with open(csv_file, 'w', newline='') as f:
        writer = csv.writer(f)
        
        # 写入表头
        header = ['Metric', 'Macro', 'Network', 'Best', 'Area', 'Count', 
                 'CIM_Type', 'Bus_Width', 'Macros_Row', 'Macros_Col', 
                 'SCR', 'IS_Size', 'OS_Size', 'Compute_Power', 'Write_Power', 
                 'Static_Power', 'Memory_Ratio']
        writer.writerow(header)
        
        # 写入数据
        for metric in metrics:
            for macro in macros:
                for network in networks:
                    if network in all_results[metric][macro]:
                        params = all_results[metric][macro][network]
                        row = [
                            metric,
                            macro,
                            network,
                            params['best'],
                            params['area'],
                            params['count'],
                            params['cim_type'],
                            params['bus_width'],
                            params['macros_row'],
                            params['macros_col'],
                            params['scr'],
                            params['is_size'],
                            params['os_size'],
                            params['compute_allbank_power'],
                            params['write_onerow_power'],
                            params['static_power'],
                            params['memory_array_ratio']
                        ]
                        writer.writerow(row)
    
    print(f"Summary CSV saved to {csv_file}")

if __name__ == "__main__":
    main()
