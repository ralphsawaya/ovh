---
title: MongoDB - Why MongoDB
excerpt: Main reasons to choose mongoDB as your database engine
updated: 2024-06-27
---

## Objective

The purpose of this documentation is to provide a comprehensive guide to the [MongoDB Relational Migrator tool](https://www.mongodb.com/products/tools/relational-migrator). This tool is designed to help users seamlessly migrate their data from traditional relational databases to MongoDB, taking advantage of MongoDB's flexible document model. This document will cover the key features, usage instructions, best practices, and troubleshooting tips for the MongoDB Relational Migrator.

## Introduction

The MongoDB Relational Migrator is a powerful tool designed to facilitate the migration of data from traditional relational databases, such as MySQL, PostgreSQL, and Oracle, to MongoDB. This tool simplifies the complex process of data migration by providing an intuitive interface and automated features to ensure data integrity and consistency.

## Key Features

1. **Schema Discovery and Analysis**: Automatically discovers and analyzes the schema of your relational database, providing insights and recommendations for the migration process.
2. [**Data Transformation and Mapping**](https://www.mongodb.com/docs/relational-migrator/mapping-rules/schema-mapping/#schema-mapping): Supports complex data transformations and mappings, allowing you to adapt the relational data model to MongoDB's document model.
3. [**Automated Migration**](https://www.mongodb.com/developer/products/mongodb/easy-migration-relational-database-mongodb-relational-migrator/): Streamlines the migration process with automated data extraction, transformation, and loading (ETL) capabilities.
4. [**Continuous Data Migration**](https://www.mongodb.com/docs/relational-migrator/jobs/sync-jobs/#sync-jobs): Allows for incremental data migration to minimize downtime and ensure data consistency during the transition period.
5. [**Data Validation**](https://www.mongodb.com/docs/relational-migrator/jobs/data-verification/use-data-verification/#use-data-verification): Provides tools for validating data integrity and consistency post-migration.
6. [**User-Friendly Interface**](https://www.mongodb.com/docs/relational-migrator/getting-started/overview/#user-interface-overview): Offers an intuitive, web-based interface for managing and monitoring the migration process.
7. **Comprehensive Logging and Reporting**: Generates detailed logs and reports for tracking the migration progress and diagnosing issues.

## Getting Started

### Prerequisites

- OVH MongoDB instance
- Access to the relational database you wish to migrate
- Basic understanding of MongoDB and relational database concepts

### Step-by-Step Migration Process
you can refer to the mongodb documentation for a [quick start guide](https://www.mongodb.com/docs/relational-migrator/getting-started/#get-started-with-relational-migrator).

## Migration Scenarios
You can use Relational Migrator to migrate one legacy application at a time to MongoDB. Depending on your application's needs, you can migrate either with or without downtime.
- [Migrate During Scheduled Downtime](https://www.mongodb.com/docs/relational-migrator/getting-started/migration-scenarios/#migrate-during-scheduled-downtime)
- [Migrate Without Downtime](https://www.mongodb.com/docs/relational-migrator/getting-started/migration-scenarios/#migrate-without-downtime)
- [Currently Unsupported Migration Scenarios](https://www.mongodb.com/docs/relational-migrator/getting-started/migration-scenarios/#currently-unsupported-migration-scenarios)

