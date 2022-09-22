pip install -r requirements.txt

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_A_*.out > cockroach_final_output_A.out
tail -33 ../benchmark_output_logs/mongodb_YCSB_workload_a_*.out > mongo_final_output_A.out
tail -33 ../benchmark_output_logs/hbase_YCSB_workload_a_*.out > hbase_final_output_A.out

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_B_*.out > cockroach_final_output_B.out
tail -33 ../benchmark_output_logs/mongodb_YCSB_workload_b_*.out > mongo_final_output_B.out
tail -33 ../benchmark_output_logs/hbase_YCSB_workload_b_*.out > hbase_final_output_B.out

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_C_*.out > cockroach_final_output_C.out
tail -26 ../benchmark_output_logs/mongodb_YCSB_workload_c_*.out > mongo_final_output_C.out
tail -26 ../benchmark_output_logs/hbase_YCSB_workload_c_*.out > hbase_final_output_C.out

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_D_*.out > cockroach_final_output_D.out
tail -33 ../benchmark_output_logs/mongodb_YCSB_workload_d_*.out > mongo_final_output_D.out
tail -33 ../benchmark_output_logs/hbase_YCSB_workload_d_*.out > hbase_final_output_D.out

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_E_*.out > cockroach_final_output_E.out
tail -33 ../benchmark_output_logs/mongodb_YCSB_workload_e_*.out > mongo_final_output_E.out
tail -33 ../benchmark_output_logs/hbase_YCSB_workload_e_*.out > hbase_final_output_E.out

tail -2 ../benchmark_output_logs/cockroach_YCSB_workload_F_*.out > cockroach_final_output_F.out
tail -39 ../benchmark_output_logs/mongodb_YCSB_workload_f_*.out > mongo_final_output_F.out
tail -39 ../benchmark_output_logs/hbase_YCSB_workload_f_*.out > hbase_final_output_F.out

python3 generate_figures.py cockroach_final_output_A.out mongo_final_output_A.out hbase_final_output_A.out A
python3 generate_figures.py cockroach_final_output_B.out mongo_final_output_B.out hbase_final_output_B.out B
python3 generate_figures.py cockroach_final_output_C.out mongo_final_output_C.out hbase_final_output_C.out C
python3 generate_figures.py cockroach_final_output_D.out mongo_final_output_D.out hbase_final_output_D.out D
python3 generate_figures.py cockroach_final_output_E.out mongo_final_output_E.out hbase_final_output_E.out E
python3 generate_figures.py cockroach_final_output_F.out mongo_final_output_F.out hbase_final_output_F.out F

rm *final_output_*.out


if [[ ! -f "../benchmark_output_logs/concurrency_test_workload_A.out" ]]; then
    echo "Concurrency test file log A not present. Run concurrency tests to generate the log files."
elif [[ ! -f "../benchmark_output_logs/concurrency_test_workload_B.out" ]]; then
    echo "Concurrency test file log B not present. Run concurrency tests to generate the log files."
elif [[ ! -f "../benchmark_output_logs/concurrency_test_workload_C.out" ]]; then
    echo "Concurrency test file log C not present. Run concurrency tests to generate the log files."
else
    python3 generate_concurrency_figures.py
fi