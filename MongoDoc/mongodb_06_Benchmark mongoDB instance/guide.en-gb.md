---
title: MongoDB - Benchmark MongoDB Instances
excerpt: Benchmark MongoDB Instances
updated: 2024-06-27
---

# Objective

In this documentation, we will discuss a step-by-step approach to benchmark and size your MongoDB cluster based on a specific load. This includes estimating resource requirements, configuring your cluster, and comparing network performance.

## Setting Up Benchmarking Tools

### YCSB (Yahoo! Cloud Serving Benchmark)
[YCSB](https://github.com/brianfrankcooper/YCSB) is a framework for benchmarking and comparing the performance of various databases. It supports a wide range of workloads and provides a standardized way to measure throughput and latency.

- Go through the [README](https://github.com/brianfrankcooper/YCSB/?tab=readme-ov-file#links) to install YCSB.
- Refer to the [MongoDB README](https://github.com/brianfrankcooper/YCSB/tree/master/mongodb) to run YCSB on MongoDB.

### SimRunner
[SimRunner](https://github.com/schambon/SimRunner) is a tool that binds:

- a powerful data generator for MongoDB
- a declarative and highly scalable workload generator

Install SimRunner and configure it to simulate the load based on your current database metrics, and then create a configuration file for SimRunner that mimics your current workload.

## Run YCSB on OVHcloud MongoDB
> [!WARNING]  
> With YCSB version 0.17.0, make sure you have Python 2 installed, as YCSB will encounter errors if Python 3 is used.

### STEP 1: Determine Primary node of MongoDB cluster
- Connect to the MongoDB cluster with the mongoshell, and then issue the command `rs.status()`.
- Find the element with `members.stateStr: 'PRIMARY'` .
- Take note of the value of the `members.name` field for that element. eg. `name: 'node2-0b70a1b78fff6c0e-admin.database.cloud.ovh.net:27017'`. You will use it in STEP 2 to load and run YCSB.

### STEP 2: Load Data into MongoDB - Example loading the provided `workloada`
While located in the `YCSB > ycsb-0.17.0` directory, execute the following command with the provided `workloada` to load data into MongoDB.
```javascript
./bin/ycsb load mongodb -p mongodb.url="mongodb://myuser:mypassword@node2-0b70a1b78fff6c0e.database.cloud.ovh.net:27017/admin?replicaSet=replicaset&ssl=true" -s -P workloads/workloada
```

![alt text](./images/YCSBLoad.png)

Verify that the database `ycsb` and collection `usertable` got created and loaded with data.

### STEP 3: 
While located in the `YCSB > ycsb-0.17.0` directory, execute the following command with the provided `workloada` to run the workload.
```javascript
./bin/ycsb run mongodb -p mongodb.url="mongodb://myuser:mypassword@node2-0b70a1b78fff6c0e.database.cloud.ovh.net:27017/admin?replicaSet=replicaset&ssl=true" -s -P workloads/workloada
```
![alt text](./images/YCSBrun.png)

### CPU and Memory
- Use the metrics collected from your current database to estimate the CPU and memory requirements. Ensure to account for peak usage.
- Perform benchmarking using YCSB and SimRunner to see how MongoDB handles your workload. Adjust the configurations to achieve optimal performance.

### Disk I/O and Storage
- MongoDB's storage engine (WiredTiger by default) is designed to handle high IOPS efficiently. Compare the IOPS requirements with the results from your benchmarks.
- Consider the total data size and the rate of growth to estimate the storage requirements. MongoDB compresses data, so account for the compression ratio when sizing storage.

## Step 4: Select OVH cloud Plan
- Based on the metrics collected (CPU, RAM, Disk IOPS, Disk Space, etc.), choose an OVH cloud plan that meets or exceeds the current specifications of your MongoDB instance.
- Consider future growth and scalability needs. You might want to consider how to [size a MongoDB cluster](https://github.com/ralphsawaya/ovh/blob/main/MongoDoc/mongodb_02_Best_practise_to_implement%20_your_first_mongoDB_instance/guide.en-gb.md#mongodb-cluster-sizing).

## Step 5: Setup OVH cloud Cluster
- **Create Cluster**: [Set up the new OVH managed MongoDB cluster](https://help.ovhcloud.com/csm/en-public-cloud-databases-getting-started?id=kb_article_view&sysparm_article=KB0048745).
- **Configuration**: Configure the OVH cloud cluster settings to match your current MongoDB cluster's configuration as closely as possible.

## Step 6: Performance Testing
- Run performance tests using YCSB and SimRunner on your MongoDB cluster.
- Monitor the performance and adjust the cluster size and configurations as needed.

## Step 7: Validation
- Validate that your application performs as expected with MongoDB.
- Ensure that all functionalities are working correctly and that the performance meets your requirements.

## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
