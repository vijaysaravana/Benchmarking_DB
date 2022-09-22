#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Incorrect Usage. Correct usage: sh run_benchmark_mongo.sh <workload_class>"
fi
echo "This process assumes that cloud infrastructure setup is complete."

# echo "This script will run benchmark tasks for roughly 5-10 minutes. Do you wish to proceed (yes/no):"
# read input
# if [[ $input != "yes" ]]; then
#     echo "Terminating."
#     exit 1
# fi

WD=$1
runtime=`date +"%Y%m%d_%H%M%S"`

rm../benchmark_output_logs/mongodb_YCSB_workload_${WD}_*.out 2> /dev/null
> ../benchmark_output_logs/mongodb_YCSB_workload_${WD}_${runtime}.out

ycsb-0.17.0/bin/ycsb load mongodb -s -P workloads/workload${WD} -p recordcount=100000 -threads 24 -p mongodb.url="mongodb://10.1.0.5:27017" >> ../benchmark_output_logs/mongodb_YCSB_workload_${WD}_${runtime}.out 2>&1

ycsb-0.17.0/bin/ycsb run mongodb -s -P workloads/workload${WD} -p  mongodb.url="mongodb://10.1.0.5:27017" -p operationcount=100000 -threads 24 >> ../benchmark_output_logs/mongodb_YCSB_workload_${WD}_${runtime}.out 2>&1
