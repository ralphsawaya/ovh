# MongoDB Backup and Restore Demo

## Introduction

### Environment Setup:
- **Source VM:**
  - Running MongoDB Enterprise
  - Databases: `mydb1`, `mydb2`
  - Collections: `mycollection1`, `mycollection2`
  - Each collection contains 100 documents

- **Destination Cluster:**
  - Hosted on OVHcloud
  - Running MongoDB Enterprise
  - Databases `mydb1` and `mydb2` are not yet present

- **Pre-requisites:**
  - Whitelist VM IP on OVHcloud cluster
  - Create a user with the following roles on OVHcloud MongoDB:
    - `dbAdminAnyDatabase@admin`
    - `readWriteAnyDatabase@admin`
    - `restore@admin`
    - `userAdminAnyDatabase@admin`

- **Tools:**
  - MongoDB Enterprise installation includes `mongodb-database-tools` package (contains `mongodump` and `mongorestore`)

## Demo Steps
1. **Check MongoDB installtion on VM and OVH:**
   - Verify MongoDB packages installed on VM and connect with mongosh.
   - Verify the MongoDB OVHcloud installtion with users and IP whitelisting.
   
3. **Mongodump Command:**
   - Demonstrate how to use `mongodump` to back up the databases from the source VM.

4. **Mongorestore Command:**
   - Show the use of `mongorestore` to restore the backup to the OVHcloud MongoDB cluster.

5. **Verification:**
   - Verify that the data has been successfully restored to the OVHcloud MongoDB cluster.

## Conclusion

- Successful backup and restoration of MongoDB databases using `mongodump` and `mongorestore`.
- Ensured data integrity and availability across different environments.
- Simplified process to manage database migrations and backups using MongoDB tools.
