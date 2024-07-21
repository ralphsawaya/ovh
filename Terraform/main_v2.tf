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
  auth_url    = var.openstack_auth_url
  domain_name = var.openstack_domain_name
  tenant_name = var.openstack_tenant_name
  user_name   = var.openstack_user_name
  password    = var.openstack_password
  region      = var.openstack_region
}

resource "openstack_compute_keypair_v2" "ssh_keypair2" {
  name = "ssh_keypair2"
}

resource "openstack_networking_network_v2" "my_private_network" {
  name           = "my_private_network"
  admin_state_up = "true"
  region         = var.openstack_region
}

resource "openstack_networking_subnet_v2" "my_subnet" {
  name            = "my_subnet"
  network_id      = openstack_networking_network_v2.my_private_network.id
  cidr            = "192.168.199.0/24"
  ip_version      = 4
  enable_dhcp     = true
  no_gateway      = false
  dns_nameservers = ["213.186.33.99"]

  allocation_pool {
    start = "192.168.199.100"
    end   = "192.168.199.200"
  }
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

resource "openstack_networking_secgroup_v2" "ssh_secgroup" {
  name        = "ssh_secgroup"
  description = "Security group for SSH access"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_secgroup.id
}

resource "openstack_compute_instance_v2" "vm" {
  name            = "ycsb-benchmark-vm"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh_keypair2.name
  security_groups = [openstack_networking_secgroup_v2.ssh_secgroup.name]

  network {
    name      = "Ext-Net"
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user_data.log 2>&1
              set -x

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

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Update this to your instance's user
      private_key = openstack_compute_keypair_v2.ssh_keypair2.private_key
      host        = self.access_ip_v4
    }

    inline = [
      "cat /var/log/user_data.log"
    ]
  }
}

resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
  service_name = ovh_cloud_project_database.service.service_name
  ip           = "${openstack_compute_instance_v2.vm.access_ip_v4}/32"
  description  = "Allow access from YCSB benchmark VM"
  cluster_id   = ovh_cloud_project_database.service.id
  engine       = ovh_cloud_project_database.service.engine
}

output "network_id" {
  value = openstack_networking_network_v2.my_private_network.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.my_subnet.id
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

output "ssh_private_key" {
  value     = openstack_compute_keypair_v2.ssh_keypair2.private_key
  sensitive = true
}
