#!/bin/bash
if [[ $# -ne 4 ]]; then
    echo "Incorrect Usage. Correct usage: sh run_benchmark_cockroach.sh <workload_class> <node1_ip> <node2_ip> <node3_ip>"
fi
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

# echo "This script will run benchmark tasks for roughly 10 minutes. Do you wish to proceed (yes/no):"
# read input
# if [[ $input != "yes" ]]; then
#     echo "Terminating."
#     exit 1
# fi

WD=$1 
host1_ip=$2
host2_ip=$3
host3_ip=$4
runtime=`date +"%Y%m%d_%H%M%S"`
 
rm ../benchmark_output_logs/cockroach_YCSB_workload_${WD}_*.out 2> /dev/null
> ../benchmark_output_logs/cockroach_YCSB_workload_${WD}_${runtime}.out

 

cockroach workload init ycsb "postgresql://root@"${host1_ip}":26257?sslmode=disable" "postgresql://root@"${host2_ip}":26257?sslmode=disable" "postgresql://root@"${host3_ip}":26257?sslmode=disable" --drop --insert-count=100000 --concurrency=24 --workload ${WD} |& tee -a ../benchmark_output_logs/cockroach_YCSB_workload_${WD}_${runtime}.out

 

cockroach workload run ycsb "postgresql://root@"${host1_ip}":26257?sslmode=disable" "postgresql://root@"${host2_ip}":26257?sslmode=disable" "postgresql://root@"${host3_ip}":26257?sslmode=disable" --insert-count=100000 --max-ops=100000 --concurrency=24 --display-every=20s --display-format=simple --duration=10m --workload ${WD} |& tee -a ../benchmark_output_logs/cockroach_YCSB_workload_${WD}_${runtime}.out



