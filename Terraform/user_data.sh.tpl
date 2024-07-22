#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -x

apt-get update
apt-get install -y openjdk-11-jre-headless wget unzip s3cmd mongodb-clients jq python2

# Install the latest version of mongosh
sudo curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-mongosh

# Update alternatives to set python2 as the default
update-alternatives --install /usr/bin/python python /usr/bin/python2 1
update-alternatives --install /usr/bin/python python /usr/bin/python3 2
update-alternatives --set python /usr/bin/python2

wget https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
tar xvf ycsb-0.17.0.tar.gz
apt-get install -y mongodb-clients

# Construct the URI with the actual username and password
echo "Initial cluster_uri value: ${cluster_uri}"
CLUSTER_URI="${cluster_uri}"
echo "CLUSTER_URI: $CLUSTER_URI"

MONGODB_URI=$(echo $CLUSTER_URI | sed "s/<username>:<password>/${mongodb_user}:${mongodb_password}/")
echo "Modified MONGODB_URI: $MONGODB_URI"

PRIMARY_NODE=$(mongosh $MONGODB_URI --eval 'rs.isMaster().primary' --quiet | tr -d '"')

cat <<EOL > ~/.s3cfg
[default]
access_key = "${s3_access_key}"
secret_key = "${s3_secret_key}"
host_base = "${s3_endpoint}"
host_bucket = "${s3_bucket_endpoint}"
EOL

./ycsb-0.17.0/bin/ycsb load mongodb -p mongodb.url="mongodb://${mongodb_user}:${mongodb_password}@$PRIMARY_NODE/admin?tls=true" -s -P ./ycsb-0.17.0/workloads/workloada
./ycsb-0.17.0/bin/ycsb run mongodb -p mongodb.url="mongodb://${mongodb_user}:${mongodb_password}@$PRIMARY_NODE/admin?tls=true" -s -P ./ycsb-0.17.0/workloads/workloada
s3cmd --config ~/.s3cfg put output.txt s3://${s3_bucket_name}/ycsb-result.txt
