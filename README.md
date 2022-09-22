# Database Systems Project - Comparative analysis of MongoDB, Apache HBase and Cockroach DB using YCSB benchmarking techniques


##  Installation Guide
### CockroachDB Installation 
For Linux based system
 1. Download Binary
	``` 
	curl https://binaries.cockroachdb.com/cockroach-v21.2.2.linux-amd64.tgz | tar -xz && sudo cp -i cockroach-v21.2.2.linux-amd64/cockroach /usr/local/bin/
	```
2. 	Create directory for storing external libraries and copy library file	
	``` 
	mkdir -p /usr/local/lib/cockroach
	cp -i cockroach-v21.2.2.linux-amd64/lib/libgeos.so /usr/local/lib/cockroach/
	cp -i cockroach-v21.2.2.linux-amd64/lib/libgeos_c.so /usr/local/lib/cockroach/
	```
	> **Note**: Use sudo prefix for resolving permission errors.
3.  Check Installation by running demo session
	``` 
	cockroach demo
	```
	Execute the query
	```
	> SELECT ST_IsValid(ST_MakePoint(1,2));
	```
	Result should be like
	```
	  st_isvalid
	+-------------+
	    true
	(1 row)
	```

 
> For operating system other than Linux, refer to the [link](https://www.cockroachlabs.com/docs/v21.2/install-cockroachdb.html) for installation.

### Apache HBase Installation 

1. Create a standard storage account on Azure with the following fields
	``` 
	Region: Australia - East
	Performance : Standard
	Replication : Locally-redundant storage(LRS)
	``` 
2. Create an HDInsight HBase cluster
	``` 
	Region: Australia - East
	Cluster Type : HBase 2.1.6 (HDI 4.0)
	Details for the storage tab :
	Selection Method: Choose Radio button Use access key
	Storage account name: Enter the name of the Standard storage account created earlier
	Access Key:Enter the key1 access key for the standard storage account
	Head Node - E4 V3 (2),
	Zookeeper Node - A2 V2 (3),
	Region Node - D12 V2 (4)
	``` 
Reference : https://techcommunity.microsoft.com/t5/analytics-on-azure-blog/azure-hdinsight-hbase-cluster-performance-comparison-using-ycsb/ba-p/1548530

### MongoDB Installation 

Part 1 : In each VM of the cluster (we are using a 3 VM cluster), install MongoDB with the following steps.

1. Update local packages. 
	```
	sudo apt-get update
	```

2. Import MongoDB 5.0 public key used by package manager. This should return OK.
	``` 
	wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
	``` 
3. Create MongoDB List file.
	```
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list	
	```
4. Install MongoDB packages.
	```
	sudo apt-get install -y mongodb-org
	```

Part 2 : Replica Set setup

1. Start the replica set daemon in each of the VMs.
	```
	mongod --replSet "rs0" --bind_ip localhost,<Virtual NW IP of the machine>
	```

2. Open another terminal while mongo daemon is running on the instances. Open mongo shell. This should be the primary node.
	```
	mongo
	```
3. Instantiate the replica set. Make sure all host ips are virtual network IPs.
	```
	rs.initiate( {
	   _id : "rs0",
	   members: [
	      { _id: 0, host: "<hostip1>:27017" },
	      { _id: 1, host: "<hostip2>:27017" },
	      { _id: 2, host: "<hostip3>:27017" }
	   ]
	})
	```

Success! You have now setup the 3 node replica set.

Installation Reference : https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
Cluster - Replica set setup Reference : https://docs.mongodb.com/manual/tutorial/deploy-replica-set/

##  Running Instructions

### CockroachDB  
- In Azure Cloud:
	1. Create a separate VM instance in the same virtual network as cluster. This machine will be used as client to connect to cluster.  
	2. Install Cockroach on the client and initialze the connector.
		```
		cockroach init --insecure --host=<address of any node on --join list>
		```
	3. Clone this repositiory on the machine.
	4. Run the following commands:
		```
		cd scripts
		bash run_benchmark_cockroach.sh <Workload Class in upper case> <Hostname(IP) of Node 1> <Hostname(IP) of Node 2> <Hostname(IP) of Node 3>
		```
	For eg.
		```
		bash run_benchmark_cockroach.sh A 10.1.0.5 10.1.0.6 10.1.0.7
		```

### Apache HBase

- In Azure Cloud:
	1. Login to HDInsights cluster
		``` 
		ssh <user-name>@<cluster-name>-ssh.azurehdinsight.net
		```
	2. Launch HBase Shell and run the subsequent operations.
		```
		hbase shell

		 hbase_shell> n_splits = 100	
		 hbase_shell> create 'usertable', 'cf', {SPLITS => (1..n_splits).map {|i| "user#{1000+i*(9999-1000)/n_splits}"}}
		 hbase_shell> exit
		```
	3. Clone this repository at the remote server 
		```
		cd scripts
		bash run_benchmark_hbase.sh <Workload Class in lower case> 
		```
	For eg.  
		```
		bash run_benchmark_hbase.sh a
		```

### MongoDB
	
1. Start all the 3 instances of the cluster and SSH into them. 
	
2. Start the mongod processes in each machine. 
	```
	sudo mongod --replSet rs0 --bind_ip localhost,<Machine IP> --dbpath mongoDBPath
	```

3. Open a new terminal in the primary machine and run the benchmark with this command.
	```
	bash run_benchmark_mongodb.sh a
	```
	
## Reproducing Figures
- Azure  
	After executing the benchmarks, the output logs from each benchmark test are stored under the benchmark_output_logs directory. 
	Then you can execute the following to produce images in benchmark_plots directory:
	``` 
	cd scripts
	bash generate_figures_from_logs.sh
	```
