import matplotlib
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

def get_data(filename):
	f_cockroach_concurrency = open(filename, "r")
	fc = f_cockroach_concurrency.read()
	lines = fc.split('\n')
	concurrency = []
	throughputs = []
	latencies = []
	for line_num in range(0,len(lines)-2,3):
		l1 = lines[line_num]
		l2 = lines[line_num + 2]
		words = l1.split()
		if len(words) > 0 and "concurrency" in words[0]:
			concurrency.append(int(words[1]))

		words = l2.split()
		throughputs.append(float(words[3]))
		latencies.append(float(words[4]))

	return [concurrency, throughputs, latencies]

def experiment_plot(experiment, workload="UNK"):
	concurrency = experiment[0]
	throughputs = experiment[1]
	latencies = experiment[2]

	fig, ax1 = plt.subplots()
	ax2 = ax1.twinx()

	ax1.bar(concurrency, throughputs)
	ax2.plot(concurrency, latencies, 's-', color="red" )

	ax1.set_xlabel('concurrency')
	ax1.set_ylabel('Throughput(ops/s)', color='b')
	ax2.set_ylabel('Latencies(ms)', color='r')

	plt.xticks([4, 8, 12, 16, 20, 24, 28, 32])
	ax1.set_xticks([4, 8, 12, 16, 20, 24, 28, 32])
	ax2.set_xticks([4, 8, 12, 16, 20, 24, 28, 32])

	plt.title("Cockroach DB - Concurrency, YCSB Workload: " + str(workload))

	plt.savefig("../benchmark_plots/concurrency_test_workload_" + str(workload) + ".png", dpi = 300)

def experiment_plot_sns(experiment, workload="UNK"):
	concurrency = experiment[0]
	throughputs = experiment[1]
	latencies = experiment[2]

	df = pd.DataFrame(list(zip(concurrency, throughputs, latencies)), columns = ["Concurrency", "Throughputs (ops/s)", "Latencies (ms)"])

	# sns.set_style(style="darkgrid")
	# sns.barplot(x = concurrency, y = throughputs, alpha = 0.5)
	# ax2 = plt.twinx()
	# sns.lineplot(x = concurrency, y = latencies, marker = "s", ax = ax2)

	# plt.xlabel("concurrency")
	# plt.ylabel("Throughput(ops/s)")
	# ax2.set_ylabel("Latencies(ms)")

	matplotlib.rc_file_defaults()
	ax1 = sns.set_style(style=None, rc=None )

	fig, ax1 = plt.subplots(figsize=(8,6))

	title = "Cockroach DB - Concurrency, YCSB Workload: " + str(workload)
	sns.barplot(data = df, x='Concurrency', y='Throughputs (ops/s)', alpha=0.65, ax=ax1).set(title = title)
	
	ax2 = ax1.twinx()

	sns.lineplot(data = df['Latencies (ms)'], marker='s', sort = False, ax=ax2, color="red", label="Latency")
	ax2.legend(loc=0)
	

	plt.savefig("../benchmark_plots/concurrency_test_workload_" + str(workload) + ".png", dpi = 300)


experiment_A = get_data("../benchmark_output_logs/concurrency_test_workload_A.out")
experiment_B = get_data("../benchmark_output_logs/concurrency_test_workload_B.out")
experiment_C = get_data("../benchmark_output_logs/concurrency_test_workload_C.out")

# experiment_plot(experiment_A, 'A')
# experiment_plot(experiment_B, 'B')
# experiment_plot(experiment_C, 'C')

experiment_plot_sns(experiment_A, 'A')
experiment_plot_sns(experiment_B, 'B')
experiment_plot_sns(experiment_C, 'C')
