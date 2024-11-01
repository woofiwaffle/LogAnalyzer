import os
import csv
import subprocess
from datetime import datetime

LOG_DIRECTORY = 'logs/'
BACKUP_DIRECTORY = 'backup_logs/'
OUTPUT_CSV = 'reports/report.csv'

def get_log_files(directory):
    return sorted([f for f in os.listdir(directory) if f.startswith("application.log")])

def process_log_file(log_file):
    result = subprocess.run(['D:/Lua/lua54.exe', 'log_processor.lua', os.path.join(LOG_DIRECTORY, log_file)],
                            capture_output=True, text=True)
    counts = result.stdout.strip().split(',')
    
    date_str = log_file.split('.')[2]  # 'application.log.yyyy-mm-dd'
    
    return {
        'date': date_str,
        'info_count': int(counts[0]),
        'warn_count': int(counts[1]),
        'error_count': int(counts[2])
    }

def write_csv_report(report_data):
    fieldnames = ['date', 'info_count', 'warn_count', 'error_count']

    with open(OUTPUT_CSV, mode='w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        
        for entry in report_data:
            writer.writerow(entry)

def backup_logs():
    subprocess.run(['D:/Git/bin/bash.exe', 'backup.sh', LOG_DIRECTORY, BACKUP_DIRECTORY])

if __name__ == '__main__':
    log_files = get_log_files(LOG_DIRECTORY)
    report_data = []
    
    for log_file in log_files:
        processed_data = process_log_file(log_file)
        report_data.append(processed_data)
    
    write_csv_report(report_data)
    backup_logs()
    print("Processing complete. Report generated and logs backed up.")
