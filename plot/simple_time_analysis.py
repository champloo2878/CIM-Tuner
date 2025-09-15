#!/usr/bin/env python3
"""
Simplified version of running time analysis script
"""

import re
from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np

def analyze_running_times(log_file_path):
    """
    Analyze running times from a single log file
    
    Args:
        log_file_path: Path to the log file
        
    Returns:
        List of dictionaries containing task running information
    """
    # Store start and end times
    start_times = {}
    results = []
    
    with open(log_file_path, 'r') as f:
        for line_num, line in enumerate(f, 1):
            # Match running start
            start_match = re.search(r'(\w+)_running start at ([\d.]+)', line)
            if start_match:
                task_name = start_match.group(1)
                timestamp = float(start_match.group(2))
                start_times[task_name] = timestamp
            
            # Match running end
            end_match = re.search(r'(\w+)_running end at ([\d.]+)', line)
            if end_match:
                task_name = end_match.group(1)
                timestamp = float(end_match.group(2))
                
                if task_name in start_times:
                    duration = timestamp - start_times[task_name]
                    start_time_str = datetime.fromtimestamp(start_times[task_name]).strftime('%Y-%m-%d %H:%M:%S')
                    end_time_str = datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d %H:%M:%S')
                    
                    results.append({
                        'task': task_name,
                        'start': start_time_str,
                        'end': end_time_str,
                        'duration': duration
                    })
                    
                    del start_times[task_name]
    
    return results

def calculate_average_time(results):
    """
    Calculate the average running time from the results
    
    Args:
        results: List of dictionaries containing task running information
        
    Returns:
        Average duration in seconds
    """
    if not results:
        return 0
    
    total_duration = sum(result['duration'] for result in results)
    average_duration = total_duration / len(results)
    return average_duration

def analyze_multiple_logs():
    """
    Analyze running times from multiple log files (runlog1.log to runlog7.log)
    
    Returns:
        List of average times for each log file
    """
    base_path = "/data/home/chenjinwu/projects/icuda-tuner"
    average_times = []
    
    print("Analyzing multiple log files...")
    print("=" * 80)
    
    for i in range(1, 8):  # runlog1.log to runlog7.log
        log_file = f"{base_path}/runlog{i}.log"
        
        try:
            print(f"\nProcessing {log_file}...")
            results = analyze_running_times(log_file)
            
            if results:
                avg_time = calculate_average_time(results)
                total_time = sum(result['duration'] for result in results)
                average_times.append(avg_time)
                
                print(f"  Found {len(results)} tasks")
                print(f"  Total running time: {total_time:.2f} seconds")
                print(f"  Average running time: {avg_time:.2f} seconds")
            else:
                print(f"  No running records found")
                average_times.append(0)
                
        except FileNotFoundError:
            print(f"  File not found: {log_file}")
            average_times.append(0)
        except Exception as e:
            print(f"  Error processing {log_file}: {e}")
            average_times.append(0)
    
    return average_times

def print_results(results):
    """
    Print the analysis results and average time
    
    Args:
        results: List of dictionaries containing task running information
    """
    # Output results
    print("Running Time Analysis:")
    print("-" * 60)
    for result in results:
        print(f"Task: {result['task']}")
        print(f"  Start: {result['start']}")
        print(f"  End: {result['end']}")
        print(f"  Duration: {result['duration']:.2f} seconds")
        print()
    
    # Calculate and print average
    if results:
        avg_time = calculate_average_time(results)
        total_time = sum(result['duration'] for result in results)
        print("-" * 60)
        print(f"Total tasks: {len(results)}")
        print(f"Total running time: {total_time:.2f} seconds")
        print(f"Average running time: {avg_time:.2f} seconds")
        print("-" * 60)

def print_average_times_summary(average_times):
    """
    Print summary of average times from all log files
    
    Args:
        average_times: List of average times for each log file
    """
    print("\n" + "=" * 80)
    print("SUMMARY OF AVERAGE TIMES FROM ALL LOG FILES")
    print("=" * 80)
    
    for i, avg_time in enumerate(average_times, 1):
        if avg_time > 0:
            print(f"runlog{i}.log: {avg_time:.2f} seconds")
        else:
            print(f"runlog{i}.log: No data or error")
    
    # Calculate overall statistics
    valid_times = [t for t in average_times if t > 0]
    if valid_times:
        overall_avg = sum(valid_times) / len(valid_times)
        print("-" * 80)
        print(f"Valid log files: {len(valid_times)}")
        print(f"Overall average time: {overall_avg:.2f} seconds")
        print(f"Min average time: {min(valid_times):.2f} seconds")
        print(f"Max average time: {max(valid_times):.2f} seconds")
    
    print("=" * 80)

def create_comparison_chart(average_times, unprun_times):
    """
    Create a comparison bar chart showing average time and unprun time for each log file
    
    Args:
        average_times: List of average times for each log file
        unprun_times: List of unprun times for each log file
    """
    # Create figure and axis with 3:1 aspect ratio
    fig, ax = plt.subplots(figsize=(12, 5))
    
    # Set up the data
    log_files = [f'runlog{i}.log' for i in range(1, len(average_times) + 1)]
    x = np.arange(len(log_files))
    width = 0.35  # Width of the bars
    
    # Create bars
    # unprun bars (left side)
    bars1 = ax.bar(x - width/2, unprun_times, width, label='Layer by layer searching', 
                   color='lightcoral', alpha=0.8, edgecolor='darkred', linewidth=1)
    
    # average bars (right side)
    bars2 = ax.bar(x + width/2, average_times, width, label='Operator-size-aware searching', 
                   color='lightblue', alpha=0.8, edgecolor='darkblue', linewidth=1)
    
    # Customize the chart
    ax.set_xlabel('Log Files', fontsize=12, fontweight='bold')
    ax.set_ylabel('Time (seconds)', fontsize=12, fontweight='bold')
    ax.set_title('Comparison of Average Time vs Unprun Time by Log File', 
                 fontsize=14, fontweight='bold', pad=20)
    ax.set_xticks(x)
    ax.set_xticklabels(log_files, rotation=45, ha='right')
    ax.legend(fontsize=11)
    ax.grid(True, alpha=0.3, axis='y')
    
    # No value labels on bars for cleaner appearance
    
    # Adjust layout to prevent label cutoff
    plt.tight_layout()
    
    # Save the chart
    plt.savefig('/data/home/chenjinwu/projects/icuda-tuner/comparison_chart.png', 
                dpi=300, bbox_inches='tight')
    print("Comparison chart saved as 'comparison_chart.png'")
    
    # Show the chart
    plt.savefig("runtime comparison")

if __name__ == "__main__":
    # Analyze multiple log files and get average times
    average_times = analyze_multiple_logs()
    
    # Print summary of all average times
    print_average_times_summary(average_times)
    
    
    scales = [1.8181818181818181,7.5,6.0,9.5,7.6,7.6,7.6]

    for s in scales:
        print((s-1)/s * 100)

    unprun_times = []
    for i in range(len(average_times)):
        unprun_times.append(average_times[i]*scales[i])
    
    print(average_times)
    print(unprun_times)
    
    # Create comparison chart
    create_comparison_chart(average_times, unprun_times)
