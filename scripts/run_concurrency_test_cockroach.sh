#!/bin/bash

echo "This process assumes that cloud infrastructure setup is complete, which includes."
echo -e "\t 1. Setting up a Resource Group"
echo -e "\t 2. Setting up a Virtual Network"
echo -e "\t 3. Setting up a Network Securty Group, with set inbound rules."
echo -e "\t 4. Creating 3 Virtual Machines & synchronizing time."
echo -e "\t 5. Setting up a Load Balancer."
echo -e "\t 6. Installing and starting CockroachDB on all nodes."
echo -e "\t 7. Logging on to a Client node."

echo "Instructions for above can be found at https://www.cockroachlabs.com/docs/v21.2/deploy-cockroachdb-on-microsoft-azure-insecure"

which cockroach
if [[ $? -ne 0 ]]; then
    echo "CockroachDB Installation not found. Terminating."
    exit 1
fi

echo "This script will run benchmark taksks for roughly 60 minutes. Do you wish to proceed (yes/no):"
read input
if [[ $input != "yes" ]]; then
    echo "Terminating."
    exit 1
fi

> single_log.tmp
> ../benchmark_output_logs/concurrency_test_workload_A.out
> ../benchmark_output_logs/concurrency_test_workload_B.out
> ../benchmark_output_logs/concurrency_test_workload_C.out

cockroach workload init ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' --drop --workload A >> single_log.tmp

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s --duration=5m --display-format=simple --workload A --concurrency 8 >> single_log.tmp

echo "concurrency: 8" >> ../benchmark_output_logs/concurrency_test_workload_A.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_A.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s --duration=5m --display-format=simple --workload A --concurrency 16 >> single_log.tmp

echo "concurrency: 16" >> ../benchmark_output_logs/concurrency_test_workload_A.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_A.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s --duration=5m --display-format=simple --workload A --concurrency 24 >> single_log.tmp

echo "concurrency: 24" >> ../benchmark_output_logs/concurrency_test_workload_A.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_A.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s --duration=5m --display-format=simple --workload A --concurrency 32 >> single_log.tmp

echo "concurrency: 32" >> ../benchmark_output_logs/concurrency_test_workload_A.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_A.out


> single_log.tmp

cockroach workload init ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' --drop --workload B 

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s --duration=5m --display-format=simple --workload B --concurrency 8 >> single_log.tmp

echo "concurrency: 8" >> ../benchmark_output_logs/concurrency_test_workload_B.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_B.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload B --concurrency 16 >> single_log.tmp

echo "concurrency: 16" >> ../benchmark_output_logs/concurrency_test_workload_B.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_B.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload B --concurrency 24 >> single_log.tmp

echo "concurrency: 24" >> ../benchmark_output_logs/concurrency_test_workload_B.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_B.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload B --concurrency 32 >> single_log.tmp

echo "concurrency: 32" >> ../benchmark_output_logs/concurrency_test_workload_B.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_B.out


> single_log.tmp

cockroach workload init ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' --drop --workload C 

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload C --concurrency 8 >> single_log.tmp

echo "concurrency: 8" >> ../benchmark_output_logs/concurrency_test_workload_C.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_C.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload C --concurrency 16 >> single_log.tmp

echo "concurrency: 16" >> ../benchmark_output_logs/concurrency_test_workload_C.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_C.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload C --concurrency 24 >> single_log.tmp

echo "concurrency: 24" >> ../benchmark_output_logs/concurrency_test_workload_C.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_C.out

cockroach workload run ycsb 'postgresql://root@10.1.0.5:26257?sslmode=disable' 'postgresql://root@10.1.0.6:26257?sslmode=disable' 'postgresql://root@10.1.0.7:26257?sslmode=disable' --display-every=30s  --duration=5m --display-format=simple --workload C --concurrency 32 >> single_log.tmp

echo "concurrency: 32" >> ../benchmark_output_logs/concurrency_test_workload_C.out
tail -2 single_log.tmp >> ../benchmark_output_logs/concurrency_test_workload_C.out

rm single_log.tmp
