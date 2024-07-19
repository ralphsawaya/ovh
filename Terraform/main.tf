terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 2.0.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = ">= 0.46.1"
    }
  }
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3"
  domain_name = "Default"
  tenant_name = "7388611843274102"
  user_name    = "user-Q7uqJgqswA4j"
  password    = "7Beca68WqANWnj5krTAX5JpVNypGvxYB"
  region      = "UK1"
}

resource "openstack_compute_keypair_v2" "ssh_keypair" {
  name       = "ssh_keypair"
}

resource "openstack_networking_network_v2" "my_private_network" {
  name = "my_private_network"
}

resource "openstack_networking_subnet_v2" "my_subnet" {
  name       = "my_subnet"
  network_id = openstack_networking_network_v2.my_private_network.id
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

resource "ovh_cloud_project_database" "service" {
  service_name = var.ovh_project_id
  description  = "mongodb-benchmark"
  engine       = "mongodb"
  version      = "7.0"
  plan         = "production"
  flavor       = "db2-2"

  nodes {
    region     = var.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region     = var.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
  nodes {
    region     = var.region
    subnet_id  = openstack_networking_subnet_v2.my_subnet.id
    network_id = openstack_networking_network_v2.my_private_network.id
  }
}

resource "ovh_cloud_project_database_mongodb_user" "tf_user" {
  service_name = ovh_cloud_project_database.service.service_name
  cluster_id   = ovh_cloud_project_database.service.id
  name         = "tf_mongodb_user"
  roles        = ["readWriteAnyDatabase@admin"]
}

resource "openstack_compute_instance_v2" "vm" {
  name            = "ycsb-benchmark-vm"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh_keypair.name
  security_groups = ["default"]

  network {
    uuid = openstack_networking_network_v2.my_private_network.id
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y openjdk-11-jre-headless wget unzip s3cmd mongodb-clients jq
              wget https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
              tar xvf ycsb-0.17.0.tar.gz
              apt-get install -y mongodb-clients
              PRIMARY_NODE=$(mongosh --host ${ovh_cloud_project_database.service.endpoints[0].uri} --tls --username ${ovh_cloud_project_database_mongodb_user.tf_user.name} --password '${ovh_cloud_project_database_mongodb_user.tf_user.password}' --authenticationDatabase admin --eval 'rs.isMaster().primary' --quiet | tr -d '"')
              cat <<EOL > ~/.s3cfg
              [default]
              access_key = "${var.ovh_s3_access_key}"
              secret_key = "${var.ovh_s3_secret_key}"
              host_base = "${var.ovh_s3_endpoint}"
              host_bucket = "${var.ovh_s3_bucket_endpoint}"
              EOL
              ./ycsb-0.17.0/bin/ycsb load mongodb -p mongodb.url="mongodb://${ovh_cloud_project_database_mongodb_user.tf_user.name}:${ovh_cloud_project_database_mongodb_user.tf_user.password}@$PRIMARY_NODE/admin?tls=true" -s -P ./ycsb-0.17.0/workloads/workloada
              ./ycsb-0.17.0/bin/ycsb run mongodb -p mongodb.url="mongodb://${ovh_cloud_project_database_mongodb_user.tf_user.name}:${ovh_cloud_project_database_mongodb_user.tf_user.password}@$PRIMARY_NODE/admin?tls=true" -s -P ./ycsb-0.17.0/workloads/workloada
              s3cmd --config ~/.s3cfg put output.txt s3://${var.ovh_s3_bucket_name}/ycsb-result.txt
              shutdown -h now
              EOF
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.service.service_name
  ip           = openstack_compute_instance_v2.vm.access_ip_v4
  description  = "Allow access from YCSB benchmark VM"
  cluster_id   = ovh_cloud_project_database.service.id
  engine       = ovh_cloud_project_database.service.engine
}

output "cluster_uri" {
  value = ovh_cloud_project_database.service.endpoints[0].uri
}

output "vm_ip" {
  value = openstack_compute_instance_v2.vm.access_ip_v4
}

output "user_name" {
  value = ovh_cloud_project_database_mongodb_user.tf_user.name
}

output "user_password" {
  value     = ovh_cloud_project_database_mongodb_user.tf_user.password
  sensitive = true
}
