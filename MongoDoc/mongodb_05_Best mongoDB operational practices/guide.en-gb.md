---
title: MongoDB - Why MongoDB
excerpt: Main reasons to choose mongoDB as your database engine
updated: 2024-06-27
---

## Objective

This articles discusses essential best practices for managing MongoDB post-deployment. Key areas of focus include monitoring, backup strategies, security measures, upgrade procedures, and user and roles management. By following these guidelines, you can ensure your MongoDB environment remains secure, reliable, and performant, thus maximizing the efficiency and effectiveness of your database operations.


# MongoDB Post-Deployment Operational Best Practices

## 1. Monitoring
- **OVH Built-in Monitoring Tools:**
  - [**Metrics tab**](https://help.ovhcloud.com/csm/en-ie-public-cloud-databases-mongodb-monitoring?id=kb_article_view&sysparm_article=KB0061661): Provides comprehensive monitoring dashboards.
- **Third-Party Tools:**
  - **Prometheus:** Integrates with MongoDB Exporter for metrics collection.
  - **Grafana:** Visualizes metrics collected by Prometheus.
  - **Datadog:** Offers deep MongoDB integration for metrics and alerts.
- **Key Metrics to Monitor:**
  - **Operation Performance:** Latency, throughput, and queue depth.
  - **Memory Usage:** Resident memory, virtual memory, and page faults.
  - **Connections:** Number of active connections.
  - **Replication Status:** Oplog lag, replication headroom.
  - **Storage Metrics:** Disk usage, index usage, and fragmentation.

## 2. Backup
- **Automated Backup Solutions:**
  - **OVH :** ????.
- **Backup Strategies:**
  - **Snapshot-based Backups:** Regular snapshots of the data.
  - **Oplog-based Continuous Backups:** Captures all changes from the oplog.
- **Backup Best Practices:**
  - **Frequency:** Regular backups (daily or hourly) depending on data criticality.
  - **Retention Policy:** Define retention policies to balance cost and availability.
  - **Testing:** Regularly test backup restoration to ensure data integrity.
  - **Encryption:** Ensure backups are encrypted at rest and in transit.

## 3. Security
- **Authentication and Authorization:**
  - **Enable Authentication:** Use SCRAM, LDAP, or Kerberos.
  - **Role-Based Access Control (RBAC):** Assign specific roles and permissions.
- **Encryption:**
  - **At-Rest Encryption:** Enable storage encryption.
  - **In-Transit Encryption:** Use TLS/SSL for data encryption over the network.
- **Network Security:**
  - **Firewall:** Restrict access to MongoDB instances.
  - **IP Whitelisting:** Allow only trusted IP addresses to access the database.
- **Auditing:**
  - **Enable Auditing:** Track and log all access and administrative actions.
  - **Review Logs:** Regularly review audit logs for suspicious activities.

## 4. Upgrades
- **Version Compatibility:**
  - **Check Compatibility:** Ensure new MongoDB versions are compatible with your applications and drivers.
  - **Read Release Notes:** Understand new features, bug fixes, and deprecations.
- **Testing:**
  - **Test Environment:** Upgrade in a staging environment first.
  - **Data Integrity:** Ensure data consistency and integrity post-upgrade.
- **Backup Before Upgrade:**
  - **Full Backup:** Perform a full backup before starting the upgrade.
- **Rolling Upgrades:**
  - **Replica Sets:** Upgrade secondary nodes first, then the primary.
  - **Sharded Clusters:** Upgrade the config servers, then the shard servers.
- **Upgrade Path:**
  - **Follow the Recommended Path:** Use the documented upgrade paths provided by MongoDB.

## 5. Users and Roles Management
- **User Management:**
  - **Create Users with Specific Roles:** Assign roles based on the principle of least privilege.
  - **Disable Unused Accounts:** Regularly review and disable inactive accounts.
- **Role Management:**
  - **Custom Roles:** Create custom roles if default roles do not meet specific requirements.
  - **Role Audit:** Periodically audit roles and permissions.
- **Password Management:**
  - **Strong Passwords:** Enforce strong password policies.
  - **Rotation Policies:** Implement regular password rotation policies.
- **Multi-Factor Authentication (MFA):**
  - **Enable MFA:** Add an extra layer of security for administrative accounts.

## 6. Performance Tuning
- **Indexes:**
  - **Use Appropriate Indexes:** Create indexes to support query patterns.
  - **Index Management:** Regularly review and optimize indexes.
- **Sharding:**
  - **Enable Sharding:** Distribute data across multiple servers for scalability.
  - **Shard Keys:** Choose effective shard keys based on query patterns and data distribution.
- **Configuration Optimization:**
  - **Memory Allocation:** Adjust `wiredTigerCacheSizeGB` for optimal performance.
  - **Connection Limits:** Set appropriate limits for maximum connections.
- **Query Optimization:**
  - **Analyze Queries:** Use the explain plan to understand query performance.
  - **Avoid Long-Running Queries:** Identify and optimize long-running queries.

By following these best practices, you can ensure your MongoDB deployment remains secure, reliable, and performs optimally post-deployment. Regular monitoring, robust backup strategies, stringent security measures, meticulous upgrade procedures, and efficient user and role management are key to successful MongoDB operations.


## We want your feedback!

We would love to help answer questions and appreciate any feedback you may have.

If you need training or technical assistance to implement our solutions, contact your sales representative or click on [this link](https://www.ovhcloud.com/en-gb/professional-services/) to get a quote and ask our Professional Services experts for a custom analysis of your project. Join our community of users on <https://community.ovh.com/en/>.

Are you on Discord? Connect to our channel at <https://discord.gg/ovhcloud> and interact directly with the team that builds our databases service!
