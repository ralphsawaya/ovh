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

resource "openstack_compute_keypair_v2" "ssh_keypair5" {
  name = "ssh_keypair5"
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
  description  = "mongodb-bench"
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

resource "openstack_networking_secgroup_v2" "ssh_secgroup5" {
  name        = "ssh_secgroup5"
  description = "Security group for SSH access"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_secgroup5.id
}

locals {
  # Extract the username part from the mongodb_user value
  mongodb_username = split("@", ovh_cloud_project_database_mongodb_user.tf_user.name)[0]
}

resource "openstack_compute_instance_v2" "vm" {
  name            = "ycsb-benchmark-vm"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh_keypair5.name
  security_groups = [openstack_networking_secgroup_v2.ssh_secgroup5.name]

  network {
    name = "Ext-Net"
  }

  user_data = templatefile("user_data.sh.tpl", {
    cluster_uri = ovh_cloud_project_database.service.endpoints[0].uri
    mongodb_user = ovh_cloud_project_database_mongodb_user.tf_user.name
    mongodb_password = ovh_cloud_project_database_mongodb_user.tf_user.password
    s3_access_key = var.ovh_s3_access_key
    s3_secret_key = var.ovh_s3_secret_key
    s3_endpoint = var.ovh_s3_endpoint
    s3_bucket_endpoint = var.ovh_s3_bucket_endpoint
    s3_bucket_name = var.ovh_s3_bucket_name
  })

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"  # Update this to your instance's user
      private_key = openstack_compute_keypair_v2.ssh_keypair5.private_key
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

  depends_on = [openstack_compute_instance_v2.vm]
  
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
  value     = openstack_compute_keypair_v2.ssh_keypair5.private_key
  sensitive = true
}

output "ovh_cloud_project_database_uri" {
  value = ovh_cloud_project_database.service.endpoints[0].uri
}

output "ovh_cloud_project_database_mongodb_user_name" {
  value = ovh_cloud_project_database_mongodb_user.tf_user.name
}

output "ovh_cloud_project_database_mongodb_user_password" {
  value = ovh_cloud_project_database_mongodb_user.tf_user.password
  sensitive = true
}

output "ovh_s3_access_key" {
  value = var.ovh_s3_access_key
}

output "ovh_s3_secret_key" {
  value = var.ovh_s3_secret_key
  sensitive = true
}

output "ovh_s3_endpoint" {
  value = var.ovh_s3_endpoint
}

output "ovh_s3_bucket_endpoint" {
  value = var.ovh_s3_bucket_endpoint
}

output "ovh_s3_bucket_name" {
  value = var.ovh_s3_bucket_name
}
