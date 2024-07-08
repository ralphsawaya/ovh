---
title: MongoDB - Why MongoDB
excerpt: Main reasons to choose mongoDB as your database engine
updated: 2024-06-27
---

# Migrating to MongoDB: A Comprehensive Guide to Sizing Your Cluster

Migrating an application from

## Step 1: Understanding Your Current Workload

### Collect Metrics from Your Current Database
- **CPU Usage**: Measure the average and peak CPU usage.
- **Memory Usage**: Note the average and peak memory usage.
- **Disk I/O**: Measure the IOPS (Input/Output Operations Per Second) and throughput.
- **Query Performance**: Collect data on query response times and throughput.
- **Data Size**: Measure the total size of the data and the rate of growth.

Use tools like the following to collect these metrics:
- **Oracle**: Oracle Enterprise Manager, AWR (Automatic Workload Repository) reports.
- **MySQL**: MySQL Enterprise Monitor, `SHOW STATUS` commands.
- **PostgreSQL**: pg_stat_statements, pg_stat_activity, `EXPLAIN ANALYZE`.

## Step 2: Setting Up Benchmarking Tools

### YCSB (Yahoo! Cloud Serving Benchmark)
YCSB is a framework for benchmarking and comparing the performance of various databases. It supports a wide range of workloads and provides a standardized way to measure throughput and latency.

- Install YCSB and set up the workload configurations that match your current database usage patterns.

  ```bash
  git clone https://github.com/brianfrankcooper/YCSB.git
  cd YCSB
  mvn clean package

## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
