---
title: MongoDB - Why MongoDB
excerpt: Main reasons to choose mongoDB as your database engine
updated: 2024-06-27
---

## Objective

The primary objective of this documentation is to provide a comprehensive, step-by-step approach to MongoDB database migration, ensuring data integrity, minimal downtime, and optimal performance. Whether you are migrating to a new MongoDB instance from an existing MongoDB instance, or transitioning from an RDBMS to MongoDB, this guide covers the essential tools and processes required for a successful migration.

## Migration Tools

### Tools Used to Prepare for Migration

These tools are used for preparation, simulation, and design before starting the actual migration process.

#### 1. SimRunner
[SimRunner](https://github.com/schambon/SimRunner) is a simulation tool designed to help test and validate data migration scenarios. It is useful for identifying potential issues before performing actual migrations.

#### 2. YCSB (Yahoo! Cloud Serving Benchmark)
[YCSB](https://github.com/brianfrankcooper/YCSB/blob/master/mongodb/README.md) is a benchmarking tool for evaluating the performance of different databases, including MongoDB. It helps in understanding the performance characteristics and ensuring that the migrated database meets the required performance standards.

#### 3. MongoDB Relational Migrator
[MongoDB Relational Migrator](https://www.mongodb.com/docs/relational-migrator/) is designed to simplify the process of migrating data from relational databases to MongoDB. It provides an intuitive interface and powerful mapping features to transform and import data efficiently.

### Tools Used to execute the Migration - With Downtime

These tools are used during migration processes where some expected downtime.

#### 1. mongodump
[mongodump](https://www.mongodb.com/docs/database-tools/mongodump/) is a utility for creating a binary export of the contents of a MongoDB database. It is particularly useful for backing up databases and migrating data between MongoDB instances.

#### 2. mongorestore
[mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/) complements mongodump by allowing you to restore a binary dump created by mongodump. This tool is essential for restoring data to a MongoDB instance.

### Tools Used to execute the Migration - Minimal Downtime

These tools are designed to minimize downtime during the migration process.

#### 1. mongosync
The [mongosync](https://www.mongodb.com/docs/cluster-to-cluster-sync/current/reference/mongosync/) binary is the primary process used in Cluster-to-Cluster Sync. mongosync migrates data from one cluster to another and can keep the clusters in continuous sync.

#### 2. MongoDB Relational Migrator
[MongoDB Relational Migrator](https://www.mongodb.com/docs/relational-migrator/) is designed to simplify the process of migrating data from relational databases to MongoDB. It provides an intuitive interface and powerful mapping features to transform and import data efficiently.

#### 3. MongoDB Kafka Connector
[MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/) allows you to integrate MongoDB with Apache Kafka, enabling real-time data synchronization and minimizing downtime during migrations by streaming data changes directly to MongoDB.

## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
