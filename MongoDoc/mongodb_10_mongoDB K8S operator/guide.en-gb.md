---
title: MongoDB - Why MongoDB
excerpt: Main reasons to choose mongoDB as your database engine
updated: 2024-06-27
---

# Deploying MongoDB Kubernetes Operator on OVHcloud

## Overview

The [MongoDB Kubernetes Operator](https://www.mongodb.com/docs/kubernetes-operator/upcoming/#mongodb-enterprise-kubernetes-operator) enables you to manage MongoDB instances within a Kubernetes cluster. By leveraging Kubernetes, you can automate deployment, scaling, and management of MongoDB databases. OVHcloud offers an [environment that supports the deployment of Kubernetes Operators](https://help.ovhcloud.com/csm/en-ie-public-cloud-kubernetes-deploy-helm-operator?id=kb_article_view&sysparm_article=KB0049802) via Helm, making it easy to integrate MongoDB into your cloud-native applications.

## Installation

For detailed installation instructions, refer to the [MongoDB Kubernetes Operator Installation Guide](https://www.mongodb.com/docs/kubernetes-operator/upcoming/installation/).

## Introduction to MongoDB Kubernetes Operator

The MongoDB Kubernetes Operator streamlines the process of running MongoDB in Kubernetes environments. It automates tasks such as provisioning, scaling, and managing MongoDB clusters, making database management more efficient and reliable.

### Key Features

- **Automated Provisioning**: Simplifies the deployment of MongoDB instances.
- **Scalability**: Automatically scales MongoDB clusters based on resource usage.
- **Self-Healing**: Ensures high availability by automatically detecting and recovering from failures.
- **Backup and Restore**: Integrates with backup solutions to provide data protection.
- **Custom Resource Definitions (CRDs)**: Uses Kubernetes CRDs to define and manage MongoDB resources.

### Resource Specifications

The MongoDB Kubernetes Operator supports the following resource specifications:

- **Ops Manager Resource Specification**: Manages MongoDB Ops Manager deployment and operations.
- **MongoDB User Resource Specification**: Defines user accounts and roles within MongoDB.
- **MongoDB Database Resource Specification**: Manages databases within a MongoDB deployment.
- **Multi-Kubernetes-Cluster Resource Specification**: Supports deployment across multiple Kubernetes clusters.

## Conclusion

Deploying the MongoDB Kubernetes Operator on OVHcloud allows for efficient and scalable management of MongoDB databases. By leveraging the capabilities of Kubernetes and Helm, you can ensure high availability, automated scaling, and robust data management for your applications.

For more details, visit the official [MongoDB Kubernetes Operator documentation](https://github.com/mongodb/mongodb-kubernetes-operator).

## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
