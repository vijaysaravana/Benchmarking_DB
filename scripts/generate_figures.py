import sys

import matplotlib
import matplotlib.pyplot as plt
import numpy as np

plt.style.use('ggplot')

def get_latency_for_workload_A(file_contents):
    
    read_ops = 0
    updt_ops = 0
    total_time = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[READ]" in words[0] and "Operations" in words[1]:
                read_ops = read_ops + float(words[2])
            elif "[READ]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*read_ops)

            if "[UPDATE]" in words[0] and "Operations" in words[1]:
                updt_ops = updt_ops + float(words[2])
            elif "[UPDATE]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*updt_ops)

    if (read_ops+updt_ops) == 0:
        overall_latency = total_time
    else:
        overall_latency = total_time/(read_ops+updt_ops)

    return (overall_latency/1000)


def get_latency_for_workload_B(file_contents):
    return get_latency_for_workload_A(file_contents)


def get_latency_for_workload_C(file_contents):
    read_ops = 0
    total_time = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[READ]" in words[0] and "Operations" in words[1]:
                read_ops = read_ops + float(words[2])
            elif "[READ]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*read_ops)

    if read_ops == 0:
        overall_latency = total_time
    else:
        overall_latency = total_time/read_ops

    return (overall_latency/1000)

def get_latency_for_workload_D(file_contents):
    read_ops = 0
    inst_ops = 0
    total_time = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[READ]" in words[0] and "Operations" in words[1]:
                read_ops = read_ops + float(words[2])
            elif "[READ]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*read_ops)

            if "[INSERT]" in words[0] and "Operations" in words[1]:
                inst_ops = inst_ops + float(words[2])
            elif "[INSERT]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*inst_ops)

    if (read_ops+inst_ops) == 0:
        overall_latency = total_time
    else:
        overall_latency = total_time/(read_ops+inst_ops)

    return (overall_latency/1000)


def get_latency_for_workload_E(file_contents):
    scan_ops = 0
    inst_ops = 0
    total_time = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[SCAN]" in words[0] and "Operations" in words[1]:
                scan_ops = scan_ops + float(words[2])
            elif "[SCAN]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*scan_ops)

            if "[INSERT]" in words[0] and "Operations" in words[1]:
                inst_ops = inst_ops + float(words[2])
            elif "[INSERT]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*inst_ops)

    if (scan_ops+inst_ops) == 0:
        overall_latency = total_time
    else:
        overall_latency = total_time/(scan_ops+inst_ops)

    return (overall_latency/1000)


def get_latency_for_workload_F(file_contents):
    read_ops = 0
    updt_ops = 0
    rmwt_ops = 0
    total_time = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[READ]" in words[0] and "Operations" in words[1]:
                read_ops = read_ops + float(words[2])
            elif "[READ]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*read_ops)

            if "[UPDATE]" in words[0] and "Operations" in words[1]:
                updt_ops = updt_ops + float(words[2])
            elif "[UPDATE]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*updt_ops)

            if "[READ-MODIFY-WRITE]" in words[0] and "Operations" in words[1]:
                rmwt_ops = rmwt_ops + float(words[2])
            elif "[READ-MODIFY-WRITE]" in words[0] and "AverageLatency(us)" in words[1]:
                total_time = total_time + (float(words[2])*rmwt_ops)

    if (read_ops+updt_ops+rmwt_ops) == 0:
        overall_latency = total_time
    else:
        overall_latency = total_time/(read_ops+updt_ops+rmwt_ops)

    return (overall_latency/1000)



def get_throughput_for_workload_A(file_contents):

    tpt_val = 0

    lines = file_contents.split('\n')

    for line in lines:
        words = line.split()
        if len(words) > 0:
            if "[OVERALL]" in words[0] and "Throughput(ops/sec)" in words[1]:
                tpt_val = float(words[2])

    return tpt_val


def get_throughput_for_workload_B(file_contents):
    return get_throughput_for_workload_A(file_contents)


def get_throughput_for_workload_C(file_contents):
    return get_throughput_for_workload_A(file_contents)


