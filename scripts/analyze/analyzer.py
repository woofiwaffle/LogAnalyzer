import matplotlib.pyplot as plt
import csv
import os

input_csv_path = 'reports/report.csv'
output_directory = 'reports'

if not os.path.exists(output_directory):
    os.makedirs(output_directory)

dates = []
info_counts = []
warn_counts = []
error_counts = []

with open(input_csv_path, 'r') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        dates.append(row['date'])
        info_counts.append(int(row['info_count']))
        warn_counts.append(int(row['warn_count']))
        error_counts.append(int(row['error_count']))

plt.figure(figsize=(12, 6))
bar_width = 0.25
index = range(len(dates))

plt.bar(index, info_counts, bar_width, label='INFO', color='green')
plt.bar([i + bar_width for i in index], warn_counts, bar_width, label='WARN', color='yellow')
plt.bar([i + 2 * bar_width for i in index], error_counts, bar_width, label='ERROR', color='red')

plt.xlabel('Date')
plt.ylabel('Log Count')
plt.title('Log Analysis Report')
plt.xticks([i + bar_width for i in index], dates, rotation=45)
plt.legend()

plt.tight_layout()

output_path = os.path.join(output_directory, 'log_analysis_report.png')
plt.savefig(output_path)
plt.close()

print(f"Report saved as {output_path}")