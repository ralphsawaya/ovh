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

resource "openstack_compute_keypair_v2" "ssh_keypair7" {
  name = "ssh_keypair7"
}


resource "ovh_cloud_project_database" "service" {
  service_name = var.ovh_project_id
  description  = "benchmark-automation"
  engine       = "mongodb"
  version      = "7.0"
  plan         = "production"
  flavor       = "db2-2"

  nodes {
    region     = var.region
  }
  nodes {
    region     = var.region
  }
  nodes {
    region     = var.region
  }
}

resource "ovh_cloud_project_database_mongodb_user" "tf_user" {
  service_name = ovh_cloud_project_database.service.service_name
  cluster_id   = ovh_cloud_project_database.service.id
  name         = "tf_mongodb_user"
  roles        = ["readWriteAnyDatabase@admin"]
}

resource "openstack_networking_secgroup_v2" "ssh_secgroup6" {
  name        = "ssh_secgroup6"
  description = "Security group for SSH access"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.ssh_secgroup6.id
}

resource "openstack_compute_instance_v2" "vm" {
  name            = "ycsb-benchmark-vm"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh_keypair7.name
  security_groups = [openstack_networking_secgroup_v2.ssh_secgroup6.name]

  network {
    name = "Ext-Net"
  }

  user_data = templatefile("user_data.sh.tpl", {
    cluster_uri = ovh_cloud_project_database.service.endpoints[0].uri
    mongodb_user = split("@", ovh_cloud_project_database_mongodb_user.tf_user.name)[0]
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
      private_key = openstack_compute_keypair_v2.ssh_keypair7.private_key
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
  value     = openstack_compute_keypair_v2.ssh_keypair7.private_key
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
