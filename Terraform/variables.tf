variable "ovh_application_key" {
  description = "OVH application key"
  type        = string
}

variable "ovh_application_secret" {
  description = "OVH application secret"
  type        = string
}

variable "ovh_consumer_key" {
  description = "OVH consumer key"
  type        = string
}

variable "ovh_project_id" {
  description = "OVH Project ID"
  type        = string
}

variable "ovh_s3_endpoint" {
  description = "OVH S3 endpoint"
  type        = string
}

variable "ovh_s3_bucket_endpoint" {
  description = "OVH S3 bucket endpoint"
  type        = string
}

variable "ovh_s3_bucket_name" {
  description = "OVH S3 bucket name"
  type        = string
}

variable "ovh_s3_access_key" {
  description = "OVH S3 access key"
  type        = string
}

variable "ovh_s3_secret_key" {
  description = "OVH S3 secret key"
  type        = string
}

variable "ovh_s3_user_id" {
  description = "OVH S3 secret key"
  type        = string
}

variable "auth_url" {
  description = "OpenStack authentication URL"
  type        = string
}

variable "domain_name" {
  description = "OpenStack domain name"
  type        = string
}

variable "region" {
  description = "OpenStack region"
  type        = string
}

variable "image_name" {
  description = "Name of the image to use for the VM"
  type        = string
}

variable "flavor_name" {
  description = "Name of the flavor to use for the VM"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to use"
  type        = string
  default     = "ssh_keypair"
}

variable "openstack_auth_url" {
  description = "openstack_auth_url"
  type        = string
}

variable "openstack_tenant_name" {
  description = "openstack_auth_url"
  type        = string
}

variable "openstack_domain_name" {
  description = "openstack_auth_url"
  type        = string
}

variable "openstack_user_name" {
  description = "openstack_auth_url"
  type        = string
}

variable "openstack_password" {
  description = "openstack_auth_url"
  type        = string
}

variable "openstack_region" {
  description = "openstack_auth_url"
  type        = string
}


