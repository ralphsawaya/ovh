---
title: MongoDB - Benchmark MongoDB Instances
excerpt: Benchmark MongoDB Instances
updated: 2024-06-27
---

# Objective

In this documentation, we will discuss a step-by-step approach to benchmark and size your OVHcloud MongoDB cluster based on a specific load. This includes estimating resource requirements, configuring your cluster, and comparing network performance.

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

## Benchmark Process with YCSB and SimRunner
> [!WARNING]  
> With YCSB version 0.17.0, make sure you have Python 2 installed, as YCSB will encounter errors if Python 3 is used.

### STEP 0: Set up an OVHcloud MongoDB Cluster
- [Set up the OVH MongoDB cluster](https://help.ovhcloud.com/csm/en-public-cloud-databases-getting-started?id=kb_article_view&sysparm_article=KB0048745).

### STEP 1: Determine Primary node of MongoDB cluster
1. Connect to the MongoDB cluster with the mongoshell, and then issue the command `rs.status()`.
2. Find the element with `members.stateStr: 'PRIMARY'` .
3. Take note of the value of the `members.name` field for that element. eg. `name: 'node2-0b70a1b78fff6c0e-admin.database.cloud.ovh.net:27017'`. You will use it in STEP 3 to load and run YCSB.

### STEP 2: Configure The YCSB Workload
YCSB provide pre-configured workloads under the `ycsb-0.17.0 > workloads` folder. You can setup your own workload based on the behavior of your application.

### STEP 3: Load Data into MongoDB with YCSB - Example Loading the Provided `workloada`
While located in the `ycsb-0.17.0` directory, execute the following command with the provided `workloada` to load data into MongoDB.
```javascript
./bin/ycsb load mongodb -p mongodb.url="mongodb://myuser:mypassword@node2-0b70a1b78fff6c0e.database.cloud.ovh.net:27017/admin?replicaSet=replicaset&ssl=true" -s -P workloads/workloada
```
![alt text](./images/YCSBLoad.png)

Verify that the database `ycsb` and collection `usertable` got created and loaded with data.

### STEP 4: Run The YCSB Workload - Example Running the Provided `workloada`
While located in the `YCSB > ycsb-0.17.0` directory, execute the following command with the provided `workloada` to run the workload.
```javascript
./bin/ycsb run mongodb -p mongodb.url="mongodb://myuser:mypassword@node2-0b70a1b78fff6c0e.database.cloud.ovh.net:27017/admin?replicaSet=replicaset&ssl=true" -s -P workloads/workloada
```
![alt text](./images/YCSBrun.png)

### STEP 5: Analyze and Benchmark the YCSB Output Metrics
Take note of the run command output in STEP 4, and benchmark it with other databases.

### Step 6: Select OVH cloud Plan
- Based on the metrics collected (CPU, RAM, Disk IOPS, Disk Space, etc.), choose an OVH cloud plan that meets the requirements of your application.
- Consider future growth and scalability needs. You might want to consider how to [size a MongoDB cluster](https://github.com/ralphsawaya/ovh/blob/main/MongoDoc/mongodb_02_Best_practise_to_implement%20_your_first_mongoDB_instance/guide.en-gb.md#mongodb-cluster-sizing).

### Step 7: Setup OVH cloud Cluster
- [Set up the OVHcloud MongoDB cluster](https://help.ovhcloud.com/csm/en-public-cloud-databases-getting-started?id=kb_article_view&sysparm_article=KB0048745).

### Step 8: Performance Testing With SimRunner 
- Go through the [README](https://github.com/schambon/SimRunner?tab=readme-ov-file#) to install and run SimRunner.
- Run performance tests using SimRunner on your MongoDB cluster: `java -jar SimRunner.jar <config file>`. Here is an example of a configuration file:
```json
{
    "connectionString": "mongodb+srv://myuser:mypassword@mongodb-8fff6c0e-o01ba0bef.database.cloud.ovh.net/admin?replicaSet=replicaset&ssl=true",
    "reportInterval": 1000,
    "http": {
        "enabled": false,
        "port": 3000,
        "host": "localhost"
    },
    "mongoReporter": {
        "enabled": true,
        "connectionString": "mongodb://localhost:27017",
        "database": "simrunner",
        "collection": "report",
        "drop": false,
        "runtimeSuffix": false
    },
    "templates": [
        {
            "name": "person",
            "database": "test",
            "collection": "people",
            "drop": false,
            "template": {
                "_id": "%objectid",
                "first": "%name.firstName",
                "last": "%name.lastName",
                "birthday": "%date.birthday"
            },
            "remember": ["_id", { "field": "first", "preload": false}],
            "indexes": []
        }
    ],
    "workloads": [
        {
            "name": "Insert some people",
            "template": "person",
            "op": "insert",
            "threads": 1,
            "pace": 100,
            "batch": 1000
        },
        {
            "name": "Find people by key",
            "template": "person",
            "op": "find",
            "params": {
                "filter": { "_id": "#_id" }
            },
            "threads": 4
        }
    ]
}
```

![alt text](./images/simRunnerRun.png)

- The report output, `mongoReporter`,  of the execution was set to be stored on the locally running MongoDB: `"connectionString": "mongodb://localhost:27017"`
- Monitor the performance and adjust the cluster size and configurations as needed.



## Step 9: Validation
- Validate that your application performs as expected with MongoDB.
- Ensure that all functionalities are working correctly and that the performance meets your requirements.

## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
