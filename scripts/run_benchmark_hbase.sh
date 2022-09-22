#!/bin/bash
if [[ $# -ne 1 ]]; then
    echo "Incorrect Usage. Correct usage: sh run_benchmark_hbase.sh <workload_class>"
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

rm../benchmark_output_logs/hbase_YCSB_workload_${WD}_*.out 2> /dev/null
> ../benchmark_output_logs/hbase_YCSB_workload_${WD}_${runtime}.out

ycsb-0.17.0/bin/ycsb load hbase12 -P ycsb-0.17.0/workloads/workload${WD} -p table=usertable -p columnfamily=cf -p recordcount=100000 -p threadcount=24 -cp /etc/hbase/conf -s |& tee -a ../benchmark_output_logs/hbase_YCSB_workload_${WD}_${runtime}.out
 

ycsb-0.17.0/bin/ycsb run hbase12 -P ycsb-0.17.0/workloads/workload${WD} -p table=usertable -p columnfamily=cf -p recordcount=100000 -p operationcount=100000 -p threadcount=24 -cp /etc/hbase/conf -s |& tee -a ../benchmark_output_logs/hbase_YCSB_workload_${WD}_${runtime}.out