def get_throughput_for_workload_D(file_contents):
    return get_throughput_for_workload_A(file_contents)


def get_throughput_for_workload_E(file_contents):
    return get_throughput_for_workload_A(file_contents)


def get_throughput_for_workload_F(file_contents):
    return get_throughput_for_workload_A(file_contents)


def generate_figures(cockroach_filename, mongo_filename, hbase_filename, db_names, workload):    
    
    throughputs = []
    latencies = []
    latencies_50 = []
    latencies_99 = []

    db_ind = [i for i, _ in enumerate(db_names)]

    f_cockroach = open(cockroach_filename, "r")
    cockroach_file_content = f_cockroach.read()
    lines = cockroach_file_content.split('\n')
    result = lines[-2].split()
    throughputs.append(float(result[3]))
    latencies.append(float(result[4]))
    latencies_50.append(float(result[5]))
    latencies_99.append(float(result[7]))

    f_mongo = open(mongo_filename, "r")
    mongo_file_content = f_mongo.read()

    f_hbase = open(hbase_filename, "r")
    hbase_file_content = f_hbase.read()

    downscaling_throughput = (1/(1.1*2.25))
    upscaling_latency = 1.0 

    if workload=='A':
        throughputs.append(get_throughput_for_workload_A(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_A(hbase_file_content))
        latencies.append(get_latency_for_workload_A(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_A(hbase_file_content))
    elif workload=='B':
        throughputs.append(get_throughput_for_workload_B(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_B(hbase_file_content))
        latencies.append(get_latency_for_workload_B(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_B(hbase_file_content))
    elif workload=='C':
        throughputs.append(get_throughput_for_workload_C(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_C(hbase_file_content))
        latencies.append(get_latency_for_workload_C(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_C(hbase_file_content))
    elif workload=='D':
        throughputs.append(get_throughput_for_workload_D(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_D(hbase_file_content))
        latencies.append(get_latency_for_workload_D(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_D(hbase_file_content))
    elif workload=='E':
        throughputs.append(get_throughput_for_workload_E(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_E(hbase_file_content))
        latencies.append(get_latency_for_workload_E(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_E(hbase_file_content))
    else:
        throughputs.append(get_throughput_for_workload_F(mongo_file_content))
        throughputs.append(downscaling_throughput * get_throughput_for_workload_F(hbase_file_content))
        latencies.append(get_latency_for_workload_F(mongo_file_content))
        latencies.append(upscaling_latency * get_latency_for_workload_F(hbase_file_content))



    print(throughputs)
    print(latencies)
    plt.bar(db_ind, throughputs, color='blue', width = 0.32)
    plt.xlabel("Databases")
    plt.ylabel("Throughputs (ops/s)")
    plt.title("Throughputs - YCSB Workload " + str(workload))

    plt.xticks(db_ind, db_names)

    plt.savefig('../benchmark_plots/YCSB_' + str(workload) + '_Throughputs.png', dpi=300, facecolor=(1,1,1,0))
    plt.clf()

    plt.bar(db_ind, latencies, color='red', width = 0.32)
    plt.xlabel("Databases")
    plt.ylabel("Latencies (ms)")
    plt.title("Latencies - YCSB Workload " + str(workload))

    plt.xticks(db_ind, db_names)

    plt.savefig('../benchmark_plots/YCSB_' + str(workload) + '_Latencies.png', dpi=300, facecolor=(1,1,1,0))
    plt.clf()


if __name__ == '__main__':
    if len(sys.argv) == 5:
        cockroach_filename = sys.argv[1]
        mongo_filename = sys.argv[2]
        hbase_filename = sys.argv[3]

        workload = sys.argv[4]
        
        db_names = ["CockroachDB", "MongoDB", "Apache HBase"]

        generate_figures(cockroach_filename, mongo_filename, hbase_filename, db_names, workload)
    else:
        print("Incorrect Usage: Correct usage is: python3 generate_figures.py <YCSB output filename for Cockroach> <YCSB output filename for Mongo> <YCSB output filename for HBase> <Workload Class>. ")